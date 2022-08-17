# WIP IN PROGRESS
import requests
import json

url = "http://CHANGEME:3000/api/v1/repos/migrate"

payload = json.dumps({
  "clone_addr": "https://github.com/redhat-cop/gitops-catalog",
  "repo_name": "gitops-catalog",
  "auth_password": "",
  "auth_username": "",
  "html_url": "http://CHANGEME:3000",
  "clone_url": "http://CHANGEME:3000/svc-gitea/gitops-catalog.git",
  "mirror": False,
  "private": False,
  "repo_owner": "svc-gitea",
  "service": "git",
  "uid": 0,
  "wiki": True
})
headers = {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
  'Authorization': 'Basic XXXXXXXXXXXXXXX',
  'Cookie': '_csrf=WI2Cm9b8mf_gmFUdhQrcHOdyJ1s6MTY2MDc1MDE0ODI1ODE4NDE4Mw; i_like_gitea=75b0bb3ecaa8e0a4'
}

response = requests.request("POST", url, headers=headers, data=payload)

print(response.text)
