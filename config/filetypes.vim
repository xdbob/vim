autocmd Filetype make setlocal noexpandtab
autocmd FileType python setlocal expandtab
autocmd FileType python setlocal softtabstop=4
autocmd FileType python setlocal shiftwidth=4
autocmd BufNewFile,BufReadPost *.frag,*.vert,*.fp,*.vp,*.glsl setf glsl
