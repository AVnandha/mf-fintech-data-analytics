import requests
import pandas as pd

url = "https://api.mfapi.in/mf/125497"

response = requests.get(url)
response.raise_for_status()

data = response.json()

nav_data = pd.DataFrame(data["data"])

nav_data.to_csv("data/raw/live_nav_125497.csv", index=False)

print("Fund:", data["meta"]["scheme_name"])
print("NAV records saved:", len(nav_data))
print(nav_data.head())