import time
import json
from bs4 import BeautifulSoup

def extract_tr_tags_from_html_file(file_path):
    with open(file_path, 'r') as html_file:
        soup = BeautifulSoup(html_file, 'html.parser')
        
    tr_tags = soup.find_all('tr', onclick=lambda value: value and value.startswith('return manaba.clickChildAnchor'))
    return tr_tags

# Replace 'your_file.html' with your actual html file path
tr_tags = extract_tr_tags_from_html_file('coursesRaw.html')
data_list = []

for tr in tr_tags:
    td_tags = tr.find_all('td')
    data = {
        "schools": td_tags[0].text.split(","), # td_tags[0].text,
        "course": {"href": r"https://ct.ritsumei.ac.jp/"+td_tags[1].a["href"], "titles": [text.split(':')[1] for text in td_tags[1].text.split(" § ")]},
        "codes": [text.split(':')[0] for text in td_tags[1].text.split(" § ")],
        "term": td_tags[2].text,
        "periods": td_tags[3].text.split(","),
        "campuses": td_tags[4].text.split("/"),
        "professors": td_tags[5].text.split("、"),
        "languages": td_tags[6].text.split("/"),
        "credit": int(td_tags[7].text)  # Convert to integer
    }
    data_list.append(data) 

json_data = json.dumps(data_list, ensure_ascii=False, indent=4)

# with open('output2.html', 'a') as f:
#     for tr in tr_tags:
#         f.write(str(tr))
#         f.write('\n')

with open('courses.json', 'w') as json_file:
    json_file.write(json_data)