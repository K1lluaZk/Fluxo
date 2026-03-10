import socket
import os

# Configuración inicial
IP_SERVIDOR = "0.0.0.0"  # Escucha en todas las interfaces de red local
PUERTO = 5005
BUFFER_SIZE = 4096  # 4KB por paquete
SEPARATOR = "<SEPARATOR>"

def iniciar_servidor():
    # 1. Crear el Socket TCP
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    # 2. Enlazar el socket al puerto
    try:
        server_socket.bind((IP_SERVIDOR, PUERTO))
        server_socket.listen(5)
        print(f"[*] Servidor iniciado en {IP_SERVIDOR}:{PUERTO}")
        print("[*] Esperando conexión del celular...")
    except Exception as e:
        print(f"[!] Error al iniciar: {e}")
        return

    while True:
        # 3. Aceptar nueva conexión
        client_socket, address = server_socket.accept()
        print(f"[+] Celular conectado desde: {address}")

        try:
            # 4. Recibir metadatos
            raw_data = client_socket.recv(BUFFER_SIZE).decode()
            if not raw_data or SEPARATOR not in raw_data:
                raise ValueError("Datos de protocolo inválidos")

            filename, filesize = raw_data.split(SEPARATOR)
            filename = os.path.basename(filename)
            filesize = int(filesize)

            print(f"[*] Metadatos recibidos: {filename} ({filesize} bytes)")

            # --- Confirmación al cliente ---
            client_socket.send("READY".encode())

            # 5. Recibir el contenido del archivo
            with open(f"recibido_{filename}", "wb") as f:
                bytes_recibidos = 0

                while bytes_recibidos < filesize:
                    bytes_to_read = min(BUFFER_SIZE, filesize - bytes_recibidos)
                    bytes_read = client_socket.recv(bytes_to_read)

                    if not bytes_read:
                        break

                    f.write(bytes_read)
                    bytes_recibidos += len(bytes_read)

            print(f"[V] Archivo {filename} guardado. Total: {bytes_recibidos} bytes.")

        except Exception as e:
            print(f"[!] Error durante la transferencia: {e}")

        finally:
            client_socket.close()


if __name__ == "__main__":
    iniciar_servidor()