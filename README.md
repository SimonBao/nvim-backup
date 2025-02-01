**This repo is supposed to used as config by NvChad users!**

- The main nvchad repo (NvChad/NvChad) is used as a plugin by this repo.
- So you just import its modules , like `require "nvchad.options" , require "nvchad.mappings"`
- So you can delete the .git from this repo ( when you clone it locally ) or fork it :)

# NvChad Custom Config

This is my custom NvChad configuration with additional plugins and keymaps.

## Essential Keybindings

> Note: Leader key is set to Space

### File Navigation
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fb` - Find buffers
- `<leader>fr` - Frecency search (frequently/recently used files)
- `<leader>fa` - Find in all files (including hidden)
- `<leader>fh` - Search help tags

### Git
- `<leader>gg` - Open LazyGit
- `<leader>gs` - Git status
- `<leader>gb` - Git blame
- `<leader>gf` - Git files (via Telescope)
- `<leader>gc` - Git commits (via Telescope)

### LSP (Code Intelligence)
- `gd` - Go to definition
- `gr` - Show references
- `K` - Show hover documentation
- `<leader>ca` - Code actions
- `<leader>rn` - Rename symbol
- `[d` - Previous diagnostic
- `]d` - Next diagnostic
- `<leader>fm` - Format code

### Window Management
- `<C-h>` - Move to left window
- `<C-l>` - Move to right window
- `<C-j>` - Move to window below
- `<C-k>` - Move to window above
- `<C-q>` - Close window

### Buffer Navigation
- `<tab>` - Next buffer
- `<S-tab>` - Previous buffer
- `<leader>x` - Close current buffer

### Code Folding
- `za` - Toggle fold
- `zR` - Open all folds
- `zM` - Close all folds

### Code Running
- `<leader>rv` - Run code in vertical split
- `<leader>rh` - Run code in horizontal split

### Session Management
- `<leader>fsf` - Find/switch sessions
- `<leader>fss` - Save session
- `<leader>fsl` - Load last session
- `<leader>fsd` - Delete session

### Terminal
- `<C-\>` - Toggle terminal
- `<leader>tt` - Toggle terminal (alternative)

### Spell Checking
- `<leader>ss` - Toggle spell check
- `<leader>sn` - Next misspelled word
- `<leader>sp` - Previous misspelled word
- `<leader>sa` - Add word to spell list
- `<leader>s?` - Suggest corrections

### File Tree
- `<leader>cd` - Open tree at file directory

### Basic Operations
- `jk` - Exit insert mode
- `;` - Enter command mode
- `<leader>ch` - Open cheatsheet

### Text Manipulation
- `cs"'` - Change surrounding quotes from " to '
- `ds"` - Delete surrounding quotes
- `ysiw"` - Add surrounding quotes to word

# Credits

1) Lazyvim starter https://github.com/LazyVim/starter as nvchad's starter was inspired by Lazyvim's . It made a lot of things easier!
