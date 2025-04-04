from django.urls import path
from .views import chat_with_ollama

urlpatterns = [
    path('api/ollama/', chat_with_ollama),
]
