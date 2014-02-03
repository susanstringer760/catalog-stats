
# Load RVM into a shell session *as a function*
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
  # First try to load from a user install
  source "$HOME/.rvm/scripts/rvm"
elif [[ -s "/usr/local/rvm/scripts/rvm" ]] ; then
  # Then try to load from a root install
  source "/usr/local/rvm/scripts/rvm"
else
  printf "ERROR: An RVM installation was not found.\n"
fi

command="./bin/finder project 1"
# command="./bin/finder datafile"


# 1.9.2-p290 patch install:
# rvm uninstall 1.9.2-p290 && rvm cleanup all && rvm fetch 1.9.2-p290 && rvm install 1.9.2-p290 --patch ruby-1.9.2p290-require.patch


for version in 1.8.7-p352 1.9.2-p180 1.9.2-p290 1.9.3-p0 ; do
# for version in 1.9.3-p0 1.9.2-p290 1.8.7-p352 ; do
# for version in 1.9.2-p290 ; do
  echo $version
  rvm use $version
  # echo `which finder`

  for i in 1 2 3; do
    # command="finder datafile"
  
    echo $command
    time $command > /dev/null
    # time finder datafile
  done;
done;

