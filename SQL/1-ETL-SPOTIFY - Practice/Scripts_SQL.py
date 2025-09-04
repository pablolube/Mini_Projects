import pandas as pd
from sqlalchemy import create_engine

# Conexión a la base de datos
engine = create_engine('sqlite:////workspaces/ETL-Projects/1-ETL-SPOTIFY - Practice/mi_base_de_datos.db', echo=True)

# Consulta SQL
query = "SELECT * FROM spotify_db LIMIT 50;"

# Ejecutar la consulta y cargar los resultados en un DataFrame
df_query = pd.read_sql(query, con=engine)

# Mostrar los primeros 10 resultados
print(df_query)
