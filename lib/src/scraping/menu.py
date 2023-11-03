import re
import requests
import os
from urllib.parse import urlparse
import time
import json
from bs4 import BeautifulSoup

from menuGetImageUrl import fetch_url_from_storage, upload_to_storage, delete_files_in_folder

cafeteria_names = [
    "KIC3",
    "KIC2",
    "KIC1",
    # "BKC3",
    "BKC2",
    "BKC1",
    "OIC"
]


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

    def get_value_from_element(element, index):
    # Ensure the index is within bounds
        if index < len(element):
            text_content = element[index].find(class_='price').text
            matches = re.findall(r'\d+\.?\d*', text_content)
            
            # Return the matched value if exists, otherwise 0
            return float(matches[0]) if matches else 0.0
        return 0.0

    nutrition = {
        "energy": get_value_from_element(detail_list, 1),
        "protein": get_value_from_element(detail_list, 2),
        "fat": get_value_from_element(detail_list, 3),
        "carbohydrates": get_value_from_element(detail_list, 4),
        "salt": get_value_from_element(detail_list, 5),
        "calcium": get_value_from_element(detail_list, 6),
        "veg": get_value_from_element(detail_list, 7),
        "iron": get_value_from_element(detail_list, 8),
        "vitA": get_value_from_element(detail_list, 9),
        "vitB1": get_value_from_element(detail_list, 10),
        "vitB2": get_value_from_element(detail_list, 11),
        "vitC": get_value_from_element(detail_list, 12),
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

def menu_html_to_json(rawhtml, cafeteria_name):
    # Replace 'your_file.html' with your actual html file path
    category_tags = extract_li_tags_from_html_file("assets/rawHtmls/"+rawhtml)
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

            # Download the image START
            url = a_tag.find('img').get('src')
            target_folder = 'assets/foodpics'
            os.makedirs(target_folder, exist_ok=True)
            file_name = urlparse(url).path.split('/')[-1]
            file_path = os.path.join(target_folder, file_name)
            if not os.path.exists(file_path):
                download_file(url, target_folder)
            # Download the image END
                # Upload the image to Firebase Storage START
                local_path = a_tag.find('img').get('src').replace("https://west2-univ.jp/menu_img/png_sp", "assets/foodpics")
                cloud_path = a_tag.find('img').get('src').replace("https://west2-univ.jp/menu_img/png_sp", "menu/pics")
                upload_to_storage(local_path, cloud_path)
                # Upload the image to Firebase Storage END
            else:
                print("File already exists:", file_path)


            data = {
            "cafeteria": cafeteria_name,
            "id" : data_list.__len__(),
            "link": "https://west2-univ.jp/sp/" + a_tag.get('href'),
            "image": a_tag.find('img').get('src').replace("https://west2-univ.jp/menu_img/png_sp", "menu/pics"),
            "image_appUrl" : fetch_url_from_storage(a_tag.find('img').get('src').replace("https://west2-univ.jp/menu_img/png_sp", "menu/pics")),
            "image_origin": a_tag.find('img').get('src'),
            "name_jp": h3_tag.contents[0],
            "name_en": h3_tag.find('span').text,
            "price": int(h3_tag.find(class_='price').text.replace('¥', '')),  # Removing the currency symbol
            "evaluation": {
                "good": int(evaluation_tags[0].text),
                "average": int(evaluation_tags[1].text),
                "bad": int(evaluation_tags[2].text),
            },
            "category": category.replace('　', ' '),
        }

            data.update(data2)
            data_list.append(data) 

    json_data = json.dumps(data_list, ensure_ascii=False, indent=4)
    return json_data

def html_to_json():
    for cafeteria_name in cafeteria_names:
        rawhtml = "menuraw" + cafeteria_name + ".html"
        json_data = menu_html_to_json(rawhtml, cafeteria_name)
        with open("assets/jsons/menu" + cafeteria_name + ".json", 'w') as json_file:
            json_file.write(json_data)
        upload_to_storage("assets/jsons/menu" + cafeteria_name + ".json", 'menu/menu' + cafeteria_name + ".json")

"""
export GOOGLE_APPLICATION_CREDENTIALS="/Users/hanpark/development/keys/fir-flutter-codelab-39c7d-firebase-adminsdk-a25ao-1df95655ac.json"
"""




"""
input: weekly cronjob?
output: menu.json file uploaded to firestore

current process:
	1. copy entire expanded page to menuraw.html --> can't, manual
	2. run menu.py(it download, upload, and delete files in Firebase Storage with pictures and menu.json)
"""