import pandas as pd
import hashlib
import uuid
import os
import pytz
from datetime import datetime, timedelta

# Function to convert to GMT datetime string
def convert_to_gmt(row):
    # Combine game_date and start_time into a single datetime object
    local_time = datetime.strptime(f"{row['Game_Date']} {row['Start_Time']}", "%m/%d/%Y %H:%M")
    # Apply the GMT offset
    gmt_time = local_time - timedelta(hours=row['Start_Time_GMT_Offset'])
    # Convert to GMT time and format as a string
    gmt_time = gmt_time.replace(tzinfo=pytz.FixedOffset(0))
    return gmt_time.strftime("%Y-%m-%d %H:%M:%S+00:00")

def generate_uuid_from_row(row, columns):
    concatenated = ''.join(str(row[col]) for col in columns)
    return str(uuid.UUID(hashlib.md5(concatenated.encode()).hexdigest()))

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the file paths
venues_file = os.path.join(script_dir, '../data/Venues.csv')
games_file = os.path.join(script_dir, '../data/Games.csv')

try:
    venues_df = pd.read_csv(venues_file, encoding='ISO-8859-1')
    games_df = pd.read_csv(games_file)
except FileNotFoundError as e:
    print(f"Error: {e}")
    exit(1)

# Apply the conversion function to each row
games_df['gmt_game_datetime'] = games_df.apply(convert_to_gmt, axis=1)

# Specify the columns to use for generating the UUID
venue_columns = ['Name']
game_columns = ['Season', 'Week', 'Start_Time', 'Game_Site']

# Generate UUIDs for venues_df
venues_df['UUID'] = venues_df.apply(lambda row: generate_uuid_from_row(row, venue_columns), axis=1)

# Generate UUIDs for games_df
games_df['UUID'] = games_df.apply(lambda row: generate_uuid_from_row(row, game_columns), axis=1)


# Rename specific columns
venues_df = venues_df.rename(columns={
    'Roof Type': 'roof_type',
    'Team(s)': 'teams'
})

# Convert column headers to lowercase
venues_df.columns = [col.lower() for col in venues_df.columns]
games_df.columns = [col.lower() for col in games_df.columns]

# Save the DataFrame to a CSV file
venues_output_file = os.path.join(script_dir, '../data/venues_with_uuids.csv')
games_output_file = os.path.join(script_dir, '../data/games_with_uuids.csv')

venues_df.to_csv(venues_output_file, index=False)
games_df.to_csv(games_output_file, index=False)

print(f"UUIDs generated and saved to {venues_output_file} and {games_output_file}.")