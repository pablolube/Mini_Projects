import streamlit as st
import pandas as pd
import docx2txt
from PyPDF2 import PdfReader
import openpyxl
import os



def leer_pdf(file):
    pdf=PdfReader(file)
    count=len(pdf.pages)
    todo_el_texto=""

    for i in range(count):
        pagina=pdf.pages[i]
        todo_el_texto+=pagina.extract_text()
    return todo_el_texto


def guardar_archivo(uploadedfile):
    #crear el directorio si no existe
    if not os.path.exists("temp"):
        os.makedirs("temp")
    
    with open(os.path.join("temp",uploadedfile.name),"wb") as f:
        f.write(uploadedfile.getbuffer())   
    return st.success("Archivo guardado:{}en temp".format(uploadedfile.name))




def cargar_texto():
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