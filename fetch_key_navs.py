import requests
import pandas as pd

schemes = {
    "SBI_Bluechip": "119551",
    "ICICI_Bluechip": "120503",
    "Nippon_Large_Cap": "118632",
    "Axis_Bluechip": "119092",
    "Kotak_Bluechip": "120841"
}

for name, code in schemes.items():
    url = f"https://api.mfapi.in/mf/{code}"

    response = requests.get(url)
    response.raise_for_status()

    data = response.json()
    nav_data = pd.DataFrame(data["data"])

    output_file = f"data/raw/nav_{code}.csv"
    nav_data.to_csv(output_file, index=False)

    print(f"{name}: {len(nav_data)} NAV records saved")