# Neovim Configuration

## Key Mappings

### General
- `<Space>` - Leader key
- `jk` - Exit insert mode
- `;` - Enter command mode
- `p` or `P` in visual mode - Paste without yanking deleted text

### File Navigation (Telescope)
- `<leader>ff` - Find files
- `<leader>fg` - Live grep (search in files)
- `<leader>fa` - Grep all files (including hidden)
- `<leader>fb` - Find buffers
- `<leader>fh` - Help tags
- `<leader>fr` - Frecency search (recently used files)

### LSP Features
- `gd` - Go to definition
- `gi` - Go to implementation
- `gr` - Find references
- `K` - Show documentation
- `<C-k>` - Show full documentation in floating window
- `<leader>ca` - Code actions
- `<leader>d` - Show diagnostics
- `<leader>rn` - Rename symbol
- `<leader>ws` - Search workspace symbols

### Git Integration
- `<leader>gg` - Open LazyGit
- `<leader>gs` - Git status
- `<leader>gd` - Git diff split
- `<leader>gb` - Git blame
- `<leader>gl` - Git log
- `<leader>gf` - Git diff vertical split

### Spell Checking
- `<leader>ss` - Toggle spell check
- `<leader>sn` - Next misspelled word
- `<leader>sp` - Previous misspelled word
- `<leader>sa` - Add word to spell list
- `<leader>s?` - Suggest corrections

### Terminal
- `<leader>tt` - Toggle terminal
- `<C-\>` - Toggle terminal (alternative)
- `<leader>tp` - Run Python file

### File Explorer (NvimTree)
- `<leader>cd` - Open tree at file directory

### Multi-Cursor (vim-visual-multi)
- `<C-m>` - Start multi-cursor
- `<C-m>A` - Select all occurrences
- `<C-x>` - Skip current and go to next
- `<C-p>` - Remove current cursor/selection

### Session Management
- `<leader>fss` - Save session
- `<leader>fsr` - Restore session
- `<leader>fsd` - Delete session
- `<leader>fsf` - Find session

### Preview Window Navigation
- `<C-u>/<C-d>` - Scroll up/down
- `<A-j>/<A-k>` - Scroll preview
- `<A-p>` - Toggle preview
- `J/K` - Scroll preview in normal mode

### Window Navigation
- `<C-Up/Down/Left/Right>` - Resize preview window
- `<C-=>` - Reset window size

### Help Navigation
- `q` or `<Esc>` or `<CR>` - Close help/preview window
- `/` - Search in help/preview
- `n/N` - Next/previous search result
- `gg/G` - Go to top/bottom
- `zz` - Center current line

### Telescope Navigation
- `<C-j>/<C-k>` - Move selection up/down
- `<C-n>/<C-p>` - Move selection up/down (alternative)
- `<C-x>` - Split horizontal
- `<C-v>` - Split vertical
- `<C-t>` - Open in new tab
- `<C-q>` - Send to quickfix list
- `<M-q>` - Send selected to quickfix list
- `<C-/>` - Show key bindings
- `<Tab>/<S-Tab>` - Toggle selection and move

### Leap Motion
- Default leap.nvim mappings enabled for quick navigation

Note: 
- `<leader>` is mapped to Space key
- `<C->` means Ctrl key
- `<M->` or `<A->` means Alt key
- `<S->` means Shift key
