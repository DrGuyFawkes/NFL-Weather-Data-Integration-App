-- # 5: Weather Variation During Games
-- Query Description:
    -- This SQL query retrieves detailed information about NFL games involving the Tennessee Titans
    -- and calculates the variation in weather conditions during these games.
    -- The weather variations are calculated for the period from the game start time to three hours after the game start time.
    -- The query provides insights into how weather conditions
    -- such as temperature, humidity, precipitation, wind speed, and soil conditions change during the game.
-- Detailed:
    -- season: The season year of the game.
    -- week: The week number of the game.
    -- home_team: The home team.
    -- home_team_final_score: The final score of the home team.
    -- visit_team: The visiting team.
    -- visit_team_final_score: The final score of the visiting team.
    -- game_date: The date the game was played.
    -- start_time: The start time of the game.
    -- total_score: The total score of the game, calculated as the sum of the home and visiting team scores.
    -- location: The location of the venue (city, state).
    -- stadium: The name of the stadium.
    -- surface: The type of surface at the venue (e.g., grass, turf).
    -- roof_type: The type of roof at the venue (e.g., open, retractable).
    -- temperature_variation: The variation in temperature at 2 meters above ground level during the game, rounded to three decimal places.
    -- humidity_variation: The variation in relative humidity at 2 meters above ground level during the game, rounded to three decimal places.
    -- precipitation_variation: The variation in precipitation during the game, rounded to three decimal places.
    -- wind_speed_10m_variation: The variation in wind speed at 10 meters above ground level during the game, rounded to three decimal places.
    -- wind_speed_100m_variation: The variation in wind speed at 100 meters above ground level during the game, rounded to three decimal places.
    -- wind_gusts_10m_variation: The variation in wind gusts at 10 meters above ground level during the game, rounded to three decimal places.
    -- soil_temperature_0_to_7cm_variation: The variation in soil temperature at 0 to 7 cm depth during the game, rounded to three decimal places.
    -- soil_moisture_0_to_7cm_variation: The variation in soil moisture at 0 to 7 cm depth during the game, rounded to three decimal places.
    -- weather_data_source: A static field indicating the source of the weather data.
    -- weather_data_type: A static field indicating the type of weather data (hourly).
-- Usage:
    -- For post-game reports, this query can be used to analyze the variation in weather conditions during games.
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
  g.home_team_final_score + g.visit_team_final_score as total_score, 
  v.location, 
  v.name as stadium, 
  v.surface, 
  v.roof_type, 
  round(max(w.temperature_2m) - min(w.temperature_2m),3) as temperature_variation,
  round(max(w.relative_humidity_2m) - min(w.relative_humidity_2m),3) as humidity_variation,
  round(max(w.precipitation) - min(w.precipitation),3) as precipitation_variation,
  round(max(w.wind_speed_10m) - min(w.wind_speed_10m),3) as wind_speed_10m_variation,
  round(max(w.wind_speed_100m) - min(w.wind_speed_100m),3) as wind_speed_100m_variation,
  round(max(w.wind_gusts_10m) - min(w.wind_gusts_10m),3) as wind_gusts_10m_variation,
  round(max(w.soil_temperature_0_to_7cm) - min(w.soil_temperature_0_to_7cm),3) as soil_temperature_0_to_7cm_variation,
  round(max(w.soil_moisture_0_to_7cm) - min(w.soil_moisture_0_to_7cm),3) as soil_moisture_0_to_7cm_variation,
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
group by 
  g.season, 
  g.week, 
  g.home_team, 
  g.home_team_final_score, 
  g.visit_team, 
  g.visit_team_final_score, 
  g.game_date, 
  g.start_time, 
  v.location, 
  v.name, 
  v.surface, 
  v.roof_type