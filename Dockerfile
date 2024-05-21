# Use an official Python runtime as a parent image
FROM python:3.9

# Set the working directory in the container
WORKDIR /app

# Copy the requirements file and install any needed packages
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the application code and scripts into the container
COPY app /app/app
COPY data /app/data
COPY __init__.py /app/__init__.py

# Set the working directory back to the application directory
WORKDIR /app/app

# Make port 5000 available to the world outside this container
EXPOSE 5000

# Define environment variable
ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Run app.py when the container launches
CMD ["flask", "run"]
