# NFL Weather Data Integration App

This project integrates game day weather data into an internal application for NFL games. The application retrieves historical weather data using the Open Meteo weather API and combines it with NFL game and venue information to provide insights through SQL queries. The project is containerized using Docker for easy setup and deployment.

## Project Structure

```
/flask_nfl_weather_app
│
├── app
│   ├── __init__.py
│   ├── app.py
│   ├── templates
│   │   └── index.html
│   └── static
│       └── # (static files like CSS, JS if needed)
├── scripts
│   ├── id_generator.py
│   ├── game_venue_matching.py
│   ├── retrieve_weather_data.py
│   ├── setup_database.py
│   ├── generate_db_file.py
│   └── weather_forecast.py
├── data
│   ├── Venues.csv
│   ├── Games.csv
│   ├── games_with_venues.csv
│   ├── hourly_weather.csv
│   ├── daily_weather.csv
│   ├── weather_data.db
├── Dockerfile
├── requirements.txt
└── README.md
```

## Setup and Usage

### Prerequisites

- Docker
- Python 3.9

### Running the Application

1. **Build the Docker Image**:

   ```bash
   docker build -t flask-nfl-weather-app .
   ```

2. **Run the Docker Container**:

   ```bash
   docker run -p 5000:5000 flask-nfl-weather-app
   ```

3. **Access the Application**:

   Open your web browser and navigate to `http://localhost:5000`.

### Scripts Description

1. **id_generator.py**:
   - Generates UUIDs for venues and games based on specific columns.
   - Saves the updated data to `venues_with_uuids.csv` and `games_with_uuids.csv`.

2. **game_venue_matching.py**:
   - Matches games with venues based on location and team information.
   - Saves the matched data to `games_with_venues.csv`.

3. **retrieve_weather_data.py**:
   - Retrieves historical weather data for the games using the Open Meteo weather API.
   - Saves the weather data to `hourly_weather.csv` and `daily_weather.csv`.
   - Run with the argument `--api_type` to specify the type of API to use (e.g., `archive`).

4. **generate_db_file.py**:
   - Loads the weather data and game information into a SQLite database.
   - Saves the database to `weather_data.db`.

5. **setup_database.py**:
   - Runs all the above scripts in the correct order to set up the database.
   - Run with the argument `--api_type` to pass the API type to `retrieve_weather_data.py`.

### Flask Application

The Flask application provides a web interface to execute SQL queries on the SQLite database. 

**app/app.py**:
- Defines routes and functions for the Flask web application.
- Connects to the SQLite database and executes SQL queries.

### SQL Queries

Use the web interface to execute SQL queries on the combined NFL game and weather data. Example queries can include:

- Average temperature during games.
- Total precipitation and game outcomes.
- Wind speed and game performance.

### Notes

- Ensure the data files (`Venues.csv`, `Games.csv`) are placed in the `data` directory before running the setup scripts.
- Adjust API request limits and other parameters in the scripts as needed.

## License

This project is licensed under the MIT License. See the LICENSE file for details.

```

This README provides an overview of the project, setup instructions, descriptions of the scripts, and information on how to run the application. If you need any additional information or adjustments, feel free to let me know!