import streamlit as st
import pandas as pd
from PIL import Image
import plotly.express as px
import docx2txt
from PyPDF2 import PdfReader
import openpyxl
import os


def main():
    img = Image.open("data/git.png")
    st.set_page_config(page_title="Mi_App",page_icon=img,layout="wide",initial_sidebar_state="collapsed")
    st.sidebar.header("Navegacion")
    ############################################################################################################
    #                                                   TEXTOS                                                 #
    ############################################################################################################

    # Subencabezado (H1)
    st.title('Curso de Streamlit')

    # Subencabezado (H2)
    st.header('Esto es un encabezado')

    # Subencabezado (H3)
    st.subheader('Esto es un subencabezado')

    # Markdown
    st.markdown("### Esto es un markdown")

    # Mensajes
    st.success("Esto es un éxito")
    st.warning("Esto es un warning")
    st.info("Esto es un info")
    st.error("Esto es un error")

    # TEXTO
    st.header('EJEMPLOS CON WRITE')
    st.text("Hola, esto es un texto")

    # Texto con variable
    nombre='Ivan'
    st.text(f"Hola, esto es un texto {nombre}")

    # Pasar cosas con write 
    st.header('EJEMPLOS CON WRITE')
    st.write("Hola **mundo** :smile:")  
    st.write("# Título grande")
    st.write("Texto en **negrita** y *cursiva*")
    st.write("Un [link a Streamlit](https://streamlit.io)")
    
    # LISTAS O DIC
    frutas = ["🍎 Manzana", "🍌 Banana", "🍇 Uva"]
    info = {"nombre": "Pablo", "edad": 34}
    st.write(frutas)
    st.write(info)

    # OPERACIONES
    x = 10
    y = 5
    st.write("La suma de", x, "y", y, "es", x + y)

    ############################################################################################################
    #                                                   FILTROS                                                #
    ############################################################################################################
    st.header('TIPOS DE FILTROS')
    frutas = ["🍎 Manzana", "🍌 Banana", "🍇 Uva"]
    
    # Selectbox
    st.subheader('Selectbox')
    opcion = st.selectbox('Elige tu fruta favorita', frutas)
    st.write(f'Tu fruta favorita es {opcion}')

    # Multiselect
    st.subheader('Multiselect')
    opcion2 = st.multiselect('Elige tu fruta favorita', frutas)
    st.write(f'Tu fruta favorita es {opcion2}')

    # Slider con números
    st.subheader('Slider - Numeros')
    edad = st.slider('Edad',
                     value=20,
                     min_value=0,
                     max_value=100,
                     step=5)
    st.write(f'Tu edad es {edad}')

    # Slider con categorías
    st.subheader('Slider - Categorias')
    categoria = st.select_slider('Elige tu fruta favorita', frutas)
    st.write(f'Tu fruta favorita es {categoria}')

    ############################################################################################################
    #                                                   IMAGENES - AUDIO - VIDEO                                #
    ############################################################################################################

    # Encabezado
    st.header('TIPOS DE IMÁGENES')

    # Imagen local
    
    st.subheader("Imagen local")
    st.image(img, use_column_width=True)

    # Imagen desde URL
    st.subheader("Imagen desde URL")
    st.image('https://picsum.photos/800', caption="Imagen de picsum.photos")

    # --------------------------------------------------------
    # VIDEOS
    # --------------------------------------------------------
    st.header('VIDEOS')

    # Video local (comentado para que no dé error si no existe el archivo)
    # st.subheader("Video local con inicio en 2s")
    # st.video("video.mp4", start_time=2)

    # Video desde URL
    st.subheader("Video desde URL")
    st.video("https://www.w3schools.com/html/mov_bbb.mp4")

    st.header('AUDIO')


    # Audio desde URL
    st.audio("https://www.soundhelix.com/examples/mp3/SoundHelix-Song-1.mp3")



    ############################################################################################################
    #                                                   INGRESO DE DATOS                                             #
    ############################################################################################################
    
    # TEXT INPUT
    """
    label (str): texto que se muestra sobre el input.
    value (str): valor inicial (por defecto vacío).
    max_chars (int): límite de caracteres permitidos.
    key (str): identificador único para el widget (útil en apps complejas).
    help (str): texto de ayuda mostrado al pasar el mouse.
    type (str): 'default' o 'password' para ocultar texto.
    autocomplete (str): valor para el atributo HTML autocomplete.
    disabled (bool): si es True, el campo queda inactivo.
    """
    nombre = st.text_input("Ingresa tu nombre")
    st.write(nombre)

    # TEXT AREA
    """
    label (str): texto visible.
    value (str): texto inicial.
    height (int): altura del área de texto en píxeles.
    max_chars (int): máximo de caracteres.
    key (str): identificador único.
    help (str): texto de ayuda.
    placeholder (str): texto gris cuando el área está vacía.
    disabled (bool): deshabilita el campo.
    """
    mensaje = st.text_area("Ingresa tu mensaje ", height=100)
    st.write(mensaje)

    # NUMBER INPUT
    """
    label (str): texto descriptivo.
    min_value (int/float): valor mínimo aceptado.
    max_value (int/float): valor máximo aceptado.
    value (int/float): valor inicial.
    step (int/float): incremento/decremento por cada click.
    format (str): formato para mostrar el número.
    key (str): id único.
    help (str): ayuda al usuario.
    disabled (bool): inhabilita el campo.
    """
    numero = st.number_input("Ingresa un numero", 1, 25, step=1)
    st.write(numero)

    # DATE INPUT
    """
    label (str): texto mostrado.
    value (datetime.date o lista): valor inicial (por defecto fecha actual).
    min_value (datetime.date): fecha mínima seleccionable.
    max_value (datetime.date): fecha máxima seleccionable.
    key (str): id único.
    help (str): texto de ayuda.
    disabled (bool): deshabilita el selector.
    """
    fecha = st.date_input("Ingresa una fecha")
    st.write(fecha)

    # TIME INPUT
    """
    label (str): etiqueta.
    value (datetime.time): valor inicial (por defecto hora actual).
    key (str): id.
    help (str): ayuda.
    disabled (bool): deshabilita el selector.
    """
    hora = st.time_input("Ingresa una hora")
    st.write(hora)

    # COLOR PICKER
    """
    label (str): texto visible.
    value (str): valor inicial como código hexadecimal (ejemplo: '#0000FF').
    key (str): id único.
    help (str): ayuda.
    disabled (bool): inhabilita el selector.
    """
    color = st.color_picker("Ingresa un color")
    st.write(color)

  ############################################################################################################
    #                                                   DATAFRAMES                                             #
    ############################################################################################################

    st.header('EJEMPLOS CON DATAFRAMES')

    df = pd.read_csv('data/result.csv')
    st.dataframe(df)
    
    # Table muestra la tabla sin desplazar
    # st.table(df)

    # Permite editar 
    st.data_editor(df)

    # Resalta máximos
    df2 = df.sample(n=10, random_state=42)
    st.dataframe(df2.style.highlight_max(axis=0))
    
    # Botón de descargas
    st.download_button(
        label="Descargar CSV",
        data=df.to_csv(index=False),
        file_name="datos.csv",
        mime="text/csv"
    )

    # Imprimir JSON
    st.header('EJEMPLOS CON JSON')
    st.json({"Clave": "Valor"})

    # Imprimir código
    st.header('EJEMPLOS CON CODIGO')
    codigo = """ 
    def saludar():
    print("Hola")
    """
    
    st.code(codigo, language="python")

############################################################################################################
 #                                                   GRAFICOS                                             #
############################################################################################################

    st.title("Bienvenidos a mi codigo")
   # df['Nationality'].value_counts()    fig=px.pie(df_count,values="")

    


main()

