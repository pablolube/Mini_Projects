import streamlit as st
import requests
from bs4 import BeautifulSoup
import os
import re
import pandas as pd
from datetime import datetime


####################################################################
#                         FUNCIONES                                 #
####################################################################



def get_search_result(query):
    headers = {
        'User-Agent': (
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/115.0.0.0 Safari/537.36'
        ),
        'Accept-Language': 'es-ES,es;q=0.9'
    }

    url = f"https://www.amazon.com/s?k={query}"
    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, 'lxml')
    st.write(soup)
    product_links = []
    
    for link in soup.select('a.a-link-normal.s-line-clamp-2[href]'):
        st.write(link)
        href = link['href']
        if '/dp/' in href:  # asegura que sea producto
            product_links.append("https://www.amazon.com" + href)

    return product_links



def get_product_info(url):
    headers = {
        'User-Agent': (
            'Mozilla/5.0 (Windows NT 10.0; Win64; x64) '
            'AppleWebKit/537.36 (KHTML, like Gecko) '
            'Chrome/115.0.0.0 Safari/537.36'
        ),
        'Accept-Language': 'es-ES,es;q=0.9'
    }

    response = requests.get(url, headers=headers)
    soup = BeautifulSoup(response.text, "lxml")

    # Extraer título
    title = "No title found"
    title_tag = soup.find(id="productTitle")
    if title_tag:
        full_title = title_tag.get_text(strip=True)
        title = full_title.split(",")[0]

    # Extraer URL de imagen
    image_url = "No image url found"
    image_tag = soup.find("img", id="landingImage") or soup.find("img", class_="a-dynamic-image")
    if image_tag and image_tag.get("src"):
        image_url = image_tag["src"]

    # Extraer precio
    price = "No price found"
    price_tag = soup.find("span", class_="a-offscreen") or soup.find("span", class_="a-price-whole")
    if price_tag:
        price = price_tag.get_text(strip=True)

    return title, image_url, price



def save_image(imagen, product_name):
    folder = "imagenes"
    os.makedirs(folder, exist_ok=True)

    valid_filename = re.sub(r'[<>:"/\\|?*]', '', product_name)[:10]
    filepath = os.path.join(folder, valid_filename + '.jpg')

    base, ext = os.path.splitext(filepath)
    counter = 1
    while os.path.exists(filepath):
        filepath = f"{base}_{counter}{ext}"
        counter += 1

    response = requests.get(imagen, stream=True)
    if response.status_code == 200:
        with open(filepath, 'wb') as file:
            for chunk in response.iter_content(1024):
                file.write(chunk)
        return filepath
    return None


def save_excel(data):
    df = pd.DataFrame(data)  # CORREGIDO: DataFrame con F mayúscula
    file_name = 'busquedas.xlsx'
    if os.path.exists(file_name):
        existing_df = pd.read_excel(file_name)
        df = pd.concat([existing_df, df], ignore_index=True)
    df.to_excel(file_name, index=False)
    return file_name


####################################################################
#                       STREAMLIT APP
####################################################################
st.title("Amazon Web Scraper")

search_query = st.text_input('Search in Amazon')

if search_query:
    st.write(f"Results for {search_query}")

    # Llamada a la función de búsqueda
    product_urls = get_search_result(search_query)

    all_data = []

    for url in product_urls:
        
        title, image_url, price = get_product_info(url)
        st.write("Debug: title =", title, "| image_url =", image_url, "| price =", price)  # depuración

        if title != 'No title found':
            data = {
                'Fecha': datetime.now().strftime('%Y-%m-%d'),
                'Titulo': title,
                'Precio': price,
                'Url Imagen': image_url,
                'Url Producto': url
            }
            all_data.append(data)


        if image_url != "No image url found":
            saved_path = save_image(image_url, title)

    if all_data:
        df = pd.DataFrame(all_data)
        st.write("### Products Information")
        st.dataframe(df)

        file_name = save_excel(df)
        st.success(f'Data has been successfully saved to the file: {file_name}')
    else:
        st.error('No products were found to save. Please check the input data.')

else:
    st.error('Please enter a search query to start scraping.')
