scriptencoding utf-8

" plasticboy/markdownのmkdNonListItemにjez/vim-github-hubのghhubCommentを追加。
" これをしないとmkdNonListItemの設定が優先されてCommentの色がつかない
syn cluster mkdNonListItem contains=@htmlTop,htmlItalic,htmlBold,htmlBoldItalic,mkdFootnotes,mkdInlineURL,mkdLink,mkdLinkDef,mkdLineBreak,mkdBlockquote,mkdCode,mkdRule,htmlH1,htmlH2,htmlH3,htmlH4,htmlH5,htmlH6,mkdMath,ghhubComment
