import requests

if requests.get("https://dog.api.whmonkey.codes/dogWalked").text == "true":
    pass
elif requests.get("https://dog.api.whmonkey.codes/dogWalked").text == "false":
    url = "https://alertzy.app/send"
    data = {
        "accountKey": "accountKey",
        "title": "WALK THE DOG!",
        "message": "The dog needs to be walked!",
        "buttons": '[{"text":"Set to walked", "link":"https://dog.api.whmonkey.codes/dogWalked/set","color":"success"}]'
    }

    response = requests.post(url, data=data)
    print(response.text)