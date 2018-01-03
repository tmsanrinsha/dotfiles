from __future__ import print_function
from .base import Base
from deoplete.util import debug
import functools
import re
import sys
import subprocess

PY2 = sys.version_info < (3, 0)
if not PY2:
    basestring = str


class Mozc:

    def __init__(self, mozc_emacs_helper_path, debug_func=print):
        self.__debug_func = debug_func
        self.__debug_mode = True

        # コマンドが無いときの処理
        self.__helper = subprocess.Popen(mozc_emacs_helper_path,
                                         stdin=subprocess.PIPE,
                                         stdout=subprocess.PIPE)
        responce = self.__helper.stdout.readline()
        self.__print_debug(responce)
        if not responce:
            self.__print_debug("responce is empty check your 'mozc_emacs_helper' setting.")

        self.__event_id = 0

        self.create_session()

    def create_session(self):
        oobj = self.communicate('CreateSession')
        self.__session_id = int(oobj["emacs-session-id"])

    def delete_session(self):
        self.communicate('DeleteSession', self.__session_id)

    def sendkey(self, key):
        oobj = self.communicate('SendKey', "{0} {1}".format(self.__session_id, key))
        return oobj['output']

    def convert(self, input):
        pass

    def communicate(self, function, arg=""):
        fullmsg = "({0} {1} {2})\n".format(self.__event_id, function, arg)
        self.__helper.stdin.write(bytes(fullmsg.encode("utf-8")))
        self.__helper.stdin.flush()
        self.__event_id += 1
        return self.__parse_sexp(self.__helper.stdout.readline().decode('utf-8'))[0]

    def __parse_sexp(self, sexp):
        WHITE_SP = " \t\r\n"
        TOKENS = "()"

        sexp = sexp.strip(WHITE_SP)
        if sexp[0] == '(':
            ret = []
            remain = sexp[1:]
            while remain[0] != ')':
                e, remain = self.__parse_sexp(remain)
                ret.append(e)
            if len(ret) == 3 and ret[1] == '.':
                ret = (ret[0], ret[2])
            elif len(ret) > 1 and isinstance(ret[0], basestring):
                ret = (ret[0], ret[1:])
            if all(isinstance(e, tuple) for e in ret):
                ret = dict(ret)
            return ret, remain[1:]
        elif sexp[0] == '"':
            ret = u''
            escaped = False
            remain = sexp[1:]
            while escaped or remain[0] != '"':
                if escaped:
                    escaped = False
                    ret += remain[0]
                    remain = remain[1:]
                elif remain[0] == '\\':
                    escaped = True
                    remain = remain[1:]
                else:
                    ret += remain[0]
                    remain = remain[1:]
            return ret, remain[1:]
        else:
            ret = ''
            remain = sexp
            while remain[0] not in WHITE_SP + TOKENS:
                ret += remain[0]
                remain = remain[1:]
            return ret, remain

    def __print_debug(self, *args):
        if self.__debug_mode:
            self.__debug_func(*args)


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'mozc'
        self.mark = '[Mozc]'
        # self.filetypes = ['yaml']
        self.matchers = []
        self.min_pattern_length = 1
        self.is_volatile = True
        self.rank = 500

    def on_init(self, context):
        vars = context['vars']

        mozc_emacs_helper_path = vars.get('deoplete#sources#mozc#mozc_emacs_helper_path', 'mozc_emacs_helper')

        self.mozc = Mozc(mozc_emacs_helper_path, functools.partial(debug, self.vim))
        try:
            # self.mozc = Mozc(mozc_emacs_helper_path)
            pass
        except Exception:
            # Ignore the error
            pass

    def on_event(self, context):
        if context['event'] == 'BufRead':
            try:
                # vim autocmd event based works
                pass
            except Exception:
                # Ignore the error
                pass

    def get_complete_position(self, context):
        m = re.search(r'[a-zA-Z0-9_]*$', context['input'])
        debug(self.vim, 'start: ' + str(m.start()))
        return m.start() if m else -1

    def gather_candidates(self, context):
        debug(self.vim, "input: " + context['input'])
        # # 変換したいローマ字を送る
        # input = context['input']
        # candidates = self.mozc.convert(input)

        # oobj = communicate('SendKey', "{0} {1}".format(sess_count, context["input"][-1]))["output"]
        oobj = self.mozc.sendkey(context["input"][-1])

        # print_debug("Start:", oobj)
        # debug(self.vim, oobj)
        debug(self.vim, oobj)

        candidates = [{'word': c["value"],
                       'abbr': "{0} {1}".format(c["value"], c["annotation"]["description"])}
                      if "annotation" in c and "description" in c["annotation"]
                      else {'word':  c["value"]}
                      for c in oobj["all-candidate-words"]["candidates"]]

        debug(self.vim, candidates)
        return candidates
