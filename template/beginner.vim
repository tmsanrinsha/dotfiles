set encoding=utf-8
scriptencoding utf-8
" 1行目: Vim内部で使う文字エンコーディングをUTF-8にする
" 2行名: このVim scriptファイルでUTF-8を使うことを宣言する。マルチバイト文字を使うとき（コメントも含む）に必要
" see [vimrcアンチパターン - rbtnn雑記](http://rbtnn.hateblo.jp/entry/2014/11/30/174749)

" カレントバッファのファイルの文字エンコーディングをUTF-8にする。新規にファイルを作った時などに影響する
set fileencoding=utf-8
" ファイルの読み込み時に文字エンコーディングを判定する順番
set fileencodings=ucs-boms,utf-8,euc-jp,cp932
" 改行コードの設定
set fileformat=unix
" 改行コードを判定する順番
set fileformats=unix,dos,mac
" □や○の文字があったときにカーソル位置がずれないようにする
" singleに設定しておいたほうがいい場合もあるかも
set ambiwidth=double

" 行番号を表示する
set number
" 閉じ括弧が入力されたとき、対応する開き括弧にわずかの間ジャンプする
set showmatch
" マッチを表示する時間を0.1秒にする
set matchtime=1
" ビジュアルベルにして、設定を空にすることで、ビープ音もビジュアルベルも無効化
set visualbell t_vt=
"変更中のファイルでも、保存しないで他のファイルを表示
set hidden
" 挿入モードでの <BS>, <Del>, CTRL-W, CTRL-U の働きの設定
" indent  autoindent を超えてバックスペースを働かせる
" eol     改行を超えてバックスペースを働かせる (行を連結する)
" start   挿入区間の始めでバックスペースを働かせるが CTRL-W と CTRL-U は
"         挿入区間の始めでいったん止まる
set backspace=indent,eol,start
" 画面上でタブ文字が占める幅
set tabstop=4
" 挿入モードで<Tab>を押したときにスペースに展開する。タブそのものを使いたいときはコメントアウト
set expandtab
" <Tab>を挿入したり、<BS>を使った時の幅をtabstopの値と同じにする
" letを使うとtabstopの値を参照できる
" <BS>を使った時に1スペース削除したい場合はコメントアウト
let &softtabstop = &tabstop
" 自動インデントやコマンド<と>などに使われる空白の数。0の場合は'tabstop'と同じ値が使われる
set shiftwidth=0
" コマンド<や>でインデントする際に'shiftwidth'の倍数に丸める
set shiftround

" :help indext.txt
" 後のものが有効にされると、前のものより優先される
set autoindent      " 一つ前の行に基づくインデント
set smartindent     " 'autoindent' と同様だが幾つかのC構文を認識し、適切な箇所のイン
                    " デントを増減させる。
set cindent         " 他の2つの方法よりも賢く動作し、設定することで異なるインデント
                    " スタイルにも対応できる。

" :help fo-table
set formatoptions&
" r Insert modeで<Enter>を押したら、comment leaderを挿入する
set formatoptions+=r
" M マルチバイト文字の連結(J)でスペースを挿入しない
set formatoptions+=M
" t textwidthを使って自動的に折り返す
set formatoptions-=t
" c textwidthを使って、コマントを自動的に折り返しcomment leaderを挿入する
set formatoptions-=c
" o Normal modeでoまたOを押したら、comment leaderを挿入する
set formatoptions+=o

" 不可視文字の表示
set list
" tabに»･、行末の空白に･、ノーブレークスペース文字に%を使う
set listchars=tab:»･,trail:･,nbsp:%

"コマンド入力時にTabを押すと補完メニューを表示する。
set wildmenu
" コマンドモードの補完をシェルの補完のような動きにする
" <TAB>で共通する最長の文字列まで補完して一覧表示
" 再度<Tab>を打つと候補を選択。<S-Tab>で逆
" 決定したい時は文字を打つか、ctrl-eなど。
set wildmode=list:longest,full

" 保存する履歴の数
set history=10000

" インクリメンタルサーチ
set incsearch
" 検索パターンの大文字小文字を区別しない
set ignorecase
" 検索パターンに大文字が含まれていたら、大文字小文字を区別する。
set smartcase
set hlsearch   "検索結果をハイライト

" 最下ウィンドウにいつステータス行が表示されるかを設定する。
" 0: 全く表示しない
" 1: ウィンドウの数が2以上のときのみ表示
" 2: 常に表示
set laststatus=2
" statuslineの設定。lightline.vimなどのプラグインを使うとかっこよくできる
" :help 'statusline'
" f     バッファ内のファイルのパス(入力された通り、またはカレントディレクトリに対する相対パス)
" m     修正フラグ
" =     ここから右寄せ
" r     読み込み専用フラグ
" fenc  ファイルエンコード
" enc   Vim内部で使うエンコード
" ff    ファイルフォーマット（改行コード）
" Y     ファイルタイプ
" P     現在の行がファイル内の何%の位置にあるか
" %v    何列目
" %l    何行目
" set statuslineで設定するとスペースを入れるために'\ '、縦線を入れるために'\|'のようにエスケープしなくてはならないので
" let &statuslineで設定する
let &statusline = '%f%m%=%r%{(&fenc!=""?&fenc:&enc)} | %{&ff} | %Y | %P | %v:%l'

" カーソルの上下に最低でも1行は表示させる
set scrolloff=1

" key mappingに対しては9000ミリ秒待ち、key codeに対しては20ミリ秒待つ
" コマンドラインモードで<Esc>を押した時に消えるのが早くなるなど。
set timeout timeoutlen=9000 ttimeoutlen=20

" アンドゥの履歴をファイルに保存し、Vim を一度終了したとしてもアンドゥやリドゥを行えるようにする
" 開いた時に前回保存時と内容が違う場合はリセットされる
" この挙動が嫌な場合はset noundofileする
if has('persistent_undo')
    set undofile
    " デフォルトではファイルのディレクトリに.<ファイル名>.un~のファイルができるので一箇所にまとめる
    let &undodir = expand('~/.cache/vim/undo')
    if !isdirectory(&undodir)
        call mkdir(&undodir, 'p')
    endif
endif

" マウスを使えるようにする
" altやoptionを押しながら、マウスを使うと、set mouseを設定しない時の動きになる。
" set mouse=a

" カーソルを表示行で移動するようにする
nnoremap j gj
xnoremap j gj
nnoremap <down> gj
xnoremap <down> gj
nnoremap k gk
xnoremap k gk
nnoremap <up> gk
xnoremap <up> gk
nnoremap gj j
xnoremap gj j
nnoremap gk k
xnoremap gk k
nnoremap 0 g0
xnoremap 0 g0
nnoremap $ g$
" ヴィジュアルモード時は$で論理的行末まで行きたいのでコメントアウト
" xnoremap $ g$
nnoremap g0 0
xnoremap g0 0
nnoremap g$ $
xnoremap g$ $

" ESCキー2度押しでハイライトのトグル
nnoremap <Esc><Esc> :<C-u>set hlsearch!<CR>

" %の拡張する。%で開始タグ、終了タグを移動、ifとendifを移動など
runtime macros/matchit.vim

" 256色を使えるようにする
set t_Co=256
" シンタックスハイライトを効かせる
syntax enable
" ファイル形式別のプラグインとインデントを有効にする
filetype plugin indent on
