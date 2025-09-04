
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

print(df.columns)



# Conexión a la base de datos
engine = create_engine('sqlite:////workspaces/ETL-Projects/1-ETL-SPOTIFY - Practice/mi_base_de_datos.db', echo=True)

# Asumiendo que tu DataFrame se llama df y tiene las columnas 'played_at', 'artist', 'track', 'album', 'album_type'

# Limpieza de nombres de columnas (si es necesario)
df.columns = df.columns.str.replace("'", "", regex=False)

# Guardar el DataFrame en la base de datos
df.to_sql('spotify_db', con=engine, if_exists='append', index=False)
