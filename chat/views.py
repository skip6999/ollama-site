from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt
from django.shortcuts import render
import requests
import json

# Point this to the correct Ollama endpoint
# If you're using the host Ollama, use host.docker.internal
OLLAMA_API_URL = "http://192.168.1.122:11434/api/chat"

def index(request):
    return render(request, 'chat/index.html')

@csrf_exempt
def chat_with_ollama(request):
    if request.method == 'POST':
        try:
            body = json.loads(request.body)
            prompt = body.get('prompt', '')

            print("🔹 Prompt received from frontend:", prompt)

            res = requests.post(OLLAMA_API_URL, json={
                "model": "mistral",
                "messages": [
                    {
                        "role": "system",
                        "content": (
                            "You are Lilly, an AI assistant running inside a Docker container "
                            "hosted by Eric Jensen. You're helpful, honest, direct, and chill. "
                            "Do not hallucinate commands or tutorials. Only reply with accurate info "
                            "or say you don't know. You're part of a self-hosted AI stack — own it."
                        )
                    },
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                "stream": False
            })

            print("🧠 FULL RAW RESPONSE FROM OLLAMA:")
            print(res.text)
            return JsonResponse({"debug": res.text})

            response_data = res.json()

            # Fallback for both response formats
            message = response_data.get("response") or response_data.get("message", {}).get("content", "no reply")

            return JsonResponse({"response": message})

        except Exception as e:
            print("🔥 Error in chat_with_ollama:", e)
            return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse({"error": "Invalid method"}, status=405)

