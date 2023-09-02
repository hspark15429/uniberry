import re
import requests
import os

import time
import json
from bs4 import BeautifulSoup

appUrl_list = [r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814350.png?alt=media&token=acd3f5e3-91b0-477d-a162-1df350bf50fb",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814354.png?alt=media&token=261a2a08-34ab-4a23-8669-1b22ee6221aa",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814274.png?alt=media&token=e8559703-8c2f-468c-9cb0-be58657a1de0",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814067.png?alt=media&token=5b5a28d4-e605-42fe-b395-5d0af8386b04",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814298.png?alt=media&token=152439ef-b97f-45c6-9052-bc0dabee84a3",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814490.png?alt=media&token=42358c9f-dfbd-4645-8072-91af2f3bb700",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814407.png?alt=media&token=816aa967-05ad-4c9f-8c2c-53558427f28e",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814530.png?alt=media&token=b3d75ac1-43ce-45f8-91b5-37b8bb9be008",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814447.png?alt=media&token=dea4de5c-3c73-4b35-be28-44574821faca",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814556.png?alt=media&token=33622a4d-9915-41f3-8c0e-00bd1f09c38f",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814451.png?alt=media&token=7164d6d1-9980-4350-90ec-ab0752c87a71",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814453.png?alt=media&token=bbdd1f84-16f5-4f1d-86b8-8284604115d9",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814455.png?alt=media&token=11f86a06-a388-4083-8865-8063a31f054e",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814456.png?alt=media&token=eb50e040-00a5-44b6-8ad5-53a9378759d4",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814468.png?alt=media&token=8888252a-f2c2-4c3a-a9b8-b8e38f52154f",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814458.png?alt=media&token=20734a87-fba1-400a-9fab-1867731ee0ed",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814457.png?alt=media&token=f23ead8c-bba4-4932-b9f9-ce1e78b5f757",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819380.png?alt=media&token=d961a0f5-326d-4ecf-99a9-8a0193245c42",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819355.png?alt=media&token=73bd4be2-b375-4d7c-86fe-2d83797bc909",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819354.png?alt=media&token=74d1b6b6-2367-488c-8cf2-9f4543d09f30",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819381.png?alt=media&token=9a5b062a-d008-4cad-8c74-9e396adab951",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819429.png?alt=media&token=9f878037-39dd-4821-bc87-e1a1547ed63e",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819079.png?alt=media&token=25150e98-c8a8-41c4-aca0-4c83af609c88",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819043.png?alt=media&token=22479c78-133b-4ad7-bb12-17c7f89c4c30",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819253.png?alt=media&token=8e003959-343d-4d83-9aa1-d7f81eda3331",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F819272.png?alt=media&token=4be17995-b718-4c2c-b9c7-bd11cd4d2f68",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814702.png?alt=media&token=6f033b63-d1ee-416f-8433-b77d68fa23f8",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814808.png?alt=media&token=4a33799d-89fb-4ddd-aafc-5cc0e94d28c9",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814813.png?alt=media&token=c7b38028-e3c5-4d04-a945-5eb98dbb91a4",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F650313_456453.png?alt=media&token=0b39541a-695e-4549-846a-53dbed414cfc",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814817.png?alt=media&token=f78fcd6c-94c9-4578-88cc-4c6b962a12e9",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814816.png?alt=media&token=72b7ec3f-3668-4edd-b8e8-f8d6ee9ce6c4",
r"https://firebasestorage.googleapis.com/v0/b/fir-flutter-codelab-39c7d.appspot.com/o/menu%2Fpics%2F814818.png?alt=media&token=e738c7ef-d336-43a6-aef8-f5556588fedc"
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


    # nutrition = {
    #     "energy": float(re.findall(r'\d+\.?\d*', detail_list[1].find(class_='price').text)[0]),
    #     "protein": float(re.findall(r'\d+\.?\d*', detail_list[2].find(class_='price').text)[0]),
    #     "fat": float(re.findall(r'\d+\.?\d*', detail_list[3].find(class_='price').text)[0]),
    #     "carbohydrates": float(re.findall(r'\d+\.?\d*', detail_list[4].find(class_='price').text)[0]),
    #     "salt": float(re.findall(r'\d+\.?\d*', detail_list[5].find(class_='price').text)[0]),
    #     "calcium": float(re.findall(r'\d+\.?\d*', detail_list[6].find(class_='price').text)[0]),
    #     "veg": float(re.findall(r'\d+\.?\d*', detail_list[7].find(class_='price').text)[0]),
    #     "iron": float(re.findall(r'\d+\.?\d*', detail_list[8].find(class_='price').text)[0]),
    #     "vitA": float(re.findall(r'\d+\.?\d*', detail_list[9].find(class_='price').text)[0]),
    #     "vitB1": float(re.findall(r'\d+\.?\d*', detail_list[10].find(class_='price').text)[0]),
    #     "vitB2": float(re.findall(r'\d+\.?\d*', detail_list[11].find(class_='price').text)[0]),
    #     "vitC": float(re.findall(r'\d+\.?\d*', detail_list[12].find(class_='price').text)[0]),
    # }

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


