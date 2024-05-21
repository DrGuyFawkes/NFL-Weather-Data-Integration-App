import sqlite3
import pandas as pd
import os

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the file paths
hourly_weather_file = os.path.join(script_dir, '../data/hourly_weather.csv')
daily_weather_file = os.path.join(script_dir, '../data/daily_weather.csv')
games_file = os.path.join(script_dir, '../data/games_with_uuids.csv')
venues_file = os.path.join(script_dir, '../data/venues_with_uuids.csv')
db_file = os.path.join(script_dir, '../data/weather_data.db')

# Connect to SQLite database (or create it)
conn = sqlite3.connect(db_file)
cursor = conn.cursor()

# Load the first CSV data into a DataFrame
hourly_weather_df = pd.read_csv(hourly_weather_file)
# Write the DataFrame to the SQLite database
hourly_weather_df.to_sql('hourly_weather', conn, if_exists='replace', index=False)

# Load the second CSV data into a DataFrame
daily_weather_df = pd.read_csv(daily_weather_file)
# Write the DataFrame to the SQLite database
daily_weather_df.to_sql('daily_weather', conn, if_exists='replace', index=False)

# Load the games CSV data into a DataFrame
games_df = pd.read_csv(games_file)
# Write the DataFrame to the SQLite database
games_df.to_sql('games', conn, if_exists='replace', index=False)

# Load the venues CSV data into a DataFrame
venues_df = pd.read_csv(venues_file)
# Write the DataFrame to the SQLite database
venues_df.to_sql('venues', conn, if_exists='replace', index=False)

# Commit and close the connection
conn.commit()
conn.close()

print(f"Database generated and saved to {db_file}.")
