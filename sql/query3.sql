-- # 3: Games with Extreme Weather Conditions
-- Query Description:
    -- This SQL query retrieves detailed information about NFL games involving the Tennessee Titans,
    -- focusing on games where the temperature was below freezing (32°C) or there was significant precipitation (more than 1mm).
    -- The information includes game details, venue details, 
    -- and specific weather conditions for the time period spanning from the game start time to three hours after the game start time.
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
    -- temperature_2m as temperature: The temperature at 2 meters above ground level during the game.
    -- relative_humidity_2m as humidity: The relative humidity at 2 meters above ground level during the game.
    -- precipitation: The amount of precipitation during the game.
    -- weather_data_source: A static field indicating the source of the weather data.
    -- weather_data_type: A static field indicating the type of weather data (hourly).
-- Usage:
    -- The query focuses on extreme weather conditions, making it useful for analyzing how such conditions may have affected game outcomes.
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
  and date between gmt_game_datetime 
  and datetime(gmt_game_datetime, '+3 hour')
  and (w.temperature_2m < 32
  or w.precipitation > 1)
