function mise-env --description 'View / select the active MISE_ENV for this shell'
    set -l cmd $argv[1]

    switch "$cmd"
        case -h --help
            __mise_env_usage
        case --list
            __mise_env_discover
        case --show
            __mise_env_active
        case none --clear
            __mise_env_apply ''
        case ''
            __mise_env_pick
        case '*'
            __mise_env_apply $cmd
    end
end

function __mise_env_usage
    echo 'Usage: mise-env [<env> | none | --list | --show | --help]'
    echo ''
    echo '  (no args)   open interactive picker (fzf, falls back to numbered prompt)'
    echo '  <env>       set MISE_ENV=<env> for this shell'
    echo '  none        unset MISE_ENV for this shell; project config env (if any) takes over'
    echo '  --list      print envs available to switch to, one per line'
    echo '  --show      print the currently active env(s) as reported by mise'
end

function __mise_env_discover --description 'Print discovered mise envs available to switch to, one per line'
    set -l envs

    set -l dir $PWD
    while true
        for f in $dir/mise.*.toml $dir/.mise.*.toml
            test -e $f; or continue
            set -l name (string replace -r '^.*/\.?mise\.(.+)\.toml$' '$1' -- $f)
            # mise.local.toml is always loaded regardless of MISE_ENV — skip it
            test "$name" = local; and continue
            set -a envs $name
        end

        test -d $dir/.git; and break
        test "$dir" = /; and break
        set dir (path dirname $dir)
    end

    for f in $HOME/.config/mise/config.*.toml
        test -e $f; or continue
        set -l name (string replace -r '^.*/config\.(.+)\.toml$' '$1' -- $f)
        test "$name" = local; and continue
        set -a envs $name
    end

    test (count $envs) -gt 0; or return 0
    printf '%s\n' $envs | sort -u
end

function __mise_env_apply --description 'Set or clear MISE_ENV and refresh mise immediately'
    set -l value $argv[1]
    if test -z "$value"
        # Erase from global scope only; leave any universal value untouched.
        # Since universal MISE_ENV is stored unexported, mise won't see it.
        set -e -g MISE_ENV
    else
        set -gx MISE_ENV $value
    end
    type -q mise; and mise hook-env -s fish 2>/dev/null | source
end

function __mise_env_pick --description 'Interactive env picker (fzf with read fallback)'
    set -l envs (__mise_env_discover)
    if test (count $envs) -eq 0
        echo 'no mise.<env>.toml found'
        return 0
    end

    # Build header showing what is active and where it comes from
    set -l active (__mise_env_active)
    set -l current
    if test (count $active) -eq 0
        set current 'unset'
    else if set -qx MISE_ENV; and test -n "$MISE_ENV"
        set current (string join ',' $active)' (shell)'
    else
        set current (string join ',' $active)' (project)'
    end

    # Only offer "unset MISE_ENV" when there is a shell-level override to clear
    set -l options $envs
    set -qx MISE_ENV; and set -p options '(unset MISE_ENV)'

    set -l selection
    if type -q fzf
        set selection (printf '%s\n' $options | fzf \
            --prompt='mise env> ' \
            --header="current: $current" \
            --height=~40% \
            --layout=reverse)
        or return 130
    else
        echo "current: $current"
        for i in (seq (count $options))
            printf '  %d) %s\n' $i $options[$i]
        end
        read -P 'select> ' n
        test -n "$n"; or return 130
        if not string match -qr '^\d+$' -- $n
            echo "invalid selection: $n" >&2
            return 1
        end
        if test $n -lt 1 -o $n -gt (count $options)
            echo "out of range: $n" >&2
            return 1
        end
        set selection $options[$n]
    end

    if test "$selection" = '(unset MISE_ENV)'
        __mise_env_apply ''
    else
        __mise_env_apply $selection
    end
end
