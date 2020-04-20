"
" YouCompleteMe options
"

let g:ycm_enable_diagnostic_highlighting = 0
let g:ycm_always_populate_location_list = 1 "default 0


let g:ycm_collect_identifiers_from_tags_files = 1

let g:ycm_global_ycm_extra_conf = "~/.vim/ycm_extra_conf.py"

let g:ycm_goto_buffer_command = 'new-tab'

" Autoclose the info window showing while navigating in the completion list.
let g:ycm_autoclose_preview_window_after_completion = 1
let g:ycm_autoclose_preview_window_after_insertion = 1

nnoremap <F5> :YcmForceCompileAndDiagnostics <CR>
nnoremap <F11> :YcmCompleter GoTo <CR>
