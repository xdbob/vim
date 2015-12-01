set nocompatible " Désactivation de la compatibilité Vi

" Activation de pathogen (chargement des plugins
" https://github.com/tpope/vim-pathogen)
call pathogen#infect()
call pathogen#helptags()

runtime! config/**/*.vim " Active tous les fichiers .vim présents dans de dossier config
