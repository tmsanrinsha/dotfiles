#!/usr/bin/env bash
export PYTHONPATH="$HOME/Downloads/Komodo-PythonRemoteDebugging-11.0.1-90797-macosx/python3lib${PYTHONPATH:+:${PYTHONPATH}}"
echo $PYTHONPATH
~/Downloads/Komodo-PythonRemoteDebugging-11.0.1-90797-macosx/py3_dbgp -d localhost:9000 -f /tmp/python-debug.log $@

# export PYTHONPATH="$HOME/Downloads/Komodo-PythonRemoteDebugging-11.0.1-90797-macosx/pythonlib${PYTHONPATH:+:${PYTHONPATH}}"
# echo $PYTHONPATH
# ~/Downloads/Komodo-PythonRemoteDebugging-11.0.1-90797-macosx/pydbgp -d localhost:9000 -f /tmp/python-debug.log $@
