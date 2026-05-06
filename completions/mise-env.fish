complete -c mise-env -f
complete -c mise-env -n __fish_use_subcommand -a none -d 'Clear MISE_ENV'
complete -c mise-env -n __fish_use_subcommand -l clear -d 'Clear MISE_ENV'
complete -c mise-env -n __fish_use_subcommand -l list -d 'List discovered envs'
complete -c mise-env -n __fish_use_subcommand -l show -d 'Print current MISE_ENV'
complete -c mise-env -n __fish_use_subcommand -l help -d 'Show usage'
complete -c mise-env -n __fish_use_subcommand -s h -d 'Show usage'
complete -c mise-env -n __fish_use_subcommand -a '(mise-env --list)' -d 'mise environment'
