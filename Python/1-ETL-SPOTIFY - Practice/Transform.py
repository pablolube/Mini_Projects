import spotipy
from spotipy.oauth2 import SpotifyOAuth
from datetime import datetime, timedelta
import pandas as pd 
from sqlalchemy import create_engine
import webbrowser
import subprocess
import ast

# Paso 1: Ejecutar Extract.py para generar raw_data.txt
subprocess.run(["python", "Extract.py"])

# Paso 2: Leer el archivo raw_data.txt
def load_raw_data(file_path):
    with open(file_path, "r") as file:
        raw_data_str = file.read()
    return ast.literal_eval(raw_data_str)

# Leer el archivo generado por Extract.py
raw_data = load_raw_data("data/raw_data.txt")

# Mostrar el contenido de raw_data
print(raw_data)

print(raw_data['items'][0].keys())

#DATA processed
data=[]
for r in raw_data['items']:
    data.append(
        {
            "played_at":r["played_at"],
            "artist":r["track"]["artists"][0]["name"],
            "track":r["track"]["name"],
           "album": r["track"]["album"]["name"],
           "'album_type'": r["track"]["album"]['album_type'] 


            }
    )

df=pd.DataFrame(data)
print(df)
if not df["played_at"].is_unique:
    raise Exception("Un valor unico repetido")

df["played_at"] = pd.to_datetime(df["played_at"], format='ISO8601').dt.date

if df.isnull().values.any():
    raise Exception("Un valor nulo")

clean_df=df.copy()

clean_df.to_csv("data/clean_df.csv", index=False)
