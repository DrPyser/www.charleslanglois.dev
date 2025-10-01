#!/usr/bin/env python3
# import bs4
import sys
import mf2py
import json

if __name__ == "__main__":
    # with open("/tmp/homepage.html") as file:
    #     soup = bs4.BeautifulSoup(file, 'html.parser')
    #     for h_card in soup.css.iselect('.h-card'):
    #         name = h_card.select_one('.p-name')
    #         if name:
    #             print(name.get_text(' ', strip=True))
    #         if (url := h_card.select_one('.u-url')):
    #             print(url['href'])
    #         if (email := h_card.select_one('.u-email')):
    #             print(email['href'])
    info = mf2py.parse(url=sys.argv[1])
    print(info, file=sys.stderr)
    print(json.dumps(next((item for item in info['items'] if 'h-card' in item['type']), None)))

