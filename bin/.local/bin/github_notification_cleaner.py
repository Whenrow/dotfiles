#!/usr/bin/env python3
"""
GitHub Notification Cleaner
============================
Fetches unread GitHub notifications, evaluates them against rules,
and marks matching ones as read.

Setup:
  1. Set GITHUB_TOKEN env var (or use `gh auth token` if gh CLI is installed)
  2. Add your rules in the RULES list below
  3. Run manually or via cron: 0 * * * * /usr/bin/python3 ~/.local/bin/github_notification_cleaner.py

GitHub token needs the `notifications` scope.
"""

import os
import re
import subprocess
import logging
import sys
from typing import Callable
import requests

# ─── Logging ──────────────────────────────────────────────────────────────────

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s %(message)s",
    datefmt="%Y-%m-%dT%H:%M:%S",
)
log = logging.getLogger(__name__)


# ─── Auth ─────────────────────────────────────────────────────────────────────

def get_token() -> str:
    """Resolve GitHub token from env or gh CLI."""
    token = os.environ.get("GITHUB_TOKEN")
    if token:
        return token
    try:
        result = subprocess.run(
            ["gh", "auth", "token"], capture_output=True, text=True, check=True
        )
        return result.stdout.strip()
    except (subprocess.CalledProcessError, FileNotFoundError):
        log.error("No GitHub token found. Set GITHUB_TOKEN or install the gh CLI.")
        sys.exit(1)


# ─── GitHub API client ────────────────────────────────────────────────────────

class GitHubClient:
    BASE = "https://api.github.com"

    def __init__(self, token: str):
        self.session = requests.Session()
        self.session.headers.update({
            "Authorization": f"Bearer {token}",
            "Accept": "application/vnd.github+json",
            "X-GitHub-Api-Version": "2022-11-28",
        })

    def get_unread_notifications(self) -> list[dict]:
        """Return all unread notifications (handles pagination)."""
        notifications = []
        url = f"{self.BASE}/notifications"
        params = {"all": "false", "per_page": 50}
        while url:
            resp = self.session.get(url, params=params)
            resp.raise_for_status()
            notifications.extend(resp.json())
            url = resp.links.get("next", {}).get("url")
            params = {}  # pagination URL already includes params
        return notifications

    def get_thread_details(self, notification: dict) -> dict | None:
        """
        Fetch the latest comment/event for a notification thread.
        Returns a dict with keys: body, state, title, author, merged, draft.
        Returns None if the subject URL is unavailable.
        """
        url = notification.get("subject", {}).get("latest_comment_url") \
            or notification.get("subject", {}).get("url")
        if not url:
            return None
        resp = self.session.get(url)
        if not resp.ok:
            return None
        data = resp.json()
        return {
            "body": data.get("body") or "",
            "state": data.get("state") or "",
            "title": data.get("title") or notification["subject"].get("title", ""),
            "author": (data.get("user") or {}).get("login", ""),
            "merged": data.get("merged", False),
            "draft": data.get("draft", False),
        }

    def mark_thread_as_read(self, thread_id: str) -> None:
        resp = self.session.patch(f"{self.BASE}/notifications/threads/{thread_id}")
        resp.raise_for_status()


# ─── Rule engine ──────────────────────────────────────────────────────────────

class Rule:
    """
    A rule that decides whether a notification should be marked as read.

    predicate receives two arguments:
      - notification: the raw notification dict from the GitHub API
          Useful fields:
            notification["reason"]                    – e.g. "subscribed", "mention", "review_requested"
            notification["repository"]["full_name"]   – e.g. "org/repo"
            notification["subject"]["type"]           – "PullRequest", "Issue", "Release", ...
            notification["subject"]["title"]          – title of the PR / issue / ...
      - details: dict returned by get_thread_details() (may be None if fetch failed)
          Useful fields: body, state, title, author, merged, draft

    Return True to mark as read, False to keep.
    """

    def __init__(self, name: str, predicate: Callable[[dict, dict | None], bool], description: str = ""):
        self.name = name
        self.predicate = predicate
        self.description = description

    def __and__(self, other: "Rule") -> "Rule":
        return Rule(
            name=f"({self.name} AND {other.name})",
            predicate=lambda n, d: self.predicate(n, d) and other.predicate(n, d),
        )

    def __or__(self, other: "Rule") -> "Rule":
        return Rule(
            name=f"({self.name} OR {other.name})",
            predicate=lambda n, d: self.predicate(n, d) or other.predicate(n, d),
        )

    def __invert__(self) -> "Rule":
        return Rule(
            name=f"NOT {self.name}",
            predicate=lambda n, d: not self.predicate(n, d),
        )


# ─── Helpers to build common rules ────────────────────────────────────────────

def reason_is(*reasons: str) -> Rule:
    """Match notifications by reason (subscribed, mention, review_requested, assign, etc.)."""
    return Rule(
        name=f"reason_is({', '.join(reasons)})",
        predicate=lambda n, d: n.get("reason") in reasons,
    )


def repo_matches(pattern: str) -> Rule:
    """Match notifications whose repository full_name matches a regex."""
    rx = re.compile(pattern, re.IGNORECASE)
    return Rule(
        name=f"repo_matches({pattern!r})",
        predicate=lambda n, d: bool(rx.search(n["repository"]["full_name"])),
    )


def subject_type_is(*types: str) -> Rule:
    """Match by subject type: PullRequest, Issue, Release, Discussion, CheckSuite, ..."""
    return Rule(
        name=f"subject_type_is({', '.join(types)})",
        predicate=lambda n, d: n["subject"].get("type") in types,
    )


def title_matches(pattern: str) -> Rule:
    """Match notifications whose subject title matches a regex."""
    rx = re.compile(pattern, re.IGNORECASE)
    return Rule(
        name=f"title_matches({pattern!r})",
        predicate=lambda n, d: bool(rx.search(n["subject"].get("title", ""))),
    )


def body_matches(pattern: str) -> Rule:
    """Match notifications whose latest comment body matches a regex (requires extra API call)."""
    rx = re.compile(pattern, re.IGNORECASE)
    return Rule(
        name=f"body_matches({pattern!r})",
        predicate=lambda n, d: d is not None and bool(rx.search(d["body"])),
    )


def state_is(*states: str) -> Rule:
    """
    Match by PR/issue state.
    Accepted values: "open", "closed", "merged".
    "merged" checks the dedicated merged flag on PRs.
    """
    def predicate(n, d):
        if d is None:
            return False
        if "merged" in states and d.get("merged"):
            return True
        return d.get("state") in states
    return Rule(name=f"state_is({', '.join(states)})", predicate=predicate)


def author_matches(pattern: str) -> Rule:
    """Match by the author login of the latest comment/event."""
    rx = re.compile(pattern, re.IGNORECASE)
    return Rule(
        name=f"author_matches({pattern!r})",
        predicate=lambda n, d: d is not None and bool(rx.search(d["author"])),
    )


def is_bot() -> Rule:
    """Match notifications whose latest comment author is a bot (login ends with [bot])."""
    return Rule(
        name="is_bot",
        predicate=lambda n, d: d is not None and d["author"].endswith("[bot]"),
    )


# ─── YOUR RULES ───────────────────────────────────────────────────────────────
# A notification is marked as read when ANY rule matches.
# Rules are evaluated in order; the first match wins.
#
# You can combine rules with & (AND), | (OR), and ~ (NOT):
#   state_is("merged") & reason_is("review_requested")
#   repo_matches(r"^myorg/infra") & state_is("closed")
#
# Examples (uncomment and adapt):

RULES: list[Rule] = [
    # ── Add your rules below ──────────────────────────────────────────────────

    # Mark as read merged/closed PRs where you were only passively subscribed:
    # subject_type_is("PullRequest") & state_is("merged", "closed") & reason_is("subscribed"),

    # Mark as read all release notifications:
    # subject_type_is("Release"),

    # Mark as read all CI/CD check suite notifications:
    # subject_type_is("CheckSuite"),

    # Mark as read bot-authored comments:
    # is_bot(),

    # Mark as read notifications from a specific repo:
    # repo_matches(r"^myorg/some-noisy-repo"),

    # Mark as read if the latest comment body contains a specific phrase:
    # body_matches(r"this PR has been automatically"),
]


# ─── Main ─────────────────────────────────────────────────────────────────────

def evaluate(notification: dict, client: GitHubClient) -> tuple[bool, str]:
    """
    Evaluate all rules against a notification.
    Thread details are fetched at most once per notification (lazy).
    Returns (should_mark_read, matching_rule_name).
    """
    _details: dict | None | object = ...  # sentinel: not yet fetched

    def get_details():
        nonlocal _details
        if _details is ...:
            _details = client.get_thread_details(notification)
        return _details

    for rule in RULES:
        try:
            if rule.predicate(notification, get_details()):
                return True, rule.name
        except Exception as exc:
            log.warning("Rule %r raised an exception: %s", rule.name, exc)

    return False, ""


def main():
    if not RULES:
        log.warning("No rules defined — nothing to do. Add rules to the RULES list.")
        return

    token = get_token()
    client = GitHubClient(token)

    log.info("Fetching unread notifications…")
    notifications = client.get_unread_notifications()
    log.info("Found %d unread notification(s).", len(notifications))

    marked = 0
    for notif in notifications:
        thread_id = notif["id"]
        repo = notif["repository"]["full_name"]
        title = notif["subject"].get("title", "")
        reason = notif.get("reason", "")

        should_read, rule_name = evaluate(notif, client)

        if should_read:
            log.info("[MARK READ] %s | %s | reason=%s | rule=%r", repo, title, reason, rule_name)
            try:
                client.mark_thread_as_read(thread_id)
                marked += 1
            except requests.HTTPError as exc:
                log.error("Failed to mark thread %s as read: %s", thread_id, exc)
        else:
            log.debug("[KEEP]      %s | %s | reason=%s", repo, title, reason)

    log.info("Done. Marked %d/%d notification(s) as read.", marked, len(notifications))


if __name__ == "__main__":
    main()
