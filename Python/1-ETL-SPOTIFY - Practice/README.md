# 🎵 ETL de Spotify

Este proyecto es una práctica de **ETL (Extract, Transform, Load)** utilizando la API de **Spotify** con `spotipy`. Se extraen datos de canciones reproducidas recientemente, se procesan y se almacenan en una base de datos.

---

## 📌 Descripción del Proyecto

El objetivo de este proyecto es aplicar un proceso de **ETL (Extracción, Transformación y Carga)** para analizar el historial de reproducción de un usuario de **Spotify**.

🔹 **Extract**: Se extraen las canciones reproducidas recientemente con la API de Spotify.  
🔹 **Transform**: Se limpian y estructuran los datos en un `DataFrame` de pandas.  
🔹 **Load**: Se almacenan los datos en una base de datos **SQLite / PostgreSQL** usando `SQLAlchemy`.  

---

## 🚀 Instalación y Configuración

1. **Clonar el repositorio**:
   ```bash
   git clone https://github.com/tu_usuario/spotify-etl.git
   cd spotify-etl
   ```

2. **Crear un entorno virtual y activarlo**:
   ```bash
   python -m venv .venv
   source .venv/bin/activate  # En macOS/Linux
   .venv\Scripts\activate  # En Windows
   ```

3. **Instalar dependencias**:
   ```bash
   pip install -r requirements.txt
   ```

4. **Configurar credenciales de Spotify**:
   - Registra tu aplicación en [Spotify Developer Dashboard](https://developer.spotify.com/dashboard/applications) y obtén tu `client_id` y `client_secret`.
   - Crea un archivo `.env` y agrega:
     ```env
     SPOTIPY_CLIENT_ID="tu_client_id"
     SPOTIPY_CLIENT_SECRET="tu_client_secret"
     SPOTIPY_REDIRECT_URI="http://localhost:8888/callback"
     ```

---

## 📡 Uso

1. **Ejecutar el script principal**:
   ```bash
   python etl.py
   ```

2. **Salida esperada (Ejemplo en Pandas)**:
   ```plaintext
          played_at               artist          track
   0  2024-02-11T10:30:00Z  Coldplay        Yellow
   1  2024-02-11T10:25:00Z  The Beatles     Hey Jude
   ```

---

## 🛠️ Tecnologías Utilizadas

- **Python 3.x**
- **Spotipy** (para interactuar con la API de Spotify)
- **Pandas** (para transformar los datos)
- **SQLAlchemy** (para cargar los datos en la base de datos)
- **SQLite/PostgreSQL** (almacenamiento de datos)

---

## 📌 Funcionalidades

✅ Extrae canciones reproducidas recientemente de Spotify.  
✅ Transforma los datos en un formato estructurado.  
✅ Guarda la información en una base de datos relacional.  
✅ Permite análisis de tendencias musicales del usuario.  

---

## 📄 Licencia

Este proyecto está bajo la licencia MIT. Puedes ver más detalles en el archivo `LICENSE`.
