import requests
from bs4 import BeautifulSoup
import pandas as pd
import math

url="https://phillm.net/libgen-seeds-needed.php"
r = requests.get(url).content
soup = BeautifulSoup(r, 'lxml')

results = soup.find('table')
table_head = [th.text for th in results.find_all('th')]

df = []
for row in results.find_all('tr'):
    data = [td.text for td in row.find_all('td')]
    df.append(data)

df = pd.DataFrame(df,columns=table_head)
df = df.drop(columns="Info Hash")
df_filter = ["Name","Seeders","Leechers","Scraped","DHT Peers","DHT Scraped"]
df[df_filter] = df[df_filter].astype('int')

def convert_size(size: str) -> float:
    s = size.split(" ")
    if s[1] == "MB":
        size = float(s[0]) / (1024)
    elif s[1] == "GB":
        size = float(s[0])
    else:
        print("WRONG SIZE")
    return size
df["Size GB"] = df["Size"].apply(convert_size)
print(df)
print(df.dtypes)
df.to_hdf("scihub_tor.hdf","df")