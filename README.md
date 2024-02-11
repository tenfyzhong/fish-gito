# fish-gito
[![GitHub tag](https://img.shields.io/github/tag/tenfyzhong/fish-gito.svg)](https://github.com/tenfyzhong/fish-gito/tags)

Open repo  in browser

# Usage
This plugin will generate the repo url and open it in browser. 

```
gito: Open repo in browser
Usage: gito [options]

Options:
  -b/--branch <BRANCH>   the branch to open
  -e/--echo              echo the result only, do not open it
  -r/--root              open root path
  -f/--file   <FILE>     file path
  -l/--line   <LINE...>  line number
  -h/--help              print this help message
```

Example:
```
gito -b main -f functions/gito.fish -l 10 -l 20
```

# install 
Install using Fisher(or other plugin manager):
```
fisher install tenfyzhong/fish-gito
```
