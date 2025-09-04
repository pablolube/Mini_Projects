import streamlit as st
from types import SimpleNamespace  # Para simular objetos tipo chunk

def fake_openai_stream(prompt):
    """
    Simula un stream de respuesta de OpenAI.
    Devuelve fragmentos como si fuera streaming real.
    """
    # Dividimos un texto de ejemplo en partes (tokens simulados)
    fake_response = f"Esto es una respuesta simulada para: {prompt}"
    for word in fake_response.split():
        # Creamos un objeto similar al que OpenAI devuelve
        yield SimpleNamespace(
            choices=[
                SimpleNamespace(
                    delta={"content": word + " "}
                )
            ]
        )

def main():
    ############################################################################################################
    #                                           CONFIGURACION INICIAL                                         #
    ############################################################################################################

    st.set_page_config(
        page_title="Chat Bot con OpenAI",
        page_icon="💬",
        layout="wide"
    )

    ############################################################################################################
    #                                           INICIALIZO                                                    #
    ############################################################################################################

    st.title("💬 Chat Bot con OpenAI (modo prueba sin API)")

    if "messages" not in st.session_state:
        st.session_state.messages = []

    ############################################################################################################
    #                                           MENSAJE user                                                  #
    ############################################################################################################

    for message in st.session_state.messages:
        with st.chat_message(message["role"]):
            st.markdown(message["content"])

    if prompt := st.chat_input("Escribe tu mensaje aquí..."):
        with st.chat_message("user"):
            st.markdown(prompt)
        st.session_state.messages.append({"role": "user", "content": prompt})

        ############################################################################################################
        #                                           RESPUESTA FAKE AI                                             #
        ############################################################################################################

        with st.chat_message("assistant"):
            message_placeholder = st.empty()
            try:
                # Usamos el fake stream en lugar de la API real
                stream = fake_openai_stream(prompt)

                full_response = ""
                for chunk in stream:
                    if chunk.choices[0].delta.get("content"):
                        full_response += chunk.choices[0].delta["content"]
                        message_placeholder.markdown(full_response + " ")

                st.session_state.messages.append({"role": "assistant", "content": full_response})

            except Exception as e:
                st.error(f"Error: {str(e)}")

main()
