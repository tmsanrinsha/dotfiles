# -*- coding: utf-8 -*-
# startup以下のファイルは辞書順で読み込まれる
# - [IPython起動時にスクリプトを自動的に読み込む - Qiita](http://qiita.com/yuku_t/items/e1b30b85e09cf55c7486)

# [iPythonでコマンド履歴ログ出力を自動化する - ほんじゃら堂](http://blog.honjala.net/entry/2016/06/06/234708)
# from time import strftime
# import os
#
# log_dir = os.path.expanduser('~') + '/.cache/ipython/' + strftime('%Y/%m')
#
# if not os.path.isdir(log_dir):
#     os.makedirs(log_dir)
#
# log_file = log_dir + strftime('/%Y-%m-%d-%H-%M-%S') + ".py"
# # get_ipythonでエラー
# # F821 undefined name 'get_ipython'
# get_ipython().run_line_magic('logstart', '-o -t %s append' % log_file)
#
# del log_dir
# del log_file
