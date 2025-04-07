#!/bin/bash

ollama serve &

sleep 5

ollama run jnsn5498/yankee-grit

# Prevent container from exiting
tail -f /dev/null


