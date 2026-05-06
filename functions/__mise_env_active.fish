function __mise_env_active --description 'Print currently active mise env(s), one per line'
    type -q mise; or return 0
    for line in (mise config ls --no-header 2>/dev/null)
        set -l path (string match -r '^\S+' -- $line)
        set -l base (path basename -- $path)
        # Match mise.<env>.toml, .mise.<env>.toml, or config.<env>.toml
        set -l name (string match -rg '^(?:\.?mise|config)\.([^.]+)\.toml$' -- $base)
        test (count $name) -eq 0; and continue
        # mise.local.toml is always loaded regardless of env — skip it
        test "$name" = local; and continue
        echo $name
    end
end
