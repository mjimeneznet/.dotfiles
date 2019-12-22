# Manage dotfiles
## First time setup
Create a bare repository to store our dotfiles.
```
mkdir $HOME/.dotfiles
git init --bare $HOME/.dotfiles
```
Create an alias to run git for work with our dotfiles repository. Add this to `.bashrc` or `.zshrc`
```
alias dotfiles='/usr/local/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
```
Add a remote a set the status to not show untracked files:
```
dotfiles config --local status.showUntrackedFiles no
dotfiles remote add origin git@github.com:mjimeneznet/.dotfiles.git
```
## Working with dofiles
```
cd $HOME
dotfiles add .tmux.conf
dotfiles commit -m "Add .tmux.conf"
dotfiles push
```
## Setting up a new machine
```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/mjimeneznet/.dotfiles.git ~
./bootstrap.sh
```

Workaround if in the new machine there're default config files:
```
git clone --separate-git-dir=$HOME/.dotfiles https://github.com/mjimeneznet/.dotfiles.git tmpdotfiles
rsync --recursive --verbose --exclude '.git' tmpdotfiles/ $HOME/
rm -r tmpdotfiles
```
