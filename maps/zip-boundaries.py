import requests
import json

zip_codes = [
    "90002",
    # "90003",
    # "90004",
    # "90006",
]
headers = {
    "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/50.0.2661.102 Safari/537.36"
}

boundry_coordinates = []

for code in zip_codes:

    url = "https://www.unitedstateszipcodes.org/%s/" % code
    result = requests.get(url, headers=headers)
    content = result.content.decode().split("\n")

    if len(content) > 230:
        print()
        print(code)
        print(result.status_code)
        geo_json = json.loads(
            result.content.decode().split("\n")[231].replace("geojson = ", "")[:-2]
        )
        boundry_coordinates.append(
            geo_json["features"][0]["geometry"]["coordinates"][0]
        )

from mapping import show_boundries

show_boundries(boundry_coordinates)
