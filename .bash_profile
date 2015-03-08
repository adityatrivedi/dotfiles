### Retrieve git branch name
function get_git_branch() {
  git branch | awk '/^\*/ { print $2 }'
}
### Retrieve git dirty state marker
function get_git_dirty() {
  git diff --quiet || echo '☢'
}

### Retrieve git metadata
function get_git_prompt() {
  git branch &> /dev/null || return 1
  echo " ($(get_git_branch))$(get_git_dirty)"
}

### Pretty print JSON files
function pprintjson() {
  [[ "$#" -eq 1 ]] || { echo "Usage: pprintjson infile.json"; return; }
  cat "$1" | python -m json.tool
}

### Generate ctags for current Git repo
function generate_ctags() {
  dir="`git rev-parse --git-dir`"
  git ls-files | ctags --tag-relative -L - -f "$dir/tags"
}

### Set flags for converting GitHub Markdown to HTML5 with Pandoc
function pandocmark() {
  [[ "$#" -eq 1 ]] || { echo "Usage: pandocmark infile.md"; return; }
  infile=$1
  outfile=$(basename "$infile")
  outfile=${outfile%.*}.html
  pandoc -f markdown_github -t html5 "$infile" -o "$outfile"
  open "$outfile"
}

### Customize prompt to show path in red, git info and prompt character in yellow
export PS1='\[\e[0;31m\]\w\[\e[0m\]\[\e[0;33m\]$(get_git_prompt) → \[\e[0m\]'

export CLICOLOR=1
export EDITOR='vim'
export PATH=$PATH:/Applications/Postgres.app/Contents/Versions/9.3/bin

### If git completion script exists, enable it
if [ -f ~/.git-completion.bash ]; then
  . ~/.git-completion.bash
fi
### If svn completion script exists, enable it
if [ -f ~/.svn-completion.bash ]; then
  . ~/.svn-completion.bash
fi

### Enable colourized output for listing directory contents, append '/' to directories, and extra symbols after various filetypes for differentiation
alias ls='ls -Fah'

### Create shorthand for git
alias g='git'
__git_complete g __git_main

[ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
