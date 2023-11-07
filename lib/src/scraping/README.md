courses.json: processed courses data
coursesExtractTr.py: converts scraped raw html into courses.json
coursesFetch.sh: bash file to scrape https://ct.ritsumei.ac.jp/syllabussearch/ all pages and saves to coursesRaw.html
coursesRaw.html: scraped data

menu.py: 
	current process:
	1. copy entire expanded page to menuraw.html --> can't, manual
	2. run menu.py(it download, upload, and delete files in Firebase Storage with pictures and menu.json)

Conclusion(all you need to do is below):
    cd /Users/hanpark/development/uniberry/lib/src/scraping
    export GOOGLE_APPLICATION_CREDENTIALS="/Users/hanpark/development/keys/fir-flutter-codelab-39c7d-firebase-adminsdk-a25ao-1df95655ac.json"
    (check playwright_menu and menu.py's cafeteria names that are effective)
    python playwright_menu.py 