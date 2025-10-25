#!/usr/bin/env python3
# import bs4
import sys
import mf2py
import json

if __name__ == "__main__":
    info = mf2py.parse(url=sys.argv[1])
    if len(sys.argv) > 2:
        target = sys.argv[2]
    else:
        target = ""
    print(info, file=sys.stderr)
    print(json.dumps(next((item for item in info['items'] if target in item['type']), None)))

