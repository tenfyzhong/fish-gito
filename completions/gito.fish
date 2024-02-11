complete gito -f
complete -r -f gito -s b -l branch -a "(git --no-pager branch -r | grep -v '/HEAD' | string replace -r '^\s*[^/]*\/' '')" -d 'the branch to open'
complete gito -s e -l echo -d 'echo the result only, do not open it'
complete gito -s r -l root -d 'open root path'
complete -r -F gito -s f -l file -d 'file path'
complete -r gito -s l -l line -d 'line number, support range begin and end'
complete gito -s h -l help -d 'print this help message'
