import streamlit as st
from openai import OpenAI
from openAI_functions import generar_articulo,generar_doc,generar_codigo,generar_tabla,generar_excel
def main():


############################################################################################################
 #                                           CONFIGURACION INICIAL                                         #
############################################################################################################

    st.set_page_config(page_title="Generador de Contenidos con OpenAI",layout="wide")


    #configuracion de OpenAI (reemplaza con tu API key)
    api_key_user=st.text_input('Ingresa tu Open AI api_key',type="password")
    client=OpenAI(api_key=api_key_user)

    #Titulo
    st.title('Generador de Contenidos con OpenAI')

    # Barra lateral para seleccionar secciones
    elementos=["Generación de Articulos","Generación de Códigos","Generacion de Tablas de datos"]
    choice = st.sidebar.selectbox("Selecciona la seccion", elementos)

############################################################################################################
 #                                           GENERACION DE ARTICULOS                                       #
############################################################################################################

    if choice=="Generación de Articulos":
        st.subheader('Generación de Articulos')
        
        #INPUT DEL TEXTO
        topic=st.text_input('Ingresa un tema para el artículo: ')
       
        if st.button("Generar artículo"):
            #Agrego spinner mientras se llama a la funcion
            with st.spinner('Generando artículo...'):

                #llamo a la funcion le mando el topic
                article=generar_articulo(client,topic)

                #Si no falla entonces muesta mensaje de success y previsualizacion
            
                if article:

                    #mensaje de success
                    st.success('Articulo generado exitosamente')
                    st.markdown('### Vista previa del artículo:')
                    
                    #Previsualizacion 
                    st.markdown(article)

                    st.download_button('Descargar como Word',data=generar_doc(article),file_name=(f"Artículo: {topic}"),mime='application/vnd.openxmlformats-officedocument.wordprocessingml.document')


############################################################################################################
 #                                           GENERACION DE CODIGOS                                         #
############################################################################################################
    elif choice=="Generación de Códigos":
        st.subheader('Generación de Códigos')
        #INPUT DEL codigo
        prompt=st.text_input('Ingresa lo que desea programar: ')
       
        if st.button("Generar código"):
            #Agrego spinner mientras se llama a la funcion
            with st.spinner('Generando código python...'):

                #llamo a la funcion le mando el topic
                code=generar_codigo(client,prompt)

                #Si no falla entonces muesta mensaje de success y previsualizacion
            
                if code:

                    #mensaje de success
                    st.success('El codigo generado exitosamente')
                    st.markdown('### Vista previa del codigo:')
                    
                    #Previsualizacion 
                    st.code(code,language="python")
                    st.download_button('Descargar archivo python',data=code,file_name=code.py,mime='text/plain')

############################################################################################################
#                                           GENERACION DE TABLAS                                          #
############################################################################################################
    
    elif choice=="Generacion de Tablas de datos":
      
    #INPUT DEL tabla
        tabla_solicitada=st.text_input('Ingresa la tabla que desea generar: ')
       
        if st.button("Generar tabla"):
            #Agrego spinner mientras se llama a la funcion
            with st.spinner('Generando tabla...'):

                #llamo a la funcion le mando el topic
                data=generar_tabla(client,tabla_solicitada)

                #Si no falla entonces muesta mensaje de success y previsualizacion
            
                if data:

                    #mensaje de success
                    st.success('La tabla ha sido generada exitosamente')
                    
                    
                    excel_file,df=generar_excel(data)
                    

                    if excel_file and df is not None:                   
                        #Previsualizacion 
                        st.markdown('### Vista previa de la tabla:')
                        st.dataframe(df,use_container_width=True)

                        #Boton de descarga
                        st.download_button('Descargar archivo',data=excel_file,file_name="table.xlsx",mime='application/vnd.openxmlformats-officedocument.spreadsheetml.sheet')

main()