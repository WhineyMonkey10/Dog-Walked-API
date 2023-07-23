import requests
import dotenv
import os

dotenv.load_dotenv()
serverip = os.getenv("SERVER-IP")

url = f"http://{serverip}:8000/"

if requests.get(f"{url}dogWalked").text == "true":
    pass
elif requests.get(f"{url}dogWalked").text == "false":
    url = "https://alertzy.app/send"
    data = {
        "accountKey": os.getenv("ALERTZY-KEY"),
        "title": "WALK THE DOG!",
        "message": "The dog needs to be walked!",
        "buttons": '[{"text":"Set to walked", "link":"{url}dogWalked/set","color":"success"}]'
    }

    response = requests.post(url, data=data)
    print(response.text)