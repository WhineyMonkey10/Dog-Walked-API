# Make an API that when the dogWalked it will set a value on the server called "DogWalked" to true, after 5 hours it will set it to false

import datetime
from datetime import datetime, timedelta

import time
import fastapi
import json
import uvicorn

app = fastapi.FastAPI()

@app.get("/dogWalked")
def dogWalked():
    with open("dogWalked.json", "r") as f:
        data = json.load(f)

    stored_time = datetime.strptime(data["Time"], '%Y-%m-%dT%H:%M:%S.%f')
    current_time = datetime.now()

    if data["DogWalked"] and stored_time > current_time - timedelta(hours=3):
        return "Dog has been walked"
    else:
        return "Dog has not been walked"
    
@app.get("/dogWalked/set")
def setDogWalked():
    json_data = {"DogWalked": True, "Time": (datetime.now().isoformat())}
    json_string = json.dumps(json_data)
    
    # Write to file called dogWalked.json
    with open("dogWalked.json", "w") as json_file:
        json_file.write(json_string)
    
    return True
    