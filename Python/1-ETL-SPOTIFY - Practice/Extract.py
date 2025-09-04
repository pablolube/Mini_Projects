import spotipy
from spotipy.oauth2 import SpotifyOAuth
from datetime import datetime, timedelta
import pandas as pd 
from sqlalchemy import create_engine
import webbrowser



# Definir las credenciales de cliente
client_id = "0bcd2a72dd0a480ebc16b3d8b33c8ce7"
client_secret = "5731049f94d54bcfa89fa02fa42bc391"

# Establecer el flujo OAuth2
scope = "user-library-read user-read-playback-state user-read-recently-played"

# Establecer el URI de redirección para Jupyter (usando localhost)
redirect_uri = 'https://www.google.com/'

# Crear el objeto de autenticación y cliente
sp_oauth = SpotifyOAuth(client_id=client_id,
                         client_secret=client_secret,
                         redirect_uri=redirect_uri,
                         scope=scope)

sp = spotipy.Spotify(auth_manager=sp_oauth)


# Intentar obtener el usuario autenticado
try:
    user = sp.current_user()
    print(f"Usuario autenticado: {user['display_name']}")
except Exception as e:
    print(f"Error de autenticación: {e}")
    exit()

# Función para extraer las canciones escuchadas recientemente
def extract(date, limit=50):
    """ Obtener los elementos escuchados recientemente
            Args: 
                    date(datetime): Fecha a consultar
                    limit (int): Limite de elementos a consultar
    """
    ds = int(date.timestamp()) * 1000
    return sp.current_user_recently_played(limit=limit,after=ds)

# Establecer la fecha para la consulta

date = datetime(2025, 1, 1)  # Ejemplo con hora 10 AM
raw_data = extract(date)

with open("data/raw_data.txt", "w") as file:
    file.write(str(raw_data))  # Convertir el diccionario a string y escribirlo
