function gito --description "Open repo in browser"
    argparse -X 0 -i 'b/branch=' 'e/echo' 'r/root' 'f/file=!test -e $_flag_value' 'l/line=+!_validate_int --min 1' 'h/help' -- $argv 2>/dev/null

    if test $status -ne 0
        _gito_help
        return 1
    end

    if set -q _flag_help
        _gito_help
        return 0
    end

    set -l gitdir (git rev-parse --git-dir 2>/dev/null)
    if test -z $gitdir
        echo "fatal: Not a git repository" >&2
        return 2
    end

    set -f branch $_flag_branch
    if test -z $branch
        set -f branch (git rev-parse --abbrev-ref HEAD)
    end

    if test -z $branch
        echo "fatal: Not a git repository" >&2
        return 3
    end

    set -l remote_name (git config --get branch.$branch.remote)
    if test -z $remote_name
        echo "fatal: No such remote $branch" >&2
        return 4
    end

    set remote (git remote get-url $remote_name)
    if test -z $remote
        echo "fatal: No such remote $remote_name" >&2
        return 5
    end

    set remote $(string replace -r 'ssh:\/\/git@([^/]+)' 'https:\/\/$1' $remote)
    set remote $(string replace -r 'git@([^/:]+):' 'https:\/\/$1\/' $remote)
    set remote $(string replace -r '.git$' '' $remote)

    if not set -q _flag_root
        set remote "$remote/tree/$branch"

        set -f file $_flag_file
        if test -z "$file"
            set -f file "."
        end

        if test -n $file
            set -l path (realpath $file 2>/dev/null)
            set -l gitroot (git rev-parse --show-toplevel)
            set -l gitroot (realpath $gitroot)
            set -l rootlen (string length $gitroot)
            set -l rootlen (math $rootlen + 1)
            set -l relative (string sub -s $rootlen $path)
            set -l line ''
            if test -n $_flag_file
                set line (_gito_line_param --host $remote $_flag_line)
            end
            set remote "$remote$relative$line"
        end

    end

    echo $remote
    if not set -q _flag_echo
        open "$remote"
    end
end

function _gito_help
    printf %s\n \
        'gito: Open repo in browser' \
        'Usage: gito [options]' \
        '' \
        'Options:' \
        '  -b/--branch <BRANCH>   the branch to open' \
        '  -e/--echo              echo the result only, do not open it' \
        '  -r/--root              open root path' \
        '  -f/--file   <FILE>     file path' \
        '  -l/--line   <LINE...>  line number, support range begin and end' \
        '  -h/--help              print this help message'
end

function _gito_line_delim
    argparse -i 'host=' -- $argv 2>/dev/null
    if test -z $_flag_host
        return 1
    end
    if string match -r -q -- '.*github.com.*' $_flag_host
        echo -n '-L'
    else if string match -r -q -- '.*bitbucket.org.*' $_flag_host
        echo -n ':'
    else
        echo -n '-'
    end
end

function _gito_line_param
    argparse -i 'host=' -- $argv 2>/dev/null
    if test (count $argv) -eq 0
        return 0
    end

    if test (count $argv) -eq 1
        echo "#L$argv"
        return 0
    end

    if test -z $_flag_host
        return 1
    end

    set -l beg $argv[1]
    set -l end $argv[2]

    if test $beg -eq $end
        echo "#L$argv[1]"
        return 0
    end

    if test $beg -gt $end
        set -l t $beg
        set beg $end
        set end $t
    end

    set -l delim (_gito_line_delim --host $_flag_host)
    echo -n "#L$beg$delim$end"
end
