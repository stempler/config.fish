function clone
    git clone $argv
    if test $status -eq 0
        # Extract repo name from last argument (URL or path)
        set repo (basename (string replace -r '\.git$' '' $argv[-1]))
        cd $repo
        mise install
    end
end
