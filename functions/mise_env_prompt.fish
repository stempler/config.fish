function mise_env_prompt --description 'Prompt component showing the active mise environment(s)'
    type -q mise; or return
    set -l envs (__mise_env_active)
    test (count $envs) -eq 0; and return

    set_color -d cyan
    printf 'mise:%s' (string join ',' $envs)
    set_color normal
end
