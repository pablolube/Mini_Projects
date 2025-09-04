import streamlit as st
from PIL import Image
import pandas as pd
import docx2txt
from PyPDF2 import PdfReader
import openpyxl
import os

@st.cache_data
def cargar_imagen(image_file):
    img=Image.open(image_file)
    return img

def leer_pdf(file):
    pdf=PdfReader(file)
    count=len(pdf.pages)
    todo_el_texto=""

    for i in range(count):
        pagina=pdf.pages[i]
        todo_el_texto+=pagina.extract_text()
    return todo_el_texto

    #Guargar el archivo

def guardar_archivo(uploadedfile):
    #crear el directorio si no existe
    if not os.path.exists("temp"):
        os.makedirs("temp")
    
    with open(os.path.join("temp",uploadedfile.name),"wb") as f:
        f.write(uploadedfile.getbuffer())   
    return st.success("Archivo guardado:{}en temp".format(uploadedfile.name))


def main():
    st.title("Carga de Archivos")
    menu=["Imagenes","Conjuntos de Datos","Archivos de documentos"]
    seleccion=st.sidebar.selectbox("Menú",menu)

    if seleccion=="Imagenes":

        #Subencabezado
        st.subheader("Imagenes")

        #Carga de la imagen
        archivos_imagen=st.file_uploader("Subir Imágenes",type=["png","jpg","jpeg"])

        if archivos_imagen:
            #Detalles de la imagen
            detalles_archivos={"nombre_archivo":archivos_imagen.name,"tipo_archivo":archivos_imagen.type,"tamaño_archivo":archivos_imagen.size}
            st.write(detalles_archivos)
            
            #Llamo funcion 
            img=cargar_imagen(archivos_imagen)

            #Muestro imagen
            st.image(img, use_column_width=True)

            guardar_archivo(archivos_imagen)

    elif seleccion=="Conjuntos de Datos":
        st.subheader("Conjuntos de Datos")
        archivos_datos=st.file_uploader("Subir Imágenes",type=["xlsx","csv"])
        if archivos_datos is not None:
            #Detalles de la imagen
            detalles_archivos_datos={"nombre_archivo":archivos_datos.name,"tipo_archivo":archivos_datos.type,"tamaño_archivo":archivos_datos.size}
            st.write(detalles_archivos_datos)
       
            # En funcion del tipo de archivo es como lo leo
            if detalles_archivos_datos["tipo_archivo"]=='text/csv':
                df=pd.read_csv(archivos_datos)
        
            if detalles_archivos_datos["tipo_archivo"]=='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet':
                df=pd.read_excel(archivos_datos)
                
                
            # Muestro dataframe
            st.dataframe(df)
            guardar_archivo(archivos_datos)
                

    
    elif seleccion=="Archivos de documentos":
        st.subheader("Archivos de documentos")
        archivos_doc=st.file_uploader("Subir Documento",type=["pdf","docx","txt"])
        if st.button("Procesar"):
            if archivos_doc is not None:
                #Detalles de la archivo
                detalles_archivos_doc={"nombre_archivo":archivos_doc.name,"tipo_archivo":archivos_doc.type,"tamaño_archivo":archivos_doc.size}
                st.write(detalles_archivos_doc)
        
               # En funcion del tipo de archivo es como lo leo
            if detalles_archivos_doc["tipo_archivo"]=="application/vnd.openxmlformats-officedocument.wordprocessingml.document":
                texto=docx2txt.process(archivos_doc)
            
            if detalles_archivos_doc["tipo_archivo"]=='application/pdf':
                texto=leer_pdf(archivos_doc)
            
            st.write(texto)
            guardar_archivo(archivos_doc)
    
main()