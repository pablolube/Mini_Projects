import pandas as pd
from sqlalchemy import create_engine, Column, Integer, String, MetaData
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.orm import sessionmaker
from sqlalchemy import create_engine, Column, Integer, String, DateTime, MetaData

# Definir la clase base
Base = declarative_base()

# Crear la clase que define la estructura de la tabla
class create_db(Base):
    __tablename__ = 'spotify_db'  # Nombre de la tabla en la base de datos
    
    # Definición de las columnas

    id = Column(Integer, primary_key=True, autoincrement=True)
    played_at = Column(DateTime, nullable=False)
    artist = Column(String, nullable=False)
    track = Column(String, nullable=False)
    album = Column(String, nullable=False)
    album_type = Column(String, nullable=False)

# Crear una conexión a la base de datos (la base de datos se creará si no existe)
engine = create_engine('sqlite:///mi_base_de_datos.db', echo=True)

# Crear las tablas en la base de datos
Base.metadata.create_all(engine)

