from flask import Flask, render_template
from flask_socketio import SocketIO
import collections

app = Flask(__name__)
socketio = SocketIO(app, cors_allowed_origins="*")

# Store last 40 system stat values (per VM)
MAX_RECORDS = 40
stats_data = collections.defaultdict(lambda: collections.deque(maxlen=MAX_RECORDS))

@app.route("/")
def index():
    return render_template("index.html")

@socketio.on("system_stats")
def handle_data(data):
    vm_name = data["vm_name"]
    stats_data[vm_name].append(data)  # Keep only last 40 values

    # Convert deque to list before emitting
    formatted_data = {key: list(value) for key, value in stats_data.items()}
    
    # Broadcast updated data to all connected clients
    socketio.emit("update_ui", {"stats": formatted_data})

if __name__ == "__main__":
    socketio.run(app, host="0.0.0.0", port=5000, debug=True)
