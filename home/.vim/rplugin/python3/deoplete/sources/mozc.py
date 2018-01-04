from __future__ import print_function
# import pprint
import sys
import subprocess

PY2 = sys.version_info < (3, 0)
if not PY2:
    basestring = str


class Mozc:

    def __init__(self, mozc_emacs_helper_path="mozc_emacs_helper", debug_func=print):
        self.__debug_func = debug_func
        self.__debug_mode = True
        self.__event_id = 0
        self.__keys = ''

        # コマンドが無いときの処理
        self.__helper = subprocess.Popen(mozc_emacs_helper_path,
                                         stdin=subprocess.PIPE,
                                         stdout=subprocess.PIPE)
        responce = self.__helper.stdout.readline()
        self.__print_debug(responce)
        if not responce:
            self.__print_debug("responce is empty check your 'mozc_emacs_helper' setting.")

        self.create_session()

    def create_session(self):
        oobj = self.communicate('CreateSession')
        self.__session_id = int(oobj["emacs-session-id"])

    def delete_session(self):
        self.communicate('DeleteSession', self.__session_id)

    def send_key(self, key):
        oobj = self.communicate('SendKey', "{0} {1}".format(self.__session_id, key))
        self.__keys += key
        self.__print_debug(oobj)
        return oobj

    def communicate(self, function, arg=""):
        fullmsg = "({0} {1} {2})\n".format(self.__event_id, function, arg)
        self.__helper.stdin.write(bytes(fullmsg.encode("utf-8")))
        self.__helper.stdin.flush()
        self.__event_id += 1
        return self.__parse_sexp(self.__helper.stdout.readline().decode('utf-8'))[0]

    def convert(self, input):
        pass

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
            # self.__debug_func(pprint.pformat(*args))
            self.__debug_func(*args)



