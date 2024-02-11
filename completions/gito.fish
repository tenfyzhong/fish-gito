complete gito -f
complete -r -f gito -s b -l branch -a "(git --no-pager branch -r | string sub -s 10)" -d 'the branch to open'
complete gito -s e -l echo -d 'echo the result only, do not open it'
complete gito -s r -l root -d 'open root path'
complete -r -F gito -s f -l file -d 'file path'
complete -r -F gito -s l -l line -d 'line number'
complete gito -s h -l help -d 'print this help message'
