import unittest
import requests
from app import project

class TestMyFlaskApp(unittest.TestCase):
    def setUp(self):
        self.base_url = 'http://localhost:8080'

    def test_app_is_up(self):
        response = requests.get(self.base_url)
        self.assertEqual(response.status_code, 200)

    def test_can_reach_app(self):
        response = requests.get(f'{self.base_url}/')
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Enter Location:', response.content)
        self.assertIn(b'Weather Forecast', response.content)

    def test_valid_location(self):
        city_name = 'ashqelon'
        response = requests.post(f'{self.base_url}/', data={'location': city_name})
        self.assertEqual(response.status_code, 200)
        self.assertIn(f'Weather Forecast for {city_name}'.encode(), response.content)
        self.assertIn(b'Temperature', response.content)

    def test_invalid_location(self):
        response = requests.post(f'{self.base_url}/', data={'location': 'notarealplace'})
        self.assertEqual(response.status_code, 200)
        self.assertIn(b'Try again!', response.content)
        self.assertIn(b'Enter Location:', response.content)

if __name__ == '__main__':
    unittest.main()

