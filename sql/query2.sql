-- # 2: 
-- Query Description:
    -- This SQL query retrieves detailed information about NFL games involving the Tennessee Titans during the 2023 season.
    -- It includes game details, venue details, and specific weather conditions for the time period spanning from the game start time to three hours after the game start time.
    -- This data can be used to write a comprehensive post-game report.
-- Detailed:
    -- season: The season year of the game.
    -- week: The week number of the game.
    -- home_team: The home team.
    -- home_team_final_score: The final score of the home team.
    -- visit_team: The visiting team.
    -- visit_team_final_score: The final score of the visiting team.
    -- game_date: The date the game was played.
    -- start_time: The start time of the game.
    -- location: The location of the venue (city, state).
    -- stadium: The name of the stadium.
    -- surface: The type of surface at the venue (e.g., grass, turf).
    -- roof_type: The type of roof at the venue (e.g., open, retractable).
    -- temperature: The temperature at 2 meters above ground level during the game.
    -- humidity: The relative humidity at 2 meters above ground level during the game.
    -- precipitation: The amount of precipitation during the game.
    -- rain: The amount of rainfall during the game.
    -- snowfall: The amount of snowfall during the game.
    -- wind_speed_10m: The wind speed at 10 meters above ground level during the game.
    -- wind_direction_10m: The wind direction at 10 meters above ground level during the game.
    -- wind_speed_100m: The wind speed at 100 meters above ground level during the game.
    -- wind_direction_100m: The wind direction at 100 meters above ground level during the game.
    -- wind_gusts_10m: The wind gusts at 10 meters above ground level during the game.
    -- soil_temperature_0_to_7cm: The soil temperature at 0 to 7 cm depth during the game.
    -- soil_moisture_0_to_7cm: The soil moisture at 0 to 7 cm depth during the game.
    -- weather_data_source: A static field indicating the source of the weather data.
    -- weather_data_type: A static field indicating the type of weather data (hourly).
-- Usage:
    -- For post-game reports, this query can be used to retrieve detailed weather data.
-- Query:
SELECT 
  g.season, 
  g.week, 
  g.home_team, 
  g.home_team_final_score, 
  g.visit_team, 
  g.visit_team_final_score, 
  g.game_date, 
  g.start_time, 
  v.location, 
  v.name as stadium, 
  v.surface, 
  v.roof_type, 
  w.temperature_2m as temperature, 
  w.relative_humidity_2m as humidity, 
  w.precipitation, 
  w.rain, 
  w.snowfall, 
  w.wind_speed_10m, 
  w.wind_direction_10m, 
  w.wind_speed_100m, 
  w.wind_direction_100m, 
  w.wind_gusts_10m, 
  w.soil_temperature_0_to_7cm, 
  w.soil_moisture_0_to_7cm, 
  'open-meteo' as weather_data_source, 
  'hourly' as weather_data_type 
FROM 
  hourly_weather w 
  LEFT JOIN games g on w.game_uuid = g.uuid 
  LEFT JOIN venues v on w.venue_uuid = v.uuid 
where 
  (
    g.home_team = 'Tennessee Titans' 
    or g.visit_team = 'Tennessee Titans'
  ) 
  and season = '2023' 
  and date between gmt_game_datetime 
  and datetime(gmt_game_datetime, '+3 hour')
