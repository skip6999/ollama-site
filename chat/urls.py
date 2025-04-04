# chat/urls.py

from django.urls import path
from .views import index, chat_with_ollama

urlpatterns = [
    path('', index),
    path('api/ollama/', chat_with_ollama),
]
