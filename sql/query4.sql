-- # 4: Temperature Impact on Scoring
-- Query Description:
    -- This SQL query analyzes the impact of temperature on the total scoring in NFL games involving the Tennessee Titans.
    -- It calculates the average temperature during each game and the total score for both teams.
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
    -- total_score: The total score of the game, calculated as the sum of the home and visiting team scores.
    -- location: The location of the venue (city, state).
    -- stadium: The name of the stadium.
    -- surface: The type of surface at the venue (e.g., grass, turf).
    -- roof_type: The type of roof at the venue (e.g., open, retractable).
    -- avg_temperature: The average temperature at 2 meters above ground level during the game, rounded to three decimal places.
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
  g.home_team_final_score + g.visit_team_final_score as total_score, 
  v.location, 
  v.name as stadium, 
  v.surface, 
  v.roof_type, 
  round(
    avg(w.temperature_2m), 
    3
  ) as avg_temperature, 
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
