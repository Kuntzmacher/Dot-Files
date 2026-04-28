# Dot Files

## Links

### Linux

``` bash
PATH=$(PWD)
```

#### Vim

``` bash
ln -s ${PATH}/Vim/.vimrc ~/.vimrc
```

#### Neovim

``` bash
ln -s ${PATH}/Neovim/init.lua ~/.config/nvim/init.lua
```

#### Tmux

``` bash
ln -s ${PATH}/Tmux/tmux.conf ~/.config/tmux/tmux.conf
```

### Windows

``` batch
set PATH=C:\Users\%USERNAME%\<...>\Desktop\Documents\Dot-Files
```

#### Neovim

``` batch
mklink C:\Users\%USERNAME%\AppData\Local\nvim "%PATH%\Neovim" /D
```
