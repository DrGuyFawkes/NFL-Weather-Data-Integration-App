import pandas as pd
from weather_forecast import retrieve_weather_for_game
from datetime import timedelta
import time
import os
import argparse
import yaml

# Parse command-line arguments
parser = argparse.ArgumentParser(description='Retrieve weather data for NFL games.')
parser.add_argument('--api_type', type=str, required=True, help='The type of API to use (e.g., "archive")')
args = parser.parse_args()
api_type = args.api_type

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the file paths
games_with_venues_file = os.path.join(script_dir, '../data/games_with_venues.csv')
hourly_weather_file = os.path.join(script_dir, '../data/hourly_weather.csv')
daily_weather_file = os.path.join(script_dir, '../data/daily_weather.csv')
manifest_dir = os.path.join(script_dir,"../scripts/manifests")  # Convert to absolute path

# Load merged CSV file
try:
    merged_df = pd.read_csv(games_with_venues_file)
except FileNotFoundError as e:
    print(f"Error: {e}")
    exit(1)

# Initialize empty DataFrames for hourly and daily weather data
all_hourly_weather_df = pd.DataFrame()
all_daily_weather_df = pd.DataFrame()

# Function to retrieve weather data for each game
def process_weather_data(row, manifest):
    try:
        if pd.notna(row['venue_uuid']):
            game_date = row['game_date']
            latitude = row['latitude']
            longitude = row['longitude']
            venue_uuid = row['venue_uuid']
            game_uuid = row['game_uuid']

            game_date_dt = pd.to_datetime(game_date, format='%m/%d/%Y')
            start_date = (game_date_dt - timedelta(days=2)).strftime('%Y-%m-%d')
            end_date = (game_date_dt + timedelta(days=1)).strftime('%Y-%m-%d')
            
            url = manifest['url']
            api_type = manifest['api_type']
            hourly_variables = manifest['hourly_variables']
            daily_variables = manifest['daily_variables']
            timezone = manifest['timezone']

            print(api_type, url, latitude, longitude, start_date, end_date, timezone)
            hourly_weather_df, daily_weather_df = retrieve_weather_for_game(api_type, url, hourly_variables, daily_variables, latitude, longitude, start_date, end_date, timezone)

            if hourly_weather_df is not None and not hourly_weather_df.empty:
                hourly_weather_df['venue_uuid'] = venue_uuid
                hourly_weather_df['game_uuid'] = game_uuid

            if daily_weather_df is not None and not daily_weather_df.empty:
                daily_weather_df['venue_uuid'] = venue_uuid
                daily_weather_df['game_uuid'] = game_uuid
            
            return hourly_weather_df, daily_weather_df
        return pd.DataFrame(), pd.DataFrame()

    except Exception as e:
        print("Error processing weather data: {e}")
        return None, None

# Loop through each manifest file and process weather data
for manifest_file in os.listdir(manifest_dir):
    if manifest_file.endswith(f"{api_type}.yml") or manifest_file.endswith(f"{api_type}.yaml"):
        with open(os.path.join(manifest_dir, manifest_file), 'r') as file:
            manifest = yaml.safe_load(file)
            break

# Loop through each row to retrieve weather data
for index, row in merged_df.iterrows():
    hourly_weather_df, daily_weather_df = process_weather_data(row, manifest)
    if hourly_weather_df is not None:
        all_hourly_weather_df = pd.concat([all_hourly_weather_df, hourly_weather_df])
    if daily_weather_df is not None:
        all_daily_weather_df = pd.concat([all_daily_weather_df, daily_weather_df])
    # Added because API request limit
    time.sleep(0.2)

# Save the DataFrames to CSV files
all_hourly_weather_df.to_csv(hourly_weather_file, index=False)
all_daily_weather_df.to_csv(daily_weather_file, index=False)

print(f"Weather data saved to {hourly_weather_file} and {daily_weather_file}.")
