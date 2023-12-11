from flask import Flask, render_template, request
import requests
from datetime import datetime

project = Flask(__name__)

@project.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        location = request.form['location']
    else:
        location = 'Tel Aviv'
    api_key = '09e94055a3ca4e7c8a0124954231406'
    url = f'https://api.weatherapi.com/v1/forecast.json?key={api_key}&q={location}&days=8'
    response = requests.get(url)
    if response.status_code == 200:
        data = response.json()
        weather_data = get_weather_data(location, data)
        return render_template('template.html', weather_data=weather_data, error_message=None)
    else:
        error_message = f"Couldn't find {location}, please write a valid city :)"
        return render_template('template.html', weather_data=None, error_message=error_message)


def get_weather_data(location, data):

    forecastdays = data['forecast']['forecastday']
    weather_data = {}
    weather_data['city'] = location
    weather_data['country'] = data['location']['country']
    weather_data['forecast'] = []

    for whole_day_info in forecastdays:
        date = whole_day_info["date"]
        day_count = 0
        night_count = 0
        datetime_object = datetime.strptime(date, "%Y-%m-%d")
        formatted_date = datetime_object.strftime("%d-%m-%Y")
        day_name = datetime_object.strftime("%A")
        day_avg_temp = 0
        day_avg_humidity = 0
        night_avg_temp = 0
        night_avg_humidity = 0
        icon = whole_day_info["day"]["condition"]["icon"]
        hours = whole_day_info["hour"]
        for hour in hours:
            if hour["is_day"] == 1:
                day_avg_temp += hour["temp_c"]
                day_avg_humidity += hour["humidity"]
                day_count += 1
            else:
                night_avg_temp += hour["temp_c"]
                night_avg_humidity += hour["humidity"]
                night_count += 1

        day_avg_temp /= day_count
        day_avg_humidity /= day_count
        night_avg_temp /= night_count
        night_avg_humidity /= night_count
        weather_data['forecast'].append({"date": formatted_date, "day_avg_temp": int(day_avg_temp),
                                         "day_avg_humidity": int(day_avg_humidity),
                                         "night_avg_temp": int(night_avg_temp),
                                         "night_avg_humidity": int(night_avg_humidity),
                                         "icon": icon, "day_name": day_name})

    return weather_data

if __name__ == '__main__':
    project.run(host='0.0.0.0', port=8080)

