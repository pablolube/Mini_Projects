import streamlit as st

def main(): 
    st.title("Tutorial de Formularios")

# ------------------------------
# Menú Lateral
# ------------------------------
# Lista de opciones para el menú de navegación
    menu = ["Inicio", "Formularios Básicos", "Enfoques de Formularios", "Calculadora de Salario"]

    # Selectbox en la barra lateral para seleccionar la sección
    seleccion = st.sidebar.selectbox("Seleccione un Tema", menu)

    # ------------------------------
    # Sección: Inicio
    # ------------------------------
    if seleccion == "Inicio":
        st.header("Bienvenido al Tutorial de Formularios en Streamlit")
        st.markdown('''
        **Este tutorial te enseñará a trabajar con formularios en Streamlit y diversas funcionalidades:**
        - Creación básica de formularios.
        - Diferentes enfoques para crear formularios.
        - Formularios con columnas (ejemplo: calculadora de salario).
        - Funcionalidad de reinicio de formularios.
        ''')

    # ------------------------------
    # Sección: Formularios Básicos
    # ------------------------------
    elif seleccion == "Formularios Básicos":
        st.subheader("Sección: Formularios Básicos")

        # Ejemplo simple de formulario
        with st.form(key="Formulario_basico"):
            nombre = st.text_input("Nombre")
            apellido = st.text_input("Apellido")
            boton_enviar = st.form_submit_button(label="Registrarse")

            if boton_enviar:
                st.success(f"¡Hola {nombre} {apellido}! Has creado una cuenta.")

        # ------------------------------
        # Sección: Enfoques de Formularios
        # ------------------------------
    elif seleccion == "Enfoques de Formularios":
        st.subheader("Sección: Enfoques de contexto")

    # --- Enfoque 1: Usando administrador de contexto (with st.form) ---
        with st.form(key="Formulario1"):
            st.write("Formulario 1 - Usando administrador de contexto")
            nombre_usuario = st.text_input("Nombre de usuario")
            login_boton = st.form_submit_button(label="Iniciar Sesión")

            if login_boton:
                st.success(f"Bienvenido {nombre_usuario}")

    # --- Enfoque 2: Declarando el formulario como variable ---
        formulario2 = st.form(key="formulario2")
        formulario2.subheader("Formulario 2 - Usando contexto declarado")
        formulario2.write("Formulario creado de forma explícita usando una variable")
        puesto = formulario2.selectbox("Nombre del puesto", ["Administrador", "Desarrollador", "Doctor", "Analista"])
        enviar2 = formulario2.form_submit_button(label="Enviar")

        if enviar2:
            st.info(f"El puesto seleccionado es: {puesto}")

    # --- Enfoque 3: Calculadora de salarios ---
    elif seleccion == "Calculadora de Salario":
        with st.form(key="formulario_salario"):
            col1, col2, col3 = st.columns(3)

            with col1:
                tarifa_hora = st.number_input("💵 Tarifa por hora ($)", min_value=0.0, step=0.5)
            with col2:
                horas_semana = st.number_input("🕒 Horas por semana", min_value=0, max_value=168, step=1)
            with col3:    
                calcular = st.form_submit_button("📊 Calcular salario")

            if calcular:
                # Cálculos
                sueldo_diario = tarifa_hora * 8
                sueldo_semanal = tarifa_hora * horas_semana
                sueldo_mensual = sueldo_semanal * 4
                sueldo_anual = sueldo_semanal * 52

                # Resultados
                st.subheader("📈 Desglose del salario")
                col1, col2 = st.columns(2)

                with col1:
                    st.write(f"📅 **Sueldo Diario:** ${sueldo_diario:,.2f}")
                    st.write(f"📅 **Sueldo Semanal:** ${sueldo_semanal:,.2f}")
                with col2:
                    st.write(f"📅 **Sueldo Mensual:** ${sueldo_mensual:,.2f}")
                    st.write(f"📅 **Sueldo Anual:** ${sueldo_anual:,.2f}")

main()