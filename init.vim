source $HOME/.config/nvim/vim-plug/plugins.vim
let g:python3_host_prog = '/Users/simon/.pyenv/versions/neovim3/bin/python'
let g:ruby_host_prog = '~/.rbenv/versions/2.7.3/bin/neovim-ruby-host'
let g:ale_fixers = {
      \   '*': ['remove_trailing_lines', 'trim_whitespace'],
      \   'javascript': ['eslint'],
      \   'ruby': ['rubocop'],
      \}
lua require("simon")
set wildmenu

set splitbelow

nmap <F8> :TagbarToggle<CR>
" setup mapping to call :LazyGit
nnoremap <silent> <leader>gg :LazyGit<CR>


"Completion
set completeopt=menuone,noinsert,noselect
imap <silent> <c-p> <Plug>(completion_trigger)
let g:completion_matching_strategy_list = ['exact', 'substring', 'fuzzy']
let g:completion_trigger_character = ['.', '::']
let g:UltiSnipsExpandTrigger="<c-tab>"
let g:completion_enable_snippet = 'UltiSnips'
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"
let g:completion_chain_complete_list = {
            \ 'default' : {
            \   'default': [
            \       {'complete_items': ['lsp', 'snippet']},
            \       {'mode': '<c-p>'},
            \       {'mode': '<c-n>'}],
            \   'comment': [],
            \   'string' : [
            \       {'complete_items': ['path']}]
            \   }
            \}

" enable mouse controls
:set mouse=a
" imap <tab> <Plug>(completion_smart_tab)
" nnoremap <silent> <C-p> :FZF<CR>
nnoremap <silent> <C-p> :Rg<CR>

noremap <leader>vv :new +setl\ buftype=nofile <bar> 0put =v:oldfiles <bar> nnoremap <lt>buffer> <lt>CR> :e <lt>C-r>=getline('.')<lt>CR><lt>CR><CR><CR>gg
" in new tab
noremap <leader>vt :tabnew +setl\ buftype=nofile <bar> 0put =v:oldfiles <bar> nnoremap <lt>buffer> <lt>CR> :e <lt>C-r>=getline('.')<lt>CR><lt>CR><CR><CR>gg


map <leader>n :lua vim.lsp.diagnostic.goto_next()<cr>
" map <leader>p :lua vim.lsp.diagnostic.goto_prev()<cr>

map <F2> :FloatermNew! cd %:p:h<CR>


"Paper color theme
"set t_Co=256   " This is may or may not needed.
"
"set background=dark
"colorscheme PaperColor

"end
color dracula
set background=dark  " for the light version
set termguicolors
"end

"colorscheme embark
"colorscheme embark
"end

let g:airline#extensions#tabline#enabled = 1
let g:deoplete#enable_at_startup = 1

" ------------- MAPPINGS -------------------
" <TAB>: completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr> <TAB> pumvisible() ? "\<C-y>" : "\<CR>"
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
"inoremap <expr> j ((pumvisible())?("\<C-n>"):("j"))
"imap     <silent><expr>   <S-Tab>     pumvisible() ? "\<C-p>" : "\<Tab>"
"imap     <silent><expr>   <Return>    pumvisible() ? "\<C-x>" : "\<CR>""change leader"
" inoremap <silent><expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"
" use tab to backward cycle
" inoremap <silent><expr><s-tab> pumvisible() ? "\<c-p>" : "\<s-tab>"
" nmap <silent> <Leader> <Plug>(ale_previous_wrap)
nmap <silent> <Leader>p <Plug>(ale_next_wrap)
nmap     <silent>         <Leader>gd  <Plug>(ale_go_to_definition)
"let mapleader=";"
nmap s <Plug>(easymotion-s2)
nmap t <Plug>(easymotion-t2)
map  / <Plug>(easymotion-sn)
omap / <Plug>(easymotion-tn)
map  n <Plug>(easymotion-next)
map  N <Plug>(easymotion-prev)
nnoremap <silent> <Space> :NERDTreeToggle<CR>
"Undo history map hotkey
nnoremap <F5> :UndotreeToggle<CR>
"Replace word
nnoremap cn *``cgn
nnoremap cN *``cgN

"move text
nnoremap <C-j> :m .+1<CR>==
nnoremap <C-k> :m .-2<CR>==
inoremap <C-j> <Esc>:m .+1<CR>==gi
inoremap <C-k> <Esc>:m .-2<CR>==gi
vnoremap <C-j> :m '>+1<CR>gv=gv
vnoremap <C-k> :m '<-2<CR>gv=gv

"keeps screen centered when searching
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap J mzJ`z
"tabs set to 2
"set ts=2

syntax enable
:set number
:set relativenumber
let g:floaterm_keymap_toggle = '<F12>'
let g:floaterm_height = 0.9
let g:floaterm_width = 0.9

"Neovim starts with NERDTree open
autocmd VimEnter * NERDTree
" autocmd VimEnter * wincmd p

" NERDTree on new tab
autocmd BufWinEnter * silent NERDTreeMirror


autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() |
    \ quit | endif

function! Light()
    echom "set bg=light"
    set bg=light
    set list
endfunction

function! Dark()
    echom "set bg=dark"
    color dracula
    set background=dark  " for the light version
    set termguicolors
    "darcula fix to hide the indents:
    set nolist
endfunction

function! ToggleLightDark()
  if &bg ==# "light"
    call Dark()
  else
    call Light()
  endif
endfunction

" undotree
let vimDir = '$HOME/.vim'

if stridx(&runtimepath, expand(vimDir)) == -1
  " vimDir is not on runtimepath, add it
  let &runtimepath.=','.vimDir
endif


" Keep undo history across sessions by storing it in a file
if has('persistent_undo')
    let myUndoDir = expand(vimDir . '/undodir')
    " Create dirs
    call system('mkdir ' . vimDir)
    call system('mkdir ' . myUndoDir)
    let &undodir = myUndoDir
    set undofile
  endif
set undofile                " Save undos after file closes
set undolevels=1000         " How many undos
set undoreload=10000        " number of lines to save for undo
autocmd BufWritePre * :%s/\s\+$//e
autocmd VimEnter * wincmd p

