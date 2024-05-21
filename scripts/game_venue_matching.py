import pandas as pd
import os

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Construct the file paths
venues_file = os.path.join(script_dir, '../data/venues_with_uuids.csv')
games_file = os.path.join(script_dir, '../data/games_with_uuids.csv')
output_file = os.path.join(script_dir, '../data/games_with_venues.csv')

# Load CSV files
venues_df = pd.read_csv(venues_file)
games_df = pd.read_csv(games_file)

# Split the 'geo' column into 'latitude' and 'longitude' columns
venues_df[['latitude', 'longitude']] = venues_df['geo'].str.split(',', expand=True)

# Remove any leading/trailing spaces from 'latitude' and 'longitude'
venues_df['latitude'] = venues_df['latitude'].str.strip()
venues_df['longitude'] = venues_df['longitude'].str.strip()

# Convert 'latitude' and 'longitude' to numeric types, coercing errors to NaN
venues_df['latitude'] = pd.to_numeric(venues_df['latitude'], errors='coerce')
venues_df['longitude'] = pd.to_numeric(venues_df['longitude'], errors='coerce')

# Split the 'Location' column into 'city' and 'state' columns
venues_df[['city', 'state']] = venues_df['location'].str.split(',', expand=True)

# Remove any leading/trailing spaces from 'city' and 'state'
venues_df['city'] = venues_df['city'].str.strip()
venues_df['state'] = venues_df['state'].str.strip()

# Select only the 'city', 'uuid', and 'teams' columns from venues_df for the merge
venues_subset_df = venues_df[['city', 'uuid', 'teams']]

# Perform the initial merge
merged_df = pd.merge(games_df, venues_df, left_on='game_site', right_on='city', how='left')

# Identify rows where the merge did not succeed
missing_venues = merged_df[merged_df['uuid_y'].isna()]

# Check for substring match between 'game_site' and 'teams'
def find_team_match(game_site, venues_df):
    for index, row in venues_df.iterrows():
        if pd.notna(row['teams']) and game_site in row['teams']:
            return row
    return None

# Iterate through the rows with missing venues and find matches
for index, row in missing_venues.iterrows():
    match = find_team_match(row['game_site'], venues_df)
    if match is not None:
        merged_df.loc[index, venues_df.columns] = match

# Create the 'venue_uuid' and 'game_uuid' fields using 'uuid_y' if it is not null, otherwise using 'uuid'
merged_df['venue_uuid'] = merged_df['uuid_y'].fillna(merged_df['uuid'])
merged_df['game_uuid'] = merged_df['uuid_x']

# Drop the 'uuid', 'uuid_y', and 'uuid_x' columns
merged_df.drop(columns=['uuid', 'uuid_y', 'uuid_x'], inplace=True)

# Save the DataFrame to a CSV file
merged_df.to_csv(output_file, index=False)

print(f"Merged data saved to {output_file}.")