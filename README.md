# Dot Files

## Links

### Linux

#### Vim

``` bash
ln -s $(PWD)/Vim/.vimrc ~/.vimrc
```

#### Neovim

``` bash
ln -s $(PWD)/Neovim/init.lua ~/.config/nvim/init.lua
```

#### Tmux

``` bash
ln -s $(PWD)/Tmux/tmux.conf ~/.config/tmux/tmux.conf
```

#### inputrc

``` bash
ln -s $(PWD)/InputRC/.inputrc ~/.inputrc
```

### Windows

> open the cmd as admin

``` batch
set PATH=C:\Users\%USERNAME%\<...>\Desktop\Documents\Dot-Files
```

#### Neovim

``` batch
mklink C:\Users\%USERNAME%\AppData\Local\nvim "%PATH%\Neovim" /D
mklink C:\Users\%USERNAME%\AppData\Local\nvim\init.vim "%PATH%\Vim\.vimrc" /D
```
