import socketio
import socket
import psutil
import time

# Replace with the Central VM's IP Address
CENTRAL_SERVER_URL = "http://192.168.56.10:5000"

sio = socketio.Client()

try:
    sio.connect(CENTRAL_SERVER_URL)
    print("Connected to Central Server")
except Exception as e:
    print("Connection failed:", e)
    exit(1)

while True:
    cpu_usage = psutil.cpu_percent(interval=1)
    memory_usage = psutil.virtual_memory().percent
    hostname = socket.gethostname()  # Identify the Edge VM

    data = {
        "vm_name": hostname,
        "cpu": cpu_usage,
        "memory": memory_usage,
    }
    
    sio.emit("system_stats", data)  # Send to Central Server
    time.sleep(2)
