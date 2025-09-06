# Gestión de Caché para Consultas SQL con Redis  

## 📌 Descripción  
Este proyecto muestra cómo usar **Redis como capa de caché** para optimizar consultas SQL en una base de datos relacional.  
La idea es evitar repetir queries costosas, almacenando resultados en Redis y devolviéndolos más rápido.  

Ejemplo implementado:  
- **Ranking de clientes con mayores compras** usando la base de datos **Chinook (SQLite)**.  
- **Si la consulta ya está cacheada** → se obtiene desde Redis.  
- **Si no está cacheada** → se consulta en SQLite y se guarda en Redis con un tiempo de expiración.  

---

## 🛠️ Tecnologías utilizadas
- **Python 3.10+**  
- **SQLite** (base de datos relacional)  
- **Redis** (caché en memoria)  
- **Docker** (para levantar Redis fácilmente)  
- **redis-py** (librería cliente de Redis en Python)  

---

## 📂 Estructura del proyecto
```
📦 redis-sql-cache
 ┣ 📜 app.py              # Código principal
 ┣ 📜 requirements.txt    # Dependencias Python
 ┣ 📜 chinook.db          # Base de datos SQLite (ejemplo)
 ┣ 📜 docker-compose.yml  # Configuración para Redis
 ┣ 📜 README.md           # Documentación
```

---

## ⚙️ Instalación y ejecución

### 1. Clonar repositorio
```bash
git clone https://github.com/tu_usuario/redis-sql-cache.git
cd redis-sql-cache
```

### 2. Instalar dependencias
```bash
pip install -r requirements.txt
```

### 3. Levantar Redis con Docker
```bash
docker-compose up -d
```
Esto levanta un contenedor con Redis en `localhost:6379`.

### 4. Ejecutar el script
```bash
python app.py
```

---

## 📊 Ejemplo de consulta

Primera ejecución (va a **SQLite**):  
```
🗄️ Datos desde SQLite
[('Luis', 400), ('Ana', 300), ('Juan', 250)]
```

Segunda ejecución (ya está en **Redis**):  
```
📦 Datos desde Redis
[('Luis', 400), ('Ana', 300), ('Juan', 250)]
```

---

## 🧪 Medición de rendimiento
Podés comparar el tiempo de respuesta con y sin caché:  

```python
import time
start = time.time()
print(get_top_clientes())
print("Tiempo:", time.time() - start)
```

---

## 📥 Base de datos usada
Se usa la **Chinook DB**, una base de ejemplo con:  
- Clientes  
- Facturas  
- Artistas y canciones  

📥 Descargar: [Chinook Database (SQLite)](https://github.com/lerocha/chinook-database)  

Una vez descargado, renombrar el archivo como `chinook.db` y colocarlo en la raíz del proyecto.  

---

## 🚀 Posibles mejoras
- Crear un **dashboard con Streamlit** para visualizar métricas y rankings.  
- Probar con otras bases (Northwind, Kaggle datasets).  
- Implementar un **sistema de métricas de hit/miss** en Redis.  
- Extender el proyecto a PostgreSQL o MySQL.  

---

✍️ Autor: **[Tu Nombre]**  
📌 Proyecto para práctica de **Data Engineering & Analytics con Redis**
