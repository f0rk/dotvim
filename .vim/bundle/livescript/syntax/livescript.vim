" Syntax highlighting for LiveScript files
" Hopefully this should make LiveScript a bit nicer to write!
syn match lsComment '\(/\*\([^*]\|[\r\n]\|\(\*\+\([^*/]\|[\r\n]\)\)\)*\*\+/\)\|\(//.*\)'
syn match lsFunction '@\w\+'
syn match lsFuncStart '('
syn match lsFuncEnd ')'
syn match lsString '".\{-0,}"'
syn match lsNumber '[-+]\?[0-9]*.\?[0-9]\+'
syn match lsBBCode '\[.\{-0,}\]'
syn match lsHash '#\w\+'
syn match lsVariable '%.\{-0,}%'

hi link lsComment Comment
hi link lsFunction Macro
hi link lsFuncStart Delimiter
hi link lsFuncEnd Delimiter
hi link lsString String
hi link lsNumber Number
hi link lsBBCode Statement
hi link lsHash Special
hi link lsVariable Identifier
