import streamlit as st
from futbol import cargar_partidos
from texto import cargar_texto
def main():

    st.title('APP PRINCIPAL')
    elementos=["Deportes","Texto","Conocenos"]
    choice = st.sidebar.selectbox("Menú", elementos)

    if choice=="Deportes":
        st.subheader('Deportes')
        cargar_partidos()

    elif choice=="Texto":
        st.subheader('Texto')
        cargar_texto()
    
    elif choice=="Conocenos":
        st.subheader('Conocenos')
main()