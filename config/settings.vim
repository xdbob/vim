set number 			" Numéro de ligne
filetype plugin indent on 	" filetype-specific indent files
syntax on 			" Coloration syntaxique

set shiftwidth=2 		" Taille de l'auto-indent
set showcmd			" Affiche la commande dans barre du bas
set cursorline			" Surligne la ligne du curseur
set wildmenu			" autocomplétion visuelle pour les commandes
set lazyredraw			" Actualise la console uniquement si necessaire
set showmatch			" Surligne les [{()}] correspondants
set incsearch			" Recherche en temps réel
set hlsearch			" Surligne les matchs
highlight OverLength ctermbg=red ctermfg=white guibg=#592929
match OverLength /\%81v.\+/

" Espaces en fin de ligne
set list
set listchars=trail:\.
