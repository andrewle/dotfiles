function _remote_hostname
  if test -n "$SSH_CONNECTION"
    echo (whoami)@(hostname)
  end
end

function fish_prompt
  set -l cyan (set_color cyan)
  set -l normal (set_color normal)

  set -l cwd (set_color $fish_color_cwd)(prompt_pwd)
  set -l git_status (git_prompt)

  if test -n "$git_status"
    set git_status "$git_status"
  end

  echo -n (_remote_hostname) $cwd $git_status$normal'$ '
end
