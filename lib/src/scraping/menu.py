import re
import requests
import os

import time
import json
from bs4 import BeautifulSoup

appUrl_list = [r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814279.png?alt=media&token=869d2bbf-7ab4-4a5d-8f05-1ffcd2f33d70",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814005.png?alt=media&token=f93b4f53-d7b5-41ef-82a7-cde9a06098d2",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814012.png?alt=media&token=cc7298bc-bb51-4129-85b1-30640787d3c8",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814146.png?alt=media&token=e25ba57d-9384-48a7-979f-d8d3d76d448d",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814201.png?alt=media&token=7847e689-d3ae-4a8f-a7ef-a0229e298eab",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814079.png?alt=media&token=8e1d539e-d255-4f04-a14a-8ef2725ba732",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814290.png?alt=media&token=6f9008d1-1ed8-4ce9-9c1e-ddab6391dcaf",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814321.png?alt=media&token=66916c12-2caa-4c17-96f4-831858815eb5",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814298.png?alt=media&token=7b858c14-4a6f-4215-854d-e765594d6025",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814440.png?alt=media&token=020f03d8-a37a-4ca4-97a4-b543ab2ed2df",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814407.png?alt=media&token=0f3b2877-4025-432e-b0f2-ffbed1b1d53b",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814524.png?alt=media&token=4c998d7a-f890-418e-a5ff-742e2b39b165",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814447.png?alt=media&token=2e393cb2-10f3-4a93-b3e9-93bb2334faac",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814508.png?alt=media&token=25cd78c7-8b8b-4be3-b9db-341d720091af",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814536.png?alt=media&token=c66cc986-08a8-4f0c-b9e3-2fb0962f6534",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814483.png?alt=media&token=b1619b21-c2c0-408a-8820-f0d8fcd5684b",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814434.png?alt=media&token=741fd45e-59ba-4c3a-b705-7ee4c8f18dc3",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814453.png?alt=media&token=94c39b01-7189-47c8-b87a-3d4472b04205",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814452.png?alt=media&token=06ad06bb-b410-4dcb-ac10-392e5c9dc650",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814551.png?alt=media&token=5a048277-bb8f-4d33-ab14-ead109d4cc7d",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814455.png?alt=media&token=310cad90-cc73-4d4c-a595-6ef29fd0b52a",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814460.png?alt=media&token=a68a183b-a6c1-4b58-853d-338d0e9d6c53",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814468.png?alt=media&token=df1b64e5-8709-40d8-975e-47926a105200",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814458.png?alt=media&token=eb7cf284-29b6-45d6-8e44-d00a32947f18",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819385.png?alt=media&token=95765ab0-3e97-490d-9d04-baa2f57ecaf1",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819386.png?alt=media&token=9650d7d3-00c4-4e6a-8080-727a1f1b5aa0",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819354.png?alt=media&token=2135b3b3-d9e0-46d4-bc31-53e7dc94a3ce",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819355.png?alt=media&token=839833ba-a374-4b81-a58c-f2d9ee953cc4",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819393.png?alt=media&token=233ee164-f81b-4648-b0fa-cdcdaac350ef",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819394.png?alt=media&token=bf1fc93e-8e05-477d-ac76-574d3fdabaae",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819328.png?alt=media&token=34556479-e551-4cba-b544-75d0c81e8ac3",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819329.png?alt=media&token=c27696b9-26f1-4f88-8aac-da53e9dffe66",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819389.png?alt=media&token=5b646181-fe9f-43ae-8166-e7539cd248c8",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819350.png?alt=media&token=66cd7d71-1beb-426a-88b9-daeb6ba4c35d",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819016.png?alt=media&token=3ab79020-4567-49f5-b130-c067d5d14cd0",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819124.png?alt=media&token=64264002-b153-4100-bdf9-babfc012793a",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819259.png?alt=media&token=847edc13-1645-4d7e-96a8-e99a5f9f92c8",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819272.png?alt=media&token=eeaeedcf-87bd-42b9-aff1-6ba0b5371edd",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814702.png?alt=media&token=d2ede1d9-7f0b-4ae4-804f-0135b65bc1dd",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814739.png?alt=media&token=3dc10ee5-71e8-45e5-b644-08c6174f02b8",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814886.png?alt=media&token=6d827a34-425b-48c5-ad8a-1b2116b897b7",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814808.png?alt=media&token=0644ea86-b037-4052-84aa-3671269cc312",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814833.png?alt=media&token=7bb08545-94bb-409e-a776-b8aca68427a6",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814875.png?alt=media&token=69405403-476d-401f-a4d0-89c2e59b08a9",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814817.png?alt=media&token=1560f318-bef1-4ede-86fe-5bf53e8e530d",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814816.png?alt=media&token=b050248b-f843-40f9-b2fd-fc934bb422d9",]


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
            "image": a_tag.find('img').get('src').replace("https://west2-univ.jp/menu_img/png_sp", "menu/pics"),
            "image_appUrl" : appUrl_list[data_list.__len__()],
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


