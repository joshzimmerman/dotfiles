alias prodaccess='prodaccess --corp_ssh'
alias p='prodaccess --corp_ssh'
export P4DIFF='gvimdiff -f'

git() {
  if [[ $1 == 'merge' ]]; then
    echo 'Use git5 merge, not git merge.  git merge does not understand how to
merge the READONLY link and it can corrupt your branch, so stay away from it.'
    #  type "unset -f git" to remove this warning'
  else
    command git "$@"
  fi
}


