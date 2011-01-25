" Enable configuration file of each directory.
" Version: 0.1.2
" Author : thinca <thinca+vim@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

if exists('g:loaded_localrc')
  finish
endif
let g:loaded_localrc = 1

let s:save_cpo = &cpo
set cpo&vim

if !exists('g:localrc_filename')
  let g:localrc_filename = '.local.vimrc'
endif

if !exists('g:localrc_filetype')
  let g:localrc_filetype = '/^\.local\..*\<%s\>.*\.vimrc$'
endif


augroup plugin-localrc  " {{{
  autocmd!
  autocmd BufNewFile,BufReadPost * call localrc#load(g:localrc_filename)
  autocmd FileType *
  \   call localrc#load(
  \     map(type(g:localrc_filetype) == type([]) ? copy(g:localrc_filetype)
  \                                              : [g:localrc_filetype],
  \         'printf(v:val, expand("<amatch>"))'))
augroup END  " }}}


let &cpo = s:save_cpo
unlet s:save_cpo
