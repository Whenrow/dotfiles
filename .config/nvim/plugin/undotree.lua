local autosession = require("auto-session")
autosession.setup {
    log_level = "error",
    suppressed_dirs = { "~/", "~/Projects", "~/Downloads", "/"},
}
