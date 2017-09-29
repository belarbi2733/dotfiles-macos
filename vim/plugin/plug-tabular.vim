" plugin/plug-tabular.vim

if !dkoplug#plugins#Exists('tabular') | finish | endif

let s:cpo_save = &cpoptions
set cpoptions&vim

vnoremap  <silent><special> <Leader>a"   :Tabularize /"<CR>
vnoremap  <silent><special> <Leader>a&   :Tabularize /&<CR>
vnoremap  <silent><special> <Leader>a-   :Tabularize /-<CR>
vnoremap  <silent><special> <Leader>a=   :Tabularize /=<CR>
vnoremap  <silent><special> <Leader>af   :Tabularize /=>/<CR>
" align the following as `noSpaceBefore: spaceAfter`
vnoremap  <silent><special> <Leader>a:   :Tabularize /:\zs/l0l1<CR>
vnoremap  <silent><special> <Leader>a,   :Tabularize /,\zs/l0l1<CR>

let &cpoptions = s:cpo_save
unlet s:cpo_save
