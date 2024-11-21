" yanorei32's .vimrc
"   Tips: ':source ~/.vimrc' to reload .vimrc

filetype off
filetype plugin indent off

" Plugin
"---------------------------------------

if has('vim_starting')
	set rtp+=~/.vim/plugged/vim-plug
	
	if !isdirectory(expand('~/.vim/plugged/vim-plug'))
		call system('mkdir -p ~/.vim/plugged/vim-plug')
		call system('git clone https://github.com/junegunn/vim-plug.git ~/.vim/plugged/vim-plug/autoload')
	endif
endif

call plug#begin('~/.vim/plugged')

" Plugin Manager
Plug 'junegunn/vim-plug', { 'dir': '~/.vim/plugged/vim-plug/autoload' }

" Syntax
Plug 'w0ng/vim-hybrid'

" Quick Edit
Plug 'tomtom/tcomment_vim'
Plug 'mattn/emmet-vim'
Plug 'tpope/vim-surround'

" Integration
Plug 'tyru/open-browser.vim'
Plug 'kannokanno/previm'
Plug 'embear/vim-localvimrc'

" Window
Plug 'scrooloose/nerdtree'
Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'itchyny/lightline.vim'
Plug 'simeji/winresizer'
Plug 'godlygeek/tabular'

" Language Support
Plug 'hail2u/vim-css3-syntax'
Plug 'jelera/vim-javascript-syntax'
Plug 'vim-scripts/ShaderHighLight'
Plug 'rust-lang/rust.vim'
Plug 'cespare/vim-toml'
Plug 'rcmdnk/vim-markdown'

" LSP
Plug 'prabirshrestha/async.vim'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'w0rp/ale'

call plug#end()

" LSP
"---------------------------------------

set completeopt=menuone,noinsert,noselect
let g:ale_completion_enabled = 1

let g:lsp_inlay_hints_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_document_code_actions_signs_enabled = 0
let g:lsp_auto_enable = 1


" lsp key-bind, copy from nvim repo
nnoremap ==      :LspDocumentFormat<CR>
nnoremap <c-]>   :LspDefinition<CR>
nnoremap K       :LspHover<CR>
nnoremap gD      :LspImplementation<CR>
nnoremap <c-k>   :LspSignatureHelp<CR>
nnoremap 1gD     :LspTypeDefinition<CR>
nnoremap gr      :LspReferences<CR>
nnoremap g0      :LspDocumentSymbol<CR>
nnoremap gW      :LspWorkspaceSymbol<CR>
nnoremap gd      :LspDeclaration<CR>
nnoremap ]e      :LspNextError<CR>
nnoremap [e      :LspPreviousError<CR>


" Lightline / Tab / Tree / Plugin
"---------------------------------------

set laststatus=2
set showtabline=2
set noshowmode

let g:lightline = { 'colorscheme': 'wombat' }
let g:vim_markdown_folding_disabled = 1
let g:localvimrc_persistent = 1

" set [Tag] key
nnoremap [Tag] <Nop>
nmap t [Tag]

" change tab shortcut <t-N>
for n in range(1,9)
	execute 'nnoremap <silent> [Tag]'.n ':<C-u>tabnext'.n.'<CR>'
endfor

nnoremap <silent> [Tag]c :tabnew<CR>
nnoremap <C-n> <plug>NERDTreeTabsToggle<CR>


" Basic
"---------------------------------------

let g:hybrid_reduced_contrast = 1
colorscheme hybrid 

set nocompatible
syntax on
set number
set nowrap
set background=dark
set cursorline
set list listchars=tab:>\ ,trail:-,extends:»,precedes:«
set tabstop=4 shiftwidth=4 autoindent smartindent
set synmaxcol=320
set lazyredraw nottyfast
set regexpengine=1
set timeout timeoutlen=1000 ttimeoutlen=0
set incsearch hlsearch
set encoding=utf-8 termencoding=utf-8
set fileencodings=utf-8,iso-2022-jp,euc-jp,cp932,utf-16le,utf-16,default
set backspace=2

" search word display center
nnoremap n nzz
nnoremap N Nzz

" clear highlight after ctrl-l
nnoremap <silent> <C-l> :<C-u>nohlsearch<CR><C-l>

" Disable multi-line comment
autocmd FileType * setlocal formatoptions-=ro

" Don't break select after ctrl-a and ctrl-x
vnoremap <c-a> <c-a>gv
vnoremap <c-x> <c-x>gv

" Fin
"---------------------------------------

filetype plugin indent on
filetype on
