# WIP
import requests
import json

url = "http://CHANGEME:3000/api/v1/user/repos"

payload = json.dumps({
  "name": "test"
})
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Basic XXXXXXXXXXXXXXX',
  'Cookie': '_csrf=vz_u9zLTZYv87glBekFB62zgsd86MTY2MDc1Mzg0MDEwNDU0MTkxMw; i_like_gitea=75b0bb3ecaa8e0a4'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)
