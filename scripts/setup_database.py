import subprocess
import os

# Get the directory of the current script
script_dir = os.path.dirname(os.path.abspath(__file__))

# Define the paths to the scripts
id_generator_script = os.path.join(script_dir, 'id_generator.py')
game_venue_matching_script = os.path.join(script_dir, 'game_venue_matching.py')
retrieve_weather_data_script = os.path.join(script_dir, 'retrieve_weather_data.py')
generate_db_file_script = os.path.join(script_dir, 'generate_db_file.py')

# Run id_generator.py
subprocess.run(["python", id_generator_script], check=True)

# Run game_venue_matching.py
subprocess.run(["python", game_venue_matching_script], check=True)

# Run retrieve_weather_data.py with the api_type argument
subprocess.run(["python", retrieve_weather_data_script, "--api_type", "archive"], check=True)

# Run game_venue_matching.py
subprocess.run(["python", generate_db_file_script], check=True)