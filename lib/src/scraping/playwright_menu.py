import asyncio
from playwright.async_api import async_playwright

from menu import html_to_json

async def run(playwright, cafeteria_name, url):
    browser = await playwright.chromium.launch()
    context = await browser.new_context()
    page = await context.new_page()
    await page.goto(url)
    await page.get_by_text("副菜 Side dish").click()
    await page.get_by_text("麺類 Noodles").click()
    await page.get_by_text("丼・カレー Rice bowl / Curry").click()
    await page.get_by_text("デザート Dessert").click()

    await page.wait_for_timeout(15000)
    html = await page.inner_html("body")

    with open("assets/rawHtmls/menuraw"+ cafeteria_name +".html", 'w', encoding='utf-8') as file:
        file.write(html)

    print("HTML saved to assets/rawHtmls/menuraw"+ cafeteria_name +".html")

    # ---------------------
    await context.close()
    await browser.close()


async def main():
    # url_dictionary = {
    #     "BKC1": "https://west2-univ.jp/sp/menu.php?t=650311",
    #     "BKC2": "https://west2-univ.jp/sp/menu.php?t=650313",
    #     # "BKC3": "https://west2-univ.jp/sp/menu.php?t=650315",
    #     "KIC1": "https://west2-univ.jp/sp/menu.php?t=650321",
    #     "KIC2": "https://west2-univ.jp/sp/menu.php?t=650325",
    #     "KIC3": "https://west2-univ.jp/sp/menu.php?t=650328",
    #     "OIC": "https://west2-univ.jp/sp/menu.php?t=650337"
    # }

    # for key, value in url_dictionary.items():
    #     async with async_playwright() as playwright:
    #         await run(playwright, key, value)

    html_to_json()

asyncio.run(main())
