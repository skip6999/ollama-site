# Use the official Python image from Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /app

# Copy the requirements.txt into the container
COPY requirements.txt /app/

RUN apt-get update && \
    apt-get install -y libpq-dev gcc python3-dev && \
    apt-get clean


# Install the Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the Django project into the container
COPY . /app/

# Expose the port that Django runs on
EXPOSE 8000

# Run Django using Gunicorn (WSGI server) for production
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "ollama_web.wsgi:application"]
