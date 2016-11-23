# import sys
import os
import datetime
import subprocess

from keyhac import *


def configure(keymap):

    # --------------------------------------------------------------------
    # Text editer setting for editting config.py file

    # Setting with program file path (Simple usage)
    keymap.editor = "MacVim"

    # --------------------------------------------------------------------
    # Customizing the display

    # Font
    keymap.setFont("Osaka-Mono", 16)

    # Theme
    keymap.setTheme("black")

    # --------------------------------------------------------------------
    # global keymap

    # 右Commandを右Optionに変更
    keymap.replaceKey("RCmd", "RAlt")

    keymap_global = keymap.defineWindowKeymap()

    # 左Command単独押しで英数
    keymap_global["O-LCmd"] = "102"
    # 右Command単独押しでかな
    keymap_global["O-RAlt"] = "104"

    # Ctrl+SemicolonでEscして、英数
    keymap_global["Ctrl-Semicolon"] = "Esc", "102"
    keymap_global["Ctrl-OpenBracket"] = "Esc"

    keymap_global["Fn-q"] = keymap.command_RecordToggle
    # keymap_globa;["Fn-1"] = keymap.command_RecordStart
    # keymap_global["Fn-2"] = keymap.command_RecordStop
    keymap_global["Fn-Atmark"] = keymap.command_RecordPlay
    # keymap_global[ "Fn-4" ] = keymap.command_RecordClear

    # config.pyリロード
    keymap_global['Fn-r'] = keymap.command_ReloadConfig

    keymap_global['Alt-b'] = 'Alt-Left'
    keymap_global['Alt-d'] = 'Fn-Alt-Delete'
    keymap_global['Alt-f'] = 'Alt-Right'
    keymap_global['Ctrl-b'] = 'Left'
    keymap_global['Ctrl-f'] = 'Right'
    keymap_global['Ctrl-n'] = 'Down'
    keymap_global['Ctrl-p'] = 'Up'
    keymap_global['Ctrl-w'] = 'Alt-Back'

    keymap_global['Cmd-Ctrl-n'] = 'Down'
    keymap_global['Cmd-Ctrl-p'] = 'Up'
    keymap_global['Cmd-Ctrl-b'] = 'Left'
    keymap_global['Cmd-Ctrl-f'] = 'Right'

    # --------------------------------------------------------------------
    # local keymap

    keymap_local = {}
    for app in ["com.googlecode.iterm2", "org.vim.MacVim"]:
        keymap_local[app] = keymap.defineWindowKeymap(app_name=app)
        keymap_local[app]['Ctrl-b'] = 'Ctrl-b'
        keymap_local[app]['Ctrl-f'] = 'Ctrl-f'
        keymap_local[app]['Ctrl-n'] = 'Ctrl-n'
        keymap_local[app]['Ctrl-p'] = 'Ctrl-p'
        keymap_local[app]['Ctrl-w'] = 'Ctrl-w'
        keymap_local[app]['Alt-b'] = 'Alt-b'
        keymap_local[app]['Alt-d'] = 'Alt-d'
        keymap_local[app]['Alt-f'] = 'Alt-f'

    for app in ["org.mozilla.firefox", "com.google.Chrome"]:
        keymap_local[app] = keymap.defineWindowKeymap(app_name=app)
        keymap_local[app]['Ctrl-b'] = 'Ctrl-b'
        keymap_local[app]['Ctrl-b'] = 'Ctrl-b'
        keymap_local[app]['Ctrl-f'] = 'Ctrl-f'

    for app in ["com.microsoft.Outlook"]:
        keymap_local[app] = keymap.defineWindowKeymap(app_name=app)
        keymap_local[app]['Ctrl-a'] = 'Home'
        keymap_local[app]['Ctrl-e'] = 'End'

    # --------------------------------------------------------------------
    # Clipboard related customization
    keymap_global["Fn-Z"] = keymap.command_ClipboardList      # Open the clipboard history list
    keymap_global["Fn-X"] = keymap.command_ClipboardRotate    # Move the most recent history to tail
    keymap_global["Fn-Shift-X"] = keymap.command_ClipboardRemove    # Remove the most recent history
    keymap.quote_mark = "> "                                          # Mark for quote pasting

    # Maximum number of clipboard history (Default:1000)
    keymap.clipboard_history.maxnum = 1000

    # Total maximum size of clipboard history (Default:10MB)
    keymap.clipboard_history.quota = 10*1024*1024

    # Customizing clipboard history list
    if 1:

        # Fixed phrases
        fixed_items = [
            ( "name@server.net",     "name@server.net" ),
            ( "Address",             "San Francisco, CA 94128" ),
            ( "Phone number",        "03-4567-8901" ),
        ]

        # Return formatted date-time string
        def dateAndTime(fmt):
            def _dateAndTime():
                return datetime.datetime.now().strftime(fmt)
            return _dateAndTime

        # Date-time
        datetime_items = [
            ( "YYYY/MM/DD HH:MM:SS",   dateAndTime("%Y/%m/%d %H:%M:%S") ),
            ( "YYYY/MM/DD",            dateAndTime("%Y/%m/%d") ),
            ( "HH:MM:SS",              dateAndTime("%H:%M:%S") ),
            ( "YYYYMMDD_HHMMSS",       dateAndTime("%Y%m%d_%H%M%S") ),
            ( "YYYYMMDD",              dateAndTime("%Y%m%d") ),
            ( "HHMMSS",                dateAndTime("%H%M%S") ),
        ]

        # Add quote mark to current clipboard contents
        def quoteClipboardText():
            s = getClipboardText()
            lines = s.splitlines(True)
            s = ""
            for line in lines:
                s += keymap.quote_mark + line
            return s

        # Indent current clipboard contents
        def indentClipboardText():
            s = getClipboardText()
            lines = s.splitlines(True)
            s = ""
            for line in lines:
                if line.lstrip():
                    line = " " * 4 + line
                s += line
            return s

        # Unindent current clipboard contents
        def unindentClipboardText():
            s = getClipboardText()
            lines = s.splitlines(True)
            s = ""
            for line in lines:
                for i in range(4+1):
                    if i>=len(line) : break
                    if line[i]=='\t':
                        i+=1
                        break
                    if line[i]!=' ':
                        break
                s += line[i:]
            return s

        full_width_chars = "ａｂｃｄｅｆｇｈｉｊｋｌｍｎｏｐｑｒｓｔｕｖｗｘｙｚＡＢＣＤＥＦＧＨＩＪＫＬＭＮＯＰＱＲＳＴＵＶＷＸＹＺ！”＃＄％＆’（）＊＋，−．／：；＜＝＞？＠［￥］＾＿‘｛｜｝～０１２３４５６７８９　"
        half_width_chars = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ!\"#$%&'()*+,-./:;<=>?@[\]^_`{|}～0123456789 "

        # Convert to half-with characters
        def toHalfWidthClipboardText():
            s = getClipboardText()
            s = s.translate(str.maketrans(full_width_chars,half_width_chars))
            return s

        # Convert to full-with characters
        def toFullWidthClipboardText():
            s = getClipboardText()
            s = s.translate(str.maketrans(half_width_chars,full_width_chars))
            return s

        # Save the clipboard contents as a file in Desktop directory
        def command_SaveClipboardToDesktop():

            text = getClipboardText()
            if not text: return

            # Convert to utf-8 / CR-LF
            utf8_bom = b"\xEF\xBB\xBF"
            text = text.replace("\r\n","\n")
            text = text.replace("\r","\n")
            text = text.replace("\n","\r\n")
            text = text.encode( encoding="utf-8" )

            # Save in Desktop directory
            fullpath = os.path.join( getDesktopPath(), datetime.datetime.now().strftime("clip_%Y%m%d_%H%M%S.txt") )
            fd = open( fullpath, "wb" )
            fd.write(utf8_bom)
            fd.write(text)
            fd.close()

            # Open by the text editor
            keymap.editTextFile(fullpath)

        # Menu item list
        other_items = [
            ( "Quote clipboard",            quoteClipboardText ),
            ( "Indent clipboard",           indentClipboardText ),
            ( "Unindent clipboard",         unindentClipboardText ),
            ( "",                           None ),
            ( "To Half-Width",              toHalfWidthClipboardText ),
            ( "To Full-Width",              toFullWidthClipboardText ),
            ( "",                           None ),
            ( "Save clipboard to Desktop",  command_SaveClipboardToDesktop ),
            ( "",                           None ),
            ( "Edit config.py",             keymap.command_EditConfig ),
            ( "Reload config.py",           keymap.command_ReloadConfig ),
        ]

        # Clipboard history list extensions
        keymap.cblisters += [
            ( "Fixed phrase", cblister_FixedPhrase(fixed_items) ),
            ( "Date-time", cblister_FixedPhrase(datetime_items) ),
            ( "Others", cblister_FixedPhrase(other_items) ),
        ]

    # Fn-A : Sample of assigning callable object to key
    if 1:
        def command_HelloWorld():
            print("Hello World!")

        keymap_global["Fn-A"] = command_HelloWorld

    # Customize TextEdit as Emacs-ish (as an example of multi-stroke key customization)
    # if 1:

        # Define Ctrl-X as the first key of multi-stroke keys
        # keymap_textedit[ "Ctrl-X" ] = keymap.defineMultiStrokeKeymap("Ctrl-X")
        #
        # keymap_textedit[ "Ctrl-P" ] = "Up"                  # Move cursor up
        # keymap_textedit[ "Ctrl-N" ] = "Down"                # Move cursor down
        # keymap_textedit[ "Ctrl-F" ] = "Right"               # Move cursor right
        # keymap_textedit[ "Ctrl-B" ] = "Left"                # Move cursor left
        # keymap_textedit[ "Ctrl-A" ] = "Home"                # Move to beginning of line
        # keymap_textedit[ "Ctrl-E" ] = "End"                 # Move to end of line
        # keymap_textedit[ "Alt-F" ] = "Alt-Right"            # Word right
        # keymap_textedit[ "Alt-B" ] = "Alt-Left"             # Word left
        # keymap_textedit[ "Ctrl-V" ] = "PageDown"            # Page down
        # keymap_textedit[ "Alt-V" ] = "PageUp"               # page up
        # keymap_textedit[ "Ctrl-X" ][ "Ctrl-F" ] = "Cmd-O"   # Open file
        # keymap_textedit[ "Ctrl-X" ][ "Ctrl-S" ] = "Cmd-S"   # Save
        # keymap_textedit[ "Ctrl-X" ][ "U" ] = "Cmd-Z"        # Undo
        # keymap_textedit[ "Ctrl-S" ] = "Cmd-F"               # Search
        # keymap_textedit[ "Ctrl-X" ][ "H" ] = "Cmd-A"        # Select all
        # keymap_textedit[ "Ctrl-W" ] = "Cmd-X"               # Cut
        # keymap_textedit[ "Alt-W" ] = "Cmd-C"                # Copy
        # keymap_textedit[ "Ctrl-Y" ] = "Cmd-V"               # Paste
        # keymap_textedit[ "Ctrl-X" ][ "Ctrl-C" ] = "Cmd-W"   # Exit


    # Activation of specific window
    if 1:
        # Fn-T : Activate Terminal
        keymap_global[ "Fn-T" ] = keymap.ActivateApplicationCommand( "com.apple.Terminal" )


    # Launch subprocess or application
    if 1:

        # Fn-E : Launch TextEdit
        keymap_global[ "Fn-E" ] = keymap.SubProcessCallCommand( [ "open", "-a", "TextEdit" ], cwd=os.environ["HOME"] )

        # Fn-L : Execute ls command
        keymap_global[ "Fn-L" ] = keymap.SubProcessCallCommand( [ "ls", "-al" ], cwd=os.environ["HOME"] )

    # Fn-S : サブスレッド処理のテスト
    if 1:
        def command_JobTest():

            # サブスレッドで呼ばれる処理
            def jobTest(job_item):
                subprocess.call([ "open", "-a", "Notes" ])

            # サブスレッド処理が完了した後にメインスレッドで呼ばれる処理
            def jobTestFinished(job_item):
                print( "Done." )

            job_item = JobItem( jobTest, jobTestFinished )
            JobQueue.defaultQueue().enqueue(job_item)

        keymap_global[ "Fn-N" ] = command_JobTest
