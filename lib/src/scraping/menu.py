import re
import requests
import os

import time
import json
from bs4 import BeautifulSoup

def download_file(url, target_folder):
    response = requests.get(url, stream=True)
    filename = os.path.join(target_folder, url.split("/")[-1])
    
    if response.status_code == 200:
        with open(filename, 'wb') as file:
            for chunk in response.iter_content(chunk_size=1024):
                if chunk:
                    file.write(chunk)
        print("Downloaded file:", filename)
    else:
        print("Failed to download file:", url)

def extract_li_tags_from_html_file(file_path):
    with open(file_path, 'r') as html_file:
        soup = BeautifulSoup(html_file, 'html.parser')
        
    category_tags = soup.find_all('p', class_='toggleTitle open')
    return category_tags

def extract_li_tags_from_html_url(url):
    response = requests.get(url)
    soup = BeautifulSoup(response.text, 'html.parser')

    # Extract the category
    category = soup.find('h1').text.split()[0]

    # Extract the nutrition data
    detail_list = soup.find_all('li')
    nutrition = {
        "energy": float(re.findall(r'\d+\.?\d*', detail_list[1].find(class_='price').text)[0]),
        "protein": float(re.findall(r'\d+\.?\d*', detail_list[2].find(class_='price').text)[0]),
        "fat": float(re.findall(r'\d+\.?\d*', detail_list[3].find(class_='price').text)[0]),
        "carbohydrates": float(re.findall(r'\d+\.?\d*', detail_list[4].find(class_='price').text)[0]),
        "salt": float(re.findall(r'\d+\.?\d*', detail_list[5].find(class_='price').text)[0]),
        "calcium": float(re.findall(r'\d+\.?\d*', detail_list[6].find(class_='price').text)[0]),
        "veg": float(re.findall(r'\d+\.?\d*', detail_list[7].find(class_='price').text)[0]),
        "iron": float(re.findall(r'\d+\.?\d*', detail_list[8].find(class_='price').text)[0]),
        "vitA": float(re.findall(r'\d+\.?\d*', detail_list[9].find(class_='price').text)[0]),
        "vitB1": float(re.findall(r'\d+\.?\d*', detail_list[10].find(class_='price').text)[0]),
        "vitB2": float(re.findall(r'\d+\.?\d*', detail_list[11].find(class_='price').text)[0]),
        "vitC": float(re.findall(r'\d+\.?\d*', detail_list[12].find(class_='price').text)[0]),
    }

    # Extract the allergy data
    allergy_items = soup.find(class_='icon-list').find_all('li')
    allergy = list({item.get('class')[0].split('_')[1] for item in allergy_items}) # Assuming the class name is "icon_{allergen}"

    # Extract the origin data
    origin = detail_list[13].find(class_='price').text

    # Construct the data dictionary
    data = {

        "nutrition": nutrition,
        "allergy": allergy,
        "origin": origin
    }

    return data

# Replace 'your_file.html' with your actual html file path
category_tags = extract_li_tags_from_html_file('menuraw.html')
data_list = []
for category_tag in category_tags:
    category = category_tag.text.strip()

    # find the next sibling that is a 'div' with class 'catMenu'
    cat_menu_div = category_tag.find_next_sibling('div', class_='catMenu')

    li_tags = cat_menu_div.find_all('li')

    for li in li_tags:
        a_tag = li.find('a')
        h3_tag = a_tag.find('h3')
        evaluation_tags = a_tag.find_all('span', {'id': lambda x: x and x.startswith('rate_')})

        data2 = extract_li_tags_from_html_url("https://west2-univ.jp/sp/" + a_tag.get('href'))

        data = {
            "id" : data_list.__len__(),
            "link": "https://west2-univ.jp/sp/" + a_tag.get('href'),
            "image": a_tag.find('img').get('src').replace("west2-univ.jp/menu_img/png_sp", "fir-flutter-codelab-39c7d.web.app/assets/assets/foodpics"),
            "image_origin": a_tag.find('img').get('src'),
            "name_jp": h3_tag.contents[0],
            "name_en": h3_tag.find('span').text,
            "price": int(h3_tag.find(class_='price').text.replace('¥', '')),  # Removing the currency symbol
            "evaluation": {
                "good": int(evaluation_tags[0].text),
                "average": int(evaluation_tags[1].text),
                "bad": int(evaluation_tags[2].text),
            },
            "category": category,

        }

        data.update(data2)
        

        # url = a_tag.find('img').get('src')
        # target_folder = 'assets/foodpics'
        # os.makedirs(target_folder, exist_ok=True)

        # download_file(url, target_folder)
        data_list.append(data) 
        

json_data = json.dumps(data_list, ensure_ascii=False, indent=4)

# with open('output2.html', 'a') as f:
#     for tr in li_tags:
#         f.write(str(tr))
#         f.write('\n')

with open('menu.json', 'w') as json_file:
    json_file.write(json_data)


