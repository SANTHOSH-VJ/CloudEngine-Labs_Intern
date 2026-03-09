# Use official Python slim image for smaller footprint
FROM python:3.11-slim

# Set working directory
WORKDIR /app

# Copy requirements first for better caching
COPY requirements.txt .

# Install Flask
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application
COPY app.py .

# Expose port 5000
EXPOSE 5000

# Start the Flask application
CMD ["python", "app.py"]
