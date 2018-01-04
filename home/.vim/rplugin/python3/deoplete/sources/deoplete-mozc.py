import functools
import os
import re
import sys

from .base import Base
from deoplete.util import debug

sys.path.insert(0, os.path.dirname(__file__))
import mozc


class Source(Base):

    def __init__(self, vim):
        Base.__init__(self, vim)

        self.name = 'mozc'
        self.mark = '[Mozc]'
        self.filetypes = ['hoge']
        self.matchers = []
        self.min_pattern_length = 1
        self.is_volatile = True
        self.rank = 500

    def on_init(self, context):
        vars = context['vars']

        mozc_emacs_helper_path = vars.get('deoplete#sources#mozc#mozc_emacs_helper_path', 'mozc_emacs_helper')

        self.mozc = mozc.Mozc(mozc_emacs_helper_path, functools.partial(debug, self.vim))
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

        oobj = self.mozc.send_key(context["input"][-1])

        # print_debug("Start:", oobj)
        # debug(self.vim, oobj)
        debug(self.vim, oobj)

        candidates = [{'word': c["value"],
                       'abbr': "{0} {1}".format(c["value"], c["annotation"]["description"])}
                      if "annotation" in c and "description" in c["annotation"]
                      else {'word':  c["value"]}
                      for c in oobj['output']["all-candidate-words"]["candidates"]]

        debug(self.vim, candidates)
        return candidates
