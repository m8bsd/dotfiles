
" Ur coc-extensions
":CocInstall coc-clangd coc-cmake coc-elixir coc-fzf-preview coc-highlight coc-json coc-just-complete coc-lists coc-lsp-wl coc-tsserver coc-vimlsp coc-yank
syntax on
set nu relativenumber
set cursorline
set is
set autoread | au CursorHold * checktime | call feedkeys("lh")
set splitbelow splitright
set colorcolumn=80
highlight ColorColumn ctermbg=0 guibg=lightgrey
set history=500
set ic
set hls
set undofile
set nobackup
set nowb
set noswapfile
set expandtab " use space instead tabs for indentation"
set tabstop=4 softtabstop=4 shiftwidth=4 	" size of indent = 4
set smartindent
set autoindent
set lbr
"set tw=80
set mouse=n
runtime! ftplugin/man.vim
let $PAGER='most'
"set ttymouse=xterm2
set nocompatible              " be iMproved, required
filetype off                  " required
let mapleader = ','
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lookat these plugins later
" ==========================
" https://github.com/tpope/vim-abolish
" https://github.com/tpope/vim-repeat
" https://github.com/tpope/vim-unimpaired
" https://github.com/vim-scripts/Align
" https://github.com/prabirshrestha/async.vim
" https://github.com/SirVer/ultisnips
"
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
"Plugin 'vivien/vim-linux-coding-style' " don't enable that if you don't play with linux codestyle
Plugin 'VundleVim/Vundle.vim'
Plugin 'frazrepo/vim-rainbow'
Plugin 'vim-airline/vim-airline'
Plugin 'smalinux/vim-airline-themes'
Plugin 'notpratheek/vim-luna'
"Plugin 'ludovicchabant/vim-gutentags' " for Ctags automation
Plugin 'djoshea/vim-autoread'
Plugin 'mileszs/ack.vim'
Plugin 'preservim/tagbar'       "<F8> button
Plugin 'junegunn/fzf', { 'do': { -> fzf#install() }}
Plugin 'junegunn/fzf.vim'
"Plugin 'easymotion/vim-easymotion'
Plugin 'neoclide/coc.nvim', {'branch': 'release'}
"Plugin 'Raimondi/delimitMate'
Plugin 'Raimondi/delimitMate'
Plugin 'Yggdroot/indentLine'
Plugin 'tommcdo/vim-exchange'
Plugin 'bronson/vim-visual-star-search'
Plugin 'godlygeek/tabular'
Plugin 'kamykn/spelunker.vim'
Plugin 'vimwiki/vimwiki'
Plugin 'preservim/vimux'
Plugin 'christoomey/vim-tmux-navigator'
Plugin 'preservim/nerdtree'
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'xolox/vim-session'
Plugin 'xolox/vim-misc'
Plugin 'goerz/jupytext.vim' "Jupyter ipynb files: pip install --user jupytext
Plugin 'junegunn/goyo.vim' " Full screen mode :Goyo
"Plugin 'davidhalter/jedi-vim' " Python man pages
"Plugin 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
Plugin 'junegunn/vim-emoji'
Plugin 'mechatroner/rainbow_csv'

call vundle#end()            " required
filetype plugin indent on    " required

" Start: Coc.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" May need for Vim (not Neovim) since coc.nvim calculates byte offset by count
" utf-8 byte sequence
set encoding=utf-8
" Some servers have issues with backup files, see #649
set nobackup
set nowritebackup

" Having longer updatetime (default is 4000 ms = 4s) leads to noticeable
" delays and poor user experience
set updatetime=300

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved
set signcolumn=yes

" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Use <c-space> to trigger completion
if has('nvim')
  inoremap <silent><expr> <c-space> coc#refresh()
else
  inoremap <silent><expr> <c-@> coc#refresh()
endif

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" GoTo code navigation
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window
nnoremap <silent> K :call ShowDocumentation()<CR>

function! ShowDocumentation()
  if CocAction('hasProvider', 'hover')
    call CocActionAsync('doHover')
  else
    call feedkeys('K', 'in')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming
nmap <leader>rn <Plug>(coc-rename)

" Formatting selected code
xmap <leader>f  <Plug>(coc-format-selected)
nmap <leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s)
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying code actions to the selected code block
" Example: `<leader>aap` for current paragraph
xmap <leader>a  <Plug>(coc-codeaction-selected)
nmap <leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying code actions at the cursor position
nmap <leader>ac  <Plug>(coc-codeaction-cursor)
" Remap keys for apply code actions affect whole buffer
nmap <leader>as  <Plug>(coc-codeaction-source)
" Apply the most preferred quickfix action to fix diagnostic on the current line
nmap <leader>qf  <Plug>(coc-fix-current)

" Remap keys for applying refactor code actions
nmap <silent> <leader>re <Plug>(coc-codeaction-refactor)
xmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)
nmap <silent> <leader>r  <Plug>(coc-codeaction-refactor-selected)

" Run the Code Lens action on the current line
nmap <leader>cl  <Plug>(coc-codelens-action)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Remap <C-f> and <C-b> to scroll float windows/popups
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" Use CTRL-S for selections ranges
" Requires 'textDocument/selectionRange' support of language server
nmap <silent> <C-s> <Plug>(coc-range-select)
xmap <silent> <C-s> <Plug>(coc-range-select)

" Add `:Format` command to format current buffer
command! -nargs=0 Format :call CocActionAsync('format')

" Add `:Fold` command to fold current buffer
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer
command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics
nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
" Manage extensions
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
" End: Coc.vim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" plugin Config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" {{{ nerdtree
nnoremap <F10> :NERDTreeFind<CR>
" }}}

" {{{ vim-gitgutter
let g:gitgutter_map_keys = 0
" }}}

" {{{ lightline.vim config
set laststatus=2
" No show Mode! lightlinw.vim will take care!
set noshowmode " No show Mode! lightlinw.vim will take care!
" Colorscheme configuration
let g:lightline = {
      \ 'colorscheme': 'Tomorrow',
      \ }
" }}}

" {{{ Rainbow brackets config ({{{{}}}})
let g:rainbow_active = 1
let g:rainbow_guifgs = ['RoyalBlue3', 'DarkOrange3', 'DarkOrchid3', 'FireBrick']
let g:rainbow_ctermfgs = ['lightblue', 'lightgreen', 'yellow', 'red', 'magenta']
" }}}

" {{{ Theming
syntax enable
colorscheme luna-term
let g:airline_theme='sohaib'
"let g:airline_section_y='smalinux'
let g:airline_section_y=0
"let g:airline_section_y= airline#section#create(['%b'])
"let g:airline_section_y= airline#section#create(['hi',' hello', ' %b'])
"let g:airline_section_y = '%t'
"let g:airline_section_z = 0
let g:airline_section_z = "%p%% 👻 %l/%L 👻 Col:%c"
" remove filetype:
au VimEnter * let g:airline_section_x = airline#section#create_right(['tagbar']) | :AirlineRefresh
"set cursorline
" }}}

"" {{{ [gutentags] Don't pollute project dirs
"let g:gutentags_cache_dir = '~/.vim/tags/'
"let g:gutentags_gtags_options_file = '~/dotfiles/tags.conf'
"set statusline+=%{gutentags#statusline()}
"" }}}

" {{{ Auto strip trailing spaces when save - https://vi.stackexchange.com/a/456
function! <SID>StripTrailingWhitespaces()
   let l:save = winsaveview()
   keeppatterns %s/\s\+$//e
   call winrestview(l:save)
endfun
autocmd BufWritePre * :call <SID>StripTrailingWhitespaces()
" }}}

" {{{ Clean last search highlighting - https://stackoverflow.com/a/1037182
nnoremap <esc> :noh<return><esc>
nnoremap <esc>^[ <esc>^[
" }}}

" {{{
" multi-word aliases function - https://stackoverflow.com/a/3879737
fun! SetupCommandAlias(from, to)
  exec 'cnoreabbrev <expr> '.a:from
        \ .' ((getcmdtype() is# ":" && getcmdline() is# "'.a:from.'")'
        \ .'? ("'.a:to.'") : ("'.a:from.'"))'
endfun

" :mm <arg> in vert split
" :m <arg> for horisontal split
call SetupCommandAlias("mm", "vert Man")
call SetupCommandAlias("m", "Man")
" }}}

" {{{ open the file at last place I was in it
" https://stackoverflow.com/q/66331167/5688267
augroup vimStartup | au!
    autocmd BufRead * call setpos('.', getpos("'\""))
augroup end
" }}}

" {{{ Zoom / Restore window. <C-w>o
" https://stackoverflow.com/a/26551079/5688267
" function! s:ZoomToggle() abort
"     if exists('t:zoomed') && t:zoomed
"         execute t:zoom_winrestcmd
"         let t:zoomed = 0
"     else
"         let t:zoom_winrestcmd = winrestcmd()
"         resize
"         vertical resize
"         let t:zoomed = 1
"     endif
" endfunction
" command! ZoomToggle call s:ZoomToggle()
" nnoremap <silent> <C-w>o :ZoomToggle<CR>
" }}}

" {{{ Key binding
"Close current buffer
map <F12> :bd!<CR>
" vim backgrund transparent
hi Normal guibg=NONE ctermbg=NONE
" Move between windows
map <C-h> <C-w>h
map <C-j> <C-w>j
map <C-k> <C-w>k
map <C-l> <C-w>l
" for terminal
tnoremap <C-h> <C-\><C-n><C-h>
tnoremap <C-j> <C-\><C-n><C-j>
tnoremap <C-k> <C-\><C-n><C-k>
tnoremap <C-l> <C-\><C-n><C-l>
"
" fixup relative to vim terminal
autocmd WinEnter *
 \ if &buftype ==# 'terminal' |
 \  startinsert |
 \ endif

inoremap <CAPS> <BS>
nmap <F8> :TagbarToggle <CR>
nmap <F9> :Git blame <CR>
" hidden feature ;-)
nnoremap <C-w>n <C-w>s
" }}}

" {{{ Easy motion plugin
" let g:EasyMotion_smartcase = 1
" nmap f <Plug>(easymotion-overwin-f)
" nmap <CR> <Plug>(easymotion-s2)
" }}}

" {{{ vim tabs
nnoremap <Leader>tt :tabnew<CR>
nnoremap <Leader>tq :tabclose<CR>
"nnoremap <Leader>tl :tabnext<CR>
"nnoremap <Leader>th :tabprev<CR>
" }}}

" {{{ FZF
nnoremap <Leader>r :Rg<CR>
nnoremap <Leader>h :History<CR>
nnoremap <Leader>f :call <SID>FilesCurrentCommit()<CR>

function! s:FilesCurrentCommit()
  let commit = ''
  let bufname = expand('%')

  if bufname =~ '^fugitive:'
    let commit = matchstr(bufname, 'fugitive://.*//\zs[a-f0-9]\{7,40\}')
  else
    silent let result = system('git rev-parse --verify "!" 2>/dev/null')
    if v:shell_error == 0
      let commit = trim(system('git rev-parse "!"'))
    endif
  endif

  if !empty(commit)
    call fzf#vim#files('', {
      \ 'source': 'git ls-tree -r --name-only ' . commit,
      \ 'sink': function('s:OpenCommitFile', [commit])
    \ })
  else
    call fzf#vim#files('')
  endif
endfunction

function! s:OpenCommitFile(commit, filename)
  execute 'Gedit ' . a:commit . ':' . a:filename
endfunction
" }}}

" {{{ Yggdroot/indentLine - for indention
let g:indentLine_char_list = ['|', '¦', '┆', '┊']
" }}}

" {{{ Working with tabs
" I don't like tabs! messier and hard to open.
" Just one tab is enough for me.
" }}}

" {{{ no need for ex mode. - move record macro to Q
" https://stackoverflow.com/q/10956261/5688267
nnoremap Q q
nnoremap q <Nop>

" stop <leader>s
nnoremap <leader>s <Nop>
" }}}

" {{{ highlight these words for me.
autocmd Syntax * syntax keyword myTodo
         \ NOTE NOTES PAGE SOHAIB SECTION WARNING ERROR
         \ DONE SMA smalinux SMALINUX REMOVEME DELETEME
   \ containedin=ALL | highlight def link myTodo TODO
" }}}

" Update vimrc no the fly
" what if you want to update your vimrc file in the middle of an editing session?
" and you want to use these settings in this current session...
" this next snippet do that
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"if has("autocmd")
  "autocmd bufwritepost .vimrc source $MYVIMRC
"endif

" {{{ :terminal
" Please don't use :terminal every. I really hate it.
" use any tailing window manager instead
" }}}

" {{{ Folding
" set foldmethod=indent               " not as cool as syntax, but faster
" set foldlevelstart=1               " start unfolded
" " Toggle fold at current position.
" nnoremap <tab> za
" }}}

"nnoremap <leader>ev :vsplit $MYVIMRC<cr>
"nnoremap <leader>sv :source $MYVIMRC<cr>

" {{{ Abbreviations
iabbrev @@ sohaib.amhmd@gmail.com
iabbrev ccopy (C) 2021 Sohaib Mohamed.
iabbrev fff // SMA FIXME
iabbrev rrr // SMA REMOVEME
iabbrev sss // ~~SMA~~
" }}}

" {{{ map H and L
" Map H in normal mode to go to the beginning of the current line.
nnoremap H ^
nnoremap L $
nnoremap 0 <nop>
nnoremap $ <nop>
" }}}

"" :LinuxCodingStyle Plugin
"let g:linuxsty_patterns = [ "/home/sohiab/htop-master", "/linux" ]
"nnoremap <silent> <leader>a :LinuxCodingStyle<cr>
"

" {{{ Plugin 'kamykn/spelunker.vim'
" Improved vim spelling plugin (with camel case support)!
" https://github.com/kamykn/spelunker.vim
" ======================================================
" Zl
" ZT
set nospell
let g:enable_spelunker_vim = 0
" }}}

" {{{
" Remove newbie crutches in Command Mode
cnoremap <Down> <Nop>
cnoremap <Left> <Nop>
cnoremap <Right> <Nop>
cnoremap <Up> <Nop>
" Remove newbie crutches in Insert Mode
inoremap <Down> <Nop>
inoremap <Left> <Nop>
inoremap <Right> <Nop>
inoremap <Up> <Nop>
" Remove newbie crutches in Normal Mode
nnoremap <Down> <Nop>
nnoremap <Left> <Nop>
nnoremap <Right> <Nop>
nnoremap <Up> <Nop>
" Remove newbie crutches in Visual Mode
vnoremap <Down> <Nop>
vnoremap <Left> <Nop>
vnoremap <Right> <Nop>
vnoremap <Up> <Nop>
" }}}

" stop CoC by default (but Coc is enabled)
"let g:coc_start_at_startup=0

" Disable vim plugins for large files - https://superuser.com/q/830207/952491
" $ vim --noplugin filename

" mutt quotes messages

" undo
" Google: keep undo  after close vim
set undodir=~/.vim/undodir


" {{{
" Auto resize Vim splits to active split
" set winwidth=104
" set winheight=10
" set winminheight=5
" set winheight=999
"
" " resize panes
nnoremap <silent> <Right> :vertical resize +5<cr>
nnoremap <silent> <Left> :vertical resize -5<cr>
nnoremap <silent> <Up> :resize +5<cr>
nnoremap <silent> <Down> :resize -5<cr>

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =
" }}}

" {{{ -- vimux --- 😘 💋
let g:VimuxUseNearestPane = 1
map <Leader>rp :VimuxPromptCommand<CR>
map <Leader>rl :VimuxRunLastCommand<CR>
"map <Leader>vc :CloseVimTmuxPanes<CR>
map <Leader>ri :VimuxInterruptRunner<CR>
" }}}

" {{{ session management - auto save vim session on quit and auto reload on start
let g:session_directory = "~/.vim/session"
let g:session_autoload = "no"
let g:session_autosave = "yes"
let g:session_command_aliases = 1
nnoremap <leader>so :OpenSession<CR>
nnoremap <leader>ss :SaveSession
nnoremap <leader>sd :DeleteSession<CR>
nnoremap <leader>sc :CloseSession<CR>
" }}}

"{{{ Welcome message 😈
autocmd VimEnter * echo "😈 <leader>so 😈"
"}}}

" {{{ vim-airline tabs status bar
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'
let g:airline#extensions#tabline#formatter = 'default'
" }}}

" {{{ goyo: full screen mode
nmap <F7> :Goyo <CR>
let g:goyo_height='80%'
let g:goyo_width='80%'

function! s:goyo_enter()
  set number
  set relativenumber
  set linebreak
endfunction

function! s:goyo_leave()
  set nolinebreak
endfunction

autocmd! User GoyoEnter nested call <SID>goyo_enter()
autocmd! User GoyoLeave nested call <SID>goyo_leave()
" }}}

" {{{ Plugin 'junegunn/vim-emoji'
let g:gitgutter_sign_added = emoji#for('small_blue_diamond')
let g:gitgutter_sign_modified = emoji#for('small_orange_diamond')
let g:gitgutter_sign_removed = emoji#for('small_red_triangle')
let g:gitgutter_sign_modified_removed = emoji#for('collision')

set completefunc=emoji#complete
" }}}

" {{{

" replace currently selected text with default register
" without yanking it
" https://superuser.com/a/321726
vnoremap p "_dP
" }}}

" good habit try to use viw -> y then, past over to use viw -> p
" good habit: viW    select by capital W
" motion:  f  t   ;  F   T  https://stackoverflow.com/a/23223763/5688267
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
"
