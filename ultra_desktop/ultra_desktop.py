
import tkinter as tk
from tkinter import scrolledtext, messagebox
import requests
from datetime import datetime
import json
import threading
import os

# Load system prompt config
CONFIG_FILE = os.path.join(os.path.dirname(__file__), "ultra_config.json")
with open(CONFIG_FILE, "r") as f:
    config = json.load(f)

OLLAMA_URL = "http://localhost:18181/api/generate"
OLLAMA_INFO_URL = "http://localhost:18181/api/show"

# --- Core function ---
def send_prompt():
    prompt = input_box.get("1.0", tk.END).strip()
    if not prompt:
        return

    timestamp = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    chat_output.config(state=tk.NORMAL)
    chat_output.insert(tk.END, f"[{timestamp}] You: {prompt}\nMistral: thinking...\n")
    chat_output.see(tk.END)
    chat_output.config(state=tk.DISABLED)
    input_box.delete("1.0", tk.END)
    root.update()

    def stream_response():
        try:
            payload = {
                "model": config.get("model", "mistral"),
                "system": config.get("system", ""),
                "prompt": prompt
            }
            response = requests.post(OLLAMA_URL, json=payload, stream=True)
            if response.status_code != 200:
                chat_output.config(state=tk.NORMAL)
                chat_output.insert(tk.END, f"[Error]: Server returned status {response.status_code}\n\n")
                chat_output.config(state=tk.DISABLED)
                return

            placeholder_index = chat_output.index("end-2l")
            chat_output.config(state=tk.NORMAL)
            chat_output.delete(placeholder_index, f"{placeholder_index} lineend")
            first_token = True
            for line in response.iter_lines():
                if line:
                    try:
                        data = json.loads(line.decode('utf-8'))
                        token = data.get("response")
                        if token:
                            if first_token:
                                ts = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
                                chat_output.insert(tk.END, f"[{ts}] Mistral: ")
                                first_token = False
                            chat_output.insert(tk.END, token)
                            chat_output.see(tk.END)
                    except json.JSONDecodeError:
                        continue
            chat_output.insert(tk.END, "\n\n")
            chat_output.config(state=tk.DISABLED)

        except requests.exceptions.RequestException as e:
            chat_output.config(state=tk.NORMAL)
            chat_output.insert(tk.END, f"[Connection Error]: {e}\n\n")
            chat_output.config(state=tk.DISABLED)

    threading.Thread(target=stream_response, daemon=True).start()

# --- Model Info function ---
def show_model_info():
    try:
        response = requests.post(OLLAMA_INFO_URL, json={"model": config.get("model", "mistral")})
        data = response.json()
        info = f"Model: {data.get('model')}\nFormat: {data.get('format')}\nParameters: {data.get('parameters')}\n" \
               f"System Prompt: {config.get('system', '[not configured]')}"
        messagebox.showinfo("Model Info", info)
    except Exception as e:
        messagebox.showerror("Error", f"Could not fetch model info:\n{e}")

# --- Clear Chat ---
def clear_chat():
    chat_output.config(state=tk.NORMAL)
    chat_output.delete("1.0", tk.END)
    chat_output.config(state=tk.DISABLED)

# --- GUI Setup ---
root = tk.Tk()
root.title("Ultra Baby")
root.minsize(600, 550)
root.configure(bg="black")

root.grid_rowconfigure(0, weight=1)
root.grid_columnconfigure(0, weight=1)

chat_output = scrolledtext.ScrolledText(root, wrap=tk.WORD, bg="black", fg="lime", insertbackground="lime",
                                        font=("Courier", 16), state=tk.DISABLED)
chat_output.grid(row=0, column=0, columnspan=3, padx=10, pady=10, sticky="nsew")

input_box = tk.Text(root, height=4, bg="black", fg="lime", insertbackground="lime", font=("Courier", 16))
input_box.grid(row=1, column=0, columnspan=3, padx=10, pady=(0, 5), sticky="ew")

send_button = tk.Button(root, text="Send", command=send_prompt, bg="black", fg="lime",
                        activebackground="lime", activeforeground="black", font=("Courier", 12))
send_button.grid(row=2, column=0, padx=10, pady=(0, 10), sticky="ew")

info_button = tk.Button(root, text="Model Info", command=show_model_info, bg="black", fg="lime",
                        activebackground="lime", activeforeground="black", font=("Courier", 12))
info_button.grid(row=2, column=1, padx=10, pady=(0, 10), sticky="ew")

clear_button = tk.Button(root, text="Clear Chat", command=clear_chat, bg="black", fg="lime",
                         activebackground="lime", activeforeground="black", font=("Courier", 12))
clear_button.grid(row=2, column=2, padx=10, pady=(0, 10), sticky="ew")

input_box.bind("<Return>", lambda event: (send_prompt(), "break"))

root.mainloop()
