cd ~
ln -s ~/.vim/vimrc ~/.vimrc
cd ~/.vim
# Register the submodules
git submodule init
# Checks out the version of the submodules that were committed
git submodule update
