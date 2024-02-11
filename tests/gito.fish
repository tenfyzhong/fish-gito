function git
    if test -z "$argv"
        return 1
    end

    set subcommand $argv[1]
    switch $subcommand 
        case rev-parse
            set flag $argv[2]
            switch $flag
                case --git-dir
                    echo $gito_git_dir
                case --abbrev-ref
                    echo $gito_git_abbrev_ref
                case --show-toplevel
                    echo $gito_git_show_toplevel
            end
        case config
            echo $gito_git_config
        case remote
            echo $gito_git_remote
        case --no-pager
            echo '  origin/main'
            echo '  origin/init'
            echo '  origin/branchv2'
    end
end

function demock_git
    set -e gito_git_dir
    set -e gito_git_abbrev_ref
    set -e gito_git_show_toplevel
    set -e gito_git_config
    set -e gito_git_remote
end

function open
    echo "open:$argv[1]"
end

set home (mktemp -d)
@echo "======home:$home======"
cd $home

@test 'not a git repository, status' (gito) $status -eq 2
@test 'not a git repository, output' (gito 2>&1) = 'fatal: Not a git repository'

set -g gito_git_dir .git
@test 'no branch, status' (gito) $status -eq 3
@test 'no branch, output' (gito 2>&1) = 'fatal: Not a git repository'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
@test 'no such remote, status' (gito) $status -eq 4
@test 'no such remote, output' (gito 2>&1) = 'fatal: No such remote main'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
@test 'no such remote origin, status' (gito) $status -eq 5
@test 'no such remote origin, output' (gito 2>&1) = 'fatal: No such remote origin'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
@test 'success, status' (gito &>/dev/null) $status -eq 0
@test 'success, output' (gito | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/main
open:https://github.com/tenfyzhong/fish-gito/tree/main'
demock_git

@test 'gito parse args failed, status' (gito -x &>/dev/null) $status -eq 1
@test 'gito parse args failed, output' (gito -x | string collect) = 'gito: Open repo in browser
Usage: gito [options]

Options:
  -b/--branch <BRANCH>   the branch to open
  -e/--echo              echo the result only, do not open it
  -r/--root              open root path
  -f/--file   <FILE>     file path
  -l/--line   <LINE...>  line number, support range begin and end
  -h/--help              print this help message'

@test 'gito -h, status' (gito -h &>/dev/null) $status -eq 0
@test 'gito -h' (gito -h | string collect) = 'gito: Open repo in browser
Usage: gito [options]

Options:
  -b/--branch <BRANCH>   the branch to open
  -e/--echo              echo the result only, do not open it
  -r/--root              open root path
  -f/--file   <FILE>     file path
  -l/--line   <LINE...>  line number, support range begin and end
  -h/--help              print this help message'

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 -l2 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 -l2 | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1-L2
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1-L2'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l2 -l1 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l2 -l1 | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1-L2
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1-L2'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 -l1 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 -l1 | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1'
demock_git

set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt'
demock_git


set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@github.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l 1 -r &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l 1 -r | string collect) = 'https://github.com/tenfyzhong/fish-gito
open:https://github.com/tenfyzhong/fish-gito'
demock_git


set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@bitbucket.org:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 -l2 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 -l2 | string collect) = 'https://bitbucket.org/tenfyzhong/fish-gito/tree/init/file.txt#L1:2
open:https://bitbucket.org/tenfyzhong/fish-gito/tree/init/file.txt#L1:2'
demock_git


set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote git@gitlab.com:tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 -l2 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 -l2 | string collect) = 'https://gitlab.com/tenfyzhong/fish-gito/tree/init/file.txt#L1-2
open:https://gitlab.com/tenfyzhong/fish-gito/tree/init/file.txt#L1-2'
demock_git


set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote ssh://git@github.com/tenfyzhong/fish-gito.git
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 -l1 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 -l1 | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1'
demock_git


set -g gito_git_dir .git
set -g gito_git_abbrev_ref main
set -g gito_git_config origin
set -g gito_git_remote ssh://git@github.com/tenfyzhong/fish-gito
set -g gito_git_show_toplevel $home
touch file.txt
@test 'success, status' (gito -b init -f file.txt -l1 -l1 &>/dev/null) $status -eq 0
@test 'success, output' (gito -b init -f file.txt -l1 -l1 | string collect) = 'https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1
open:https://github.com/tenfyzhong/fish-gito/tree/init/file.txt#L1'
demock_git


@test 'complete -b' (complete -C 'gito -b ' | string collect) = 'branchv2	the branch to open
init	the branch to open
main	the branch to open'

touch filr.txt
@test 'complete -f ' (complete -C 'gito -f ' | string collect) = 'file.txt
filr.txt'

rm -rf $home
