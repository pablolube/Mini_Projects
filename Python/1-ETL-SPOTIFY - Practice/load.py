
import pandas as pd
import os
import subprocess
import spotipy
from spotipy.oauth2 import SpotifyOAuth
from datetime import datetime, timedelta
import pandas as pd 
from sqlalchemy import create_engine
import webbrowser

# Paso 1: Ejecutar Transform.py para generar clean_df.csv
subprocess.run(["python", "Transform.py"], check=True)

# Paso 2: Cargar clean_df.csv en un DataFrame
df = pd.read_csv("data/clean_df.csv")

#Paso 3 Guardar Base de datos

engine = create_engine("sqlite:///spotify_database.db")
df.to_sql("spotify", engine, if_exists="replace", index=False)


