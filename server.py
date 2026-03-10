import socket
import os

# Configuración inicial
IP_SERVIDOR = "0.0.0.0"  
PUERTO = 5005
BUFFER_SIZE = 4096  
SEPARATOR = "<SEPARATOR>"

def iniciar_servidor():
    server_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)

    try:
        server_socket.bind((IP_SERVIDOR, PUERTO))
        server_socket.listen(5)
        print(f"[*] Fluxo Server iniciado en puerto {PUERTO}")
        print("[*] Esperando conexión del celular...")
    except Exception as e:
        print(f"[!] Error al iniciar: {e}")
        return

    while True:
        client_socket, address = server_socket.accept()
        print(f"\n[+] Celular conectado desde: {address}")

        try:
            # Recibir metadatos
            raw_data = client_socket.recv(BUFFER_SIZE).decode()
            if not raw_data or SEPARATOR not in raw_data:
                raise ValueError("Datos de protocolo inválidos")

            filename, filesize = raw_data.split(SEPARATOR)
            filename = os.path.basename(filename)
            filesize = int(filesize)

            print(f"{filename} ({filesize / 1024:.2f} KB)")

            # Confirmación al dispositivo
            client_socket.send("READY".encode())

            with open(f"{filename}", "wb") as f:
                bytes_recibidos = 0

                while bytes_recibidos < filesize:
                    bytes_to_read = min(BUFFER_SIZE, filesize - bytes_recibidos)
                    bytes_read = client_socket.recv(bytes_to_read)

                    if not bytes_read:
                        break

                    f.write(bytes_read)
                    bytes_recibidos += len(bytes_read)

                    progreso = (bytes_recibidos / filesize) * 100
                    print(f"\r    Progreso: {progreso:.1f}% [{bytes_recibidos}/{filesize} bytes]", end="")

            print(f"\n[V] ¡Archivo {filename} guardado con éxito!")

        except Exception as e:
            print(f"\n[!] Error durante la transferencia: {e}")

        finally:
            client_socket.close()

if __name__ == "__main__":
    iniciar_servidor()