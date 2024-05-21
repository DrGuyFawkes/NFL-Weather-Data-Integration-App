-- # 1: Aggregated Weather Conditions for Tennessee Titans Games in 2023
-- Query Description:
    -- This SQL query retrieves aggregated weather data and 
    -- detailed information about NFL games involving the Tennessee Titans during the 2023 season.
    -- It calculates average weather conditions for the hour before each game and during the game itself.
    -- The results are grouped by various game and venue details.
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
    -- name as stadium: The name of the stadium.
    -- surface: The type of surface at the venue (e.g., grass, turf).
    -- roof_type: The type of roof at the venue (e.g., open, retractable).
    -- temperature: The average temperature at 2 meters above ground level, rounded to three decimal places.
    -- humidity: The average relative humidity at 2 meters above ground level, rounded to three decimal places.
    -- precipitation: The average precipitation, rounded to three decimal places.
    -- rain: The average rainfall, rounded to three decimal places.
    -- snowfall: The average snowfall, rounded to three decimal places.
    -- weather_data_source: A static field indicating the source of the weather data.
    -- weather_data_type: A static field indicating the type of weather data (hourly).
-- Usage:
    -- Even though the query uses historical data, this data can be used with a forecast API. For pre-game reports, this query can be used to retrieve weather data.
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
  round(
    avg(w.temperature_2m), 
    3
  ) as temperature, 
  round(
    avg(w.relative_humidity_2m), 
    3
  ) as humidity, 
  round(
    avg(w.precipitation), 
    3
  ) as precipitation, 
  round(
    avg(w.rain), 
    3
  ) as rain, 
  round(
    avg(w.snowfall), 
    3
  ) as snowfall, 
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
  and date between datetime(gmt_game_datetime, '-1 hour') 
  and gmt_game_datetime 
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