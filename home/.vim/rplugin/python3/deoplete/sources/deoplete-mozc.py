from __future__ import print_function
from .base import Base
from deoplete.util import debug
import re
import sys
import subprocess

PY2 = sys.version_info < (3, 0)
if not PY2:
    basestring = str

helper = None
mozc_debug_mode = True
sess_count = 0
msg_count = 0
whitesp = " \t\r\n"
tokens = "()"


def parse_sexp(sexp):
    sexp = sexp.strip(whitesp)
    if sexp[0] == '(':
        ret = []
        remain = sexp[1:]
        while remain[0] != ')':
            e, remain = parse_sexp(remain)
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
        while remain[0] not in whitesp+tokens:
            ret += remain[0]
            remain = remain[1:]
        return ret, remain


def communicate(cmd, arg=""):
    global helper, msg_count
    fullmsg = "({0} {1} {2})\n".format(msg_count, cmd, arg)
    helper.stdin.write(bytes(fullmsg.encode("utf-8")))
    helper.stdin.flush()
    msg_count += 1
    return parse_sexp(helper.stdout.readline().decode('utf-8'))[0]


def print_debug(*args):
    if mozc_debug_mode:
        # debug(self.vim, *args)
        print(*args)


def mozc_start():
    global sess_count
    # start
    oobj = communicate('CreateSession')
    print_debug("Start:", oobj)
    sess_count = int(oobj["emacs-session-id"])


def mozc_stop():
    global sess_count
    print_debug("End:", communicate('DeleteSession ', sess_count))
    sess_count += 1


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'mozc'
        self.mark = '[Mozc]'
        # self.filetypes = ['_']
        self.matchers = []
        self.min_pattern_length = 1
        self.is_volatile = True
        self.rank = 500

        # self.result_keywords = [{'word': x} for x in KEYWORD]
    def on_init(self, context):
        vars = context['vars']

        self.foo = vars.get('deoplete#sources#travis#foo', '')
        self.bar = vars.get('deoplete#sources#travis#bar', False)

        global helper
        global mozc_debug_mode

        helper = subprocess.Popen("mozc_emacs_helper",
                                  stdin=subprocess.PIPE,
                                  stdout=subprocess.PIPE)
        first_responce = helper.stdout.readline()
        print(first_responce)
        if not first_responce:
            print("first_responce is empty check your 'mozc_emacs_helper' setting.")

        mozc_start()

        try:
            # init(load suorce) only work
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
        debug(self.vim, m.start())
        return m.start() if m else -1

    def gather_candidates(self, context):
        # return dict in list ([{},{},{}...])
        debug(self.vim, "input: " + context['input'])
        oobj = communicate('SendKey', "{0} {1}".format(sess_count, context["input"][-1]))["output"]
        # print_debug("Start:", oobj)
        # debug(self.vim, oobj)
        debug(self.vim, oobj["all-candidate-words"])

        candidates = [{'word': c["value"],
                       'abbr': "{0} {1}".format(c["value"], c["annotation"]["description"])}
                      if "annotation" in c and "description" in c["annotation"]
                      else {'word':  c["value"]}
                      for c in oobj["all-candidate-words"]["candidates"]]

        debug(self.vim, candidates)
        # return self.result_keywords
        return candidates
        # return [{'word': 'a'}, {'word': 'b', 'abbr': 'ひらがな'}]
