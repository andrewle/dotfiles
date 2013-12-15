function __gitdir
  if test -z $argv[1]
    if test -n "$GIT_DIR"
      test -d $GIT_DIR; or return 1
      echo $GIT_DIR
    else if test -d ".git"
      echo ".git"
    else
      git rev-parse --git-dir ^/dev/null
    end
  else if test -d $argv[1]"/.git"
    echo $argv[1]"/.git"
  else
    echo $argv[1]
  end
end

function git_prompt
  set -l pcmode no
  set -l detached no

  set -l g (__gitdir)
  set -l r ""
  set -l b ""

  if test -z "$g"
    echo ""
    return
  end

  if test -f "$g/rebase-merge/interactive"
    set r "|REBASE-i"
    set b (cat "$g/rebase-merge/head-name")
  else if test -d "$g/rebase-merge"
    set r "|REBASE-m"
    set b (cat "$g/rebase-merge/head-name")
  else
    if test -d "$g/rebase-apply"
      if test -f "$g/rebase-apply/rebasing"
        set r "|REBASE"
      else if test -f "$g/rebase-apply/applying"
        set r "|AM"
      else
        set r "|AM/REBASE"
      end
    else if test -f "$g/MERGE_HEAD"
      set r "|MERGING"
    else if test -f "$g/CHERRY_PICK_HEAD"
      set r "|CHERRY-PICKING"
    else if test -f "$g/BISET_LOG"
      set r "|BISECTING"
    end

    if git symbolic-ref HEAD > /dev/null ^&1
      set b (git symbolic-ref HEAD ^/dev/null)
    else
      set detached yes
      switch "$GIT_PS1_DESCRIBE_STYLE"
        case contains
          set b (git describe --contains HEAD ^/dev/null)
        case branch
          set b (git describe --contains --all HEAD ^/dev/null)
        case describe
          set b (git describe HEAD ^/dev/null)
        case '*'
          set b (git describe --tags --exact-match HEAD ^/dev/null)
      end

      if test "$status" != "0"
        set b (cut -c1-7 "$g/HEAD" 2>/dev/null)"..."; or set b "unknown"
        set b "($b)"
      end
    end
  end

  set -l w ""
  set -l i ""
  set -l s ""
  set -l u ""
  set -l c ""
  set -l p ""

  set inside_git_dir (git rev-parse --is-inside-git-dir 2>/dev/null)
  set inside_work_tree (git rev-parse --is-inside-work-tree 2>/dev/null)
  if test "true" = $inside_git_dir
    set is_bare_repository (git rev-parse --is-bare-repository 2>/dev/null)
    if test "true" = $is_bare_repository
      set c "BARE:"
    else
      set b "GIT_DIR!"
    end
  else if test "true" = $inside_work_tree
    if test -n "$GIT_PS1_SHOWDIRTYSTATE"
      if test (git config --bool bash.showDirtyState) != "false"
        git diff --no-ext-diff --quiet --exit-code; or set -l w "*"
        if git rev-parse --quiet --verify HEAD >/dev/null
          git diff-index --cached --quiet HEAD --; or set -l i "+"
        else
          set -l i "#"
        end
      end
    end

    if test -n "$GIT_PS1_SHOWSTASHSTATE"
      git rev-parse --verify refs/stash > /dev/null ^&1; and set -l s "\$"
    end

    if test -n "$GIT_PS1_SHOWUNTRACKEDFILES"
      if test -n (git ls-files --others --exclude-standard)
        set u "%"
      end
    end

    if test -n "$GIT_PS1_SHOWUPSTREAM"
      __git_ps1_show_upstream
    end
  end

  set -l f "$w$i$s$u"
  set -l gitstring ""
  set -l red (set_color red)
  set -l blue (set_color blue)
  set -l cyan (set_color cyan)
  set -l green (set_color green)
  set -l normal (set_color normal)
  set -l bad_color $red
  set -l ok_color $green
  set -l branch_color $normal
  set -l flags_color $cyan
  set -l branchname (echo $b | sed "s|refs/heads/||")
  set -l branchstring "$c$cyan($branchname)$normal"

  if test $detached = "no"
    set -l branch_color $ok_color
  else
    set -l branch_color $bad_color
  end

  set gitstring "$branch_color$branchstring$normal"

  if test -n "$w$i$s$u$r$p"
    set gitstring "$gitstring "
  end

  if test "$w" = "*"
    set gitstring "$gitstring$bad_color$w"
  end

  if test -n "$i"
    set gitstring "$gitstring$ok_color$i"
  end

  if test -n "$s"
    set gitstring "$gitstring$flags_color$s"
  end

  if test -n "$u"
    set gitstring "$gitstring$bad_color$u"
  end

  set gitstring "$gitstring$normal$r$p"
  echo $gitstring
end
