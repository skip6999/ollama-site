from django.views.decorators.csrf import csrf_exempt
from django.http import JsonResponse
import requests
import json

OLLAMA_API_URL = "http://ollama_model:11434/api/generate"

@csrf_exempt
def chat_with_ollama(request):
    if request.method == 'POST':
        try:
            body = json.loads(request.body)
            prompt = body.get('prompt', '')

            data = {
                "model": "mistral",
                "prompt": prompt,
                "stream": False
            }

            res = requests.post(OLLAMA_API_URL, json=data)
            return JsonResponse({"response": res.json().get("response", "no reply")})
        except Exception as e:
            return JsonResponse({"error": str(e)}, status=500)

    return JsonResponse({"error": "Invalid method"}, status=405)

