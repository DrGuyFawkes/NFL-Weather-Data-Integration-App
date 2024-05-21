import pandas as pd
import openmeteo_requests
import requests_cache
import pandas as pd
from retry_requests import retry

# Setup the Open-Meteo API client with cache and retry on error
cache_session = requests_cache.CachedSession('.cache', expire_after=3600)
retry_session = retry(cache_session, retries=5, backoff_factor=0.2)
openmeteo = openmeteo_requests.Client(session=retry_session)

def retrieve_weather_data(api_type:str, url:str, hourly_variables:list, daily_variables:list, latitude:float, longitude:float, start_date:str, end_date:str, timezone:str):
    params = {
        "latitude": latitude,
        "longitude": longitude,
        "start_date": start_date,
        "end_date": end_date,
        "hourly": hourly_variables,
        "daily": daily_variables,
        "temperature_unit": "fahrenheit",
        "wind_speed_unit": "mph",
        "precipitation_unit": "inch",
        "timezone": timezone}
    
    try:
        responses = openmeteo.weather_api(url, params=params)
        response = responses[0]

        # Process hourly data
        hourly = response.Hourly()

        hourly_data = {"date": pd.date_range(
            start=pd.to_datetime(hourly.Time(), unit="s", utc=True),
            end=pd.to_datetime(hourly.TimeEnd(), unit="s", utc=True),
            freq=pd.Timedelta(seconds=hourly.Interval()),
            inclusive="left"
        )}
        for i, var in enumerate(hourly_variables):
            hourly_data[var] = hourly.Variables(i).ValuesAsNumpy()

        hourly_dataframe = pd.DataFrame(data=hourly_data)

        # Process daily data
        daily = response.Daily()

        daily_data = {"date": pd.date_range(
            start=pd.to_datetime(daily.Time(), unit="s", utc=True),
            end=pd.to_datetime(daily.TimeEnd(), unit="s", utc=True),
            freq=pd.Timedelta(seconds=daily.Interval()),
            inclusive="left"
        )}
        for i, var in enumerate(daily_variables):
            daily_data[var] = daily.Variables(i).ValuesAsNumpy()

        daily_dataframe = pd.DataFrame(data=daily_data)

        return hourly_dataframe, daily_dataframe

    except Exception as e:
        print(f"An error occurred: {e}")
        return None, None
    
# Function to retrieve weather forecast using adjusted dates
def retrieve_weather_for_game(api_type, url, hourly_variables, daily_variables, latitude, longitude, start_date, end_date, timezone):
                    
    hourly_weather_df, daily_weather_df = retrieve_weather_data(api_type, url, hourly_variables, daily_variables, latitude, longitude, start_date, end_date, timezone)
    
    return hourly_weather_df, daily_weather_df

