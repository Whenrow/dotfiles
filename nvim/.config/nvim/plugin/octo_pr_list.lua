-- Command: OctoPrListCurrentRepo
-- Lists PRs for the repo detected from the current buffer (like Fugitive)

local function get_git_root()
  local buf_path = vim.fn.expand('%:p')
  local git_dir = vim.fn.finddir('.git', vim.fn.fnamemodify(buf_path, ':h') .. ';')
  if git_dir == '' then return nil end
  return vim.fn.fnamemodify(git_dir, ':h')
end

local function get_github_repo()
  local git_root = get_git_root()
  if not git_root then return nil end
  local remote_url = vim.fn.system({'git', '-C', git_root, 'remote', 'get-url', 'origin'})
  remote_url = vim.trim(remote_url)
  local repo = remote_url:match('github.com[:/](.-)%.git$') or remote_url:match('github.com[:/](.-)$')
  return repo
end

vim.api.nvim_create_user_command('ListPr', function()
  local repo = get_github_repo()
  if not repo then
    print('Could not detect GitHub repo from current buffer')
    return
  end
  vim.cmd('Octo pr list ' .. repo)
end, {desc = 'List PRs for current GitHub repo'})
