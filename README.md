# Dot Files

## Links

### Linux

``` bash
PATH=$(PWD)
```

#### Neovim

``` bash
ln -s ${PATH}/init.lua ~/.config/nvim/init.lua
```

#### Tmux

``` bash
ln -s ${PATH}/tmux.conf ~/.config/tmux/tmux.conf
```

### Windows

``` batch
set PATH=C:\Users\%USERNAME%\<...>\Desktop\Documents\Dot-Files
```

#### Neovim

``` batch
mklink C:\Users\%USERNAME%\AppData\Local\nvim "%PATH%\Neovim" /D
```
