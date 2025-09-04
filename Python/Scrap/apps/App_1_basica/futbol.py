import streamlit as st
import pandas as pd

def cargar_partidos():
    df = pd.read_csv('data/result.csv')
    st.dataframe(df)
