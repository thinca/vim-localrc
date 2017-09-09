" Enable configuration file of each directory.
" Version: 0.1.3
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if v:version < 700
  finish
endif

let s:save_cpo = &cpo
set cpo&vim

function! s:has_localrc()
  " The user may have disabled the plugin via :let g:loaded_localrc = 1.
  " In this case, we must not invoke the localrc functions. The best way to
  " check is to look for the autocmds installed by localrc.
  return exists('#plugin-localrc#BufReadPost')
endfunction

" Execution order:
" 1. global localrc configuration
" 2. Vim ftplugins
" 3. filetype-specific localrc configuration

augroup filetypeplugin
  " Undo the autocmd from ftplugin.vim.
  au!

  " Execute global localrc configuration before Vim ftplugins.
  autocmd FileType * nested
  \   if s:has_localrc() && !exists('b:localrc_done') |
  \     call localrc#load(g:localrc_filename) |
  \     let b:localrc_done = 1 |
  \   endif
augroup END

" Restore the autocmd from ftplugin.vim; we have to invoke it because it
" installs a script-local function s:LoadFTPlugin().
" Note: We cannot load this via :filetype plugin on, because that one would
" re-execute this after/ftplugin.vim script again, too, and lead to endless
" recursion.
unlet! did_load_ftplugin
runtime ftplugin.vim

" Handle filetype-specific localrc configuration after Vim ftplugins.
augroup filetypeplugin
  autocmd FileType * nested
  \   if s:has_localrc() |
  \     call localrc#loadft(
  \       type(g:localrc_filetype) == type([]) ? copy(g:localrc_filetype)
  \                                            : [g:localrc_filetype],
  \       expand("<amatch>")) |
  \   endif
augroup END


let &cpo = s:save_cpo
unlet s:save_cpo
