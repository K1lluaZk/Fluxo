import socket
import os
import threading
import time

IP_SERVIDOR = "192.168.100.4"
IP_CELULAR = "192.168.100.12"
PUERTO_RECIBIR = 5005
PUERTO_ENVIAR = 5006
BUFFER_SIZE = 4096
SEPARATOR = "<SEPARATOR>"

# Carpeta que Python vigilará
FOLDER_VINCULADA = os.path.join(os.path.expanduser("~"), "Downloads")
os.makedirs(FOLDER_VINCULADA, exist_ok=True)

def servidor_recibir():
    server = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
    server.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
    server.bind((IP_SERVIDOR, PUERTO_RECIBIR))
    server.listen(5)
    while True:
        client, _ = server.accept()
        try:
            raw = client.recv(BUFFER_SIZE).decode(errors="ignore")
            if SEPARATOR in raw:
                filename, filesize = raw.split(SEPARATOR)
                client.sendall(b"READY")
                with open(os.path.join(FOLDER_VINCULADA, filename), "wb") as f:
                    recibido = 0
                    while recibido < int(filesize):
                        data = client.recv(BUFFER_SIZE)
                        if not data: break
                        f.write(data)
                        recibido += len(data)
                client.sendall(b"RECIBIDO")
        except: pass
        finally: client.close()

def enviar_al_celular(path):
    try:
        client = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        client.connect((IP_CELULAR, PUERTO_ENVIAR))
        name, size = os.path.basename(path), os.path.getsize(path)
        client.sendall(f"{name}{SEPARATOR}{size}".encode())
        if "READY" in client.recv(BUFFER_SIZE).decode():
            with open(path, "rb") as f:
                while data := f.read(BUFFER_SIZE): client.sendall(data)
        client.close()
    except: pass

def monitor_de_carpeta():
    """ Revisa si pusiste algo nuevo en la carpeta de la PC para mandarlo al celular """
    procesados = set(os.listdir(FOLDER_VINCULADA))
    while True:
        actuales = set(os.listdir(FOLDER_VINCULADA))
        nuevos = actuales - procesados
        for archivo in nuevos:
            enviar_al_celular(os.path.join(FOLDER_VINCULADA, archivo))
        procesados = actuales
        time.sleep(2)

if __name__ == "__main__":
    threading.Thread(target=servidor_recibir, daemon=True).start()
    print(f"[*] Fluxo vinculado. Carpeta: {FOLDER_VINCULADA}")
    monitor_de_carpeta()