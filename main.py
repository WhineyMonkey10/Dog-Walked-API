from datetime import datetime, timedelta
import fastapi
from fastapi import FastAPI
from pymongo import MongoClient

app = FastAPI()

# Connect to MongoDB
client = MongoClient("123")
db = client["dog"]
collection = db["dogWalked"]

@app.get("/dogWalked")
def dogWalked():
    data = collection.find_one({}, sort=[("_id", -1)])  # Retrieve the latest document from the collection

    if data:
        stored_time = data["Time"]
        stored_time = datetime.strptime(stored_time, '%Y-%m-%dT%H:%M:%S.%f')
        current_time = datetime.now()

        if data["DogWalked"] and stored_time > current_time - timedelta(hours=3):
            return "Dog has been walked"
        else:
            return "Dog has not been walked"
    else:
        return "No dogWalked data found"

@app.get("/dogWalked/set")
def setDogWalked():
    json_data = {"DogWalked": True, "Time": datetime.now().isoformat()}
    collection.insert_one(json_data)
    return True

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000)
