import pytest
from app import project

@pytest.fixture
def app():
    app = project.test_client()
    return app

def test_can_reach_app(app):
    response = app.get('/')
    assert response.status_code == 200
    assert b'Enter Location:' in response.data
    assert b'Weather Forecast' in response.data

def test_valid_location(app):
    city_name = 'ashqelon'
    response = app.post('/', data={'location': city_name})
    assert response.status_code == 200
    assert f'Weather Forecast for {city_name}'.encode() in response.data
    assert b'Temperature' in response.data

def test_invalid_location(app):
    response = app.post('/', data={'location': 'notarealplace'})
    assert response.status_code == 200
    assert b'Try again!' in response.data
    assert b'Enter Location:' in response.data
