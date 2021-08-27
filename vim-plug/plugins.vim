" auto-install vim-plug
if empty(glob('~/.config/nvim/autoload/plug.vim'))
  silent !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  "autocmd VimEnter * PlugInstall
  "autocmd VimEnter * PlugInstall | source $MYVIMRC
endif

call plug#begin('~/.config/nvim/autoload/plugged')
    "Terminal within neovim
    Plug 'neovim/nvim-lsp'
    Plug 'voldikss/vim-floaterm'
    Plug 'tpope/vim-surround'
    Plug 'preservim/tagbar'
    Plug 'kdheepak/lazygit.nvim'
    Plug 'neovim/nvim-lspconfig'
    Plug 'nvim-lua/completion-nvim'
    Plug 'kabouzeid/nvim-lspinstall'
    " Plug 'hrsh7th/vim-vsnip'
    " Plug 'hrsh7th/vim-vsnip-integ'
    " Plug 'aca/completion-tabnine', { 'do': './install.sh' }
    Plug 'SirVer/ultisnips'
    Plug 'honza/vim-snippets'
    Plug 'ap/vim-css-color'
    "Vim database support
    " Plug 'tpope/vim-dadbod'
    " Plug 'kristijanhusak/vim-dadbod-ui'
    "Better Syntax Support
    Plug 'sheerun/vim-polyglot'
    Plug 'mg979/vim-visual-multi', {'branch': 'master'}
    " File Explorer
    Plug 'scrooloose/NERDTree'
    "Commenter
    Plug 'scrooloose/nerdcommenter'
    Plug 'tpope/vim-commentary'
    "LightLine
    Plug 'itchyny/lightline.vim'
    "Undo tree
    Plug 'mbbill/undotree'
    " Auto pairs for '(' '[' '{'
    Plug 'jiangmiao/auto-pairs'
    "Syntax
    Plug 'dense-analysis/ale'
    "Color picker
    Plug 'KabbAmine/vCoolor.vim'
    "Airline for better visual on current line
    Plug 'mattn/emmet-vim'
"syntax
    "Plug 'vim-syntastic/syntastic'
    Plug 'vim-airline/vim-airline'
    "easyMotion
    Plug 'easymotion/vim-easymotion'
    "FZF
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    " Auto Complete"
     " if has('nvim')
	   " Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
	 " else
	   " Plug 'Shougo/deoplete.nvim'
	   " Plug 'roxma/nvim-yarp'
	   " Plug 'roxma/vim-hug-neovim-rpc'
	 " endif
    "Ruby Plugin
    Plug 'tpope/vim-endwise'
    Plug 'vim-ruby/vim-ruby'
    Plug 'tpope/vim-rails'
    "Indent guides
    Plug 'yggdroot/indentline'
    "Themes"
    Plug 'dracula/vim'
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'embark-theme/vim', { 'as': 'embark' }

call plug#end()
