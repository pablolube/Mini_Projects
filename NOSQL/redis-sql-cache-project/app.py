import streamlit as st
import time
import sqlite3
import redis
import json
import pandas as pd
import tempfile

# ---------------------------
# Conexión a Redis (opcional)
# ---------------------------
try:
    r = redis.Redis(host='localhost', port=6379, db=0, decode_responses=True)
    r.ping()
    redis_ok = True
except redis.exceptions.ConnectionError:
    redis_ok = False

# Lista global para guardar tiempos históricos
if 'tiempos' not in st.session_state:
    st.session_state.tiempos = []

# ---------------------------
# Función para obtener top clientes con medición de tiempo
# ---------------------------
def get_top_clientes(db_path):
    cache_key = "top_clientes"  # clave fija para pruebas

    start_time = time.time()
    # Revisar Redis primero
    cached_data = r.get(cache_key) if redis_ok else None
    if cached_data:
        elapsed = time.time() - start_time
        data = json.loads(cached_data)
        st.session_state.tiempos.append({'Fuente': 'Redis', 'Tiempo': elapsed})
        return data, "Redis"
    
    # SQLite si no hay caché
    try:
        conn = sqlite3.connect(db_path)
        cursor = conn.cursor()
        query = """
        SELECT c.FirstName || ' ' || c.LastName AS Cliente, SUM(i.Total) AS TotalCompras
        FROM Customer c
        JOIN Invoice i ON c.CustomerId = i.CustomerId
        GROUP BY Cliente
        ORDER BY TotalCompras DESC;
        """
        cursor.execute(query)
        result = cursor.fetchall()
        conn.close()
    except sqlite3.DatabaseError:
        st.error("El archivo subido no es una base de datos SQLite válida.")
        return [], "Error"
    
    elapsed = time.time() - start_time
    st.session_state.tiempos.append({'Fuente': 'SQLite', 'Tiempo': elapsed})

    # Guardar en Redis
    if redis_ok:
        r.setex(cache_key, 3600, json.dumps(result))
    
    return result, "SQLite"

# ---------------------------
# Streamlit UI
# ---------------------------
st.title("🏆 Ranking de Clientes - Chinook DB")
st.write("Visualización de los clientes con mayores compras y tiempos de respuesta.")

# Subir DB
db_file = st.file_uploader("Sube tu base de datos (.db/.sqlite)", type=["db", "sqlite"])
db_path = None

if db_file:
    temp_db = tempfile.NamedTemporaryFile(delete=False, suffix=".db")
    temp_db.write(db_file.getbuffer())
    temp_db.close()
    db_path = temp_db.name
else:
    db_path = "Chinook.db"  # DB local

# Botón para actualizar ranking
if db_path and st.button("Actualizar Ranking"):
    data, source = get_top_clientes(db_path)

    if data:
        if source == "Redis":
            st.success("✅ Los datos fueron obtenidos desde Redis")
        else:
            st.info("📄 Los datos fueron obtenidos desde SQLite")

        # Mostrar tabla y gráfico
        df = pd.DataFrame(data, columns=["Cliente", "TotalCompras"])
        st.table(df)
        st.bar_chart(df.set_index("Cliente")["TotalCompras"])

        # Mostrar análisis de tiempos
        tiempos_df = pd.DataFrame(st.session_state.tiempos)
        st.subheader("📊 Historial de tiempos de respuesta")
        st.table(tiempos_df)

        st.line_chart(tiempos_df.set_index('Fuente')['Tiempo'])
