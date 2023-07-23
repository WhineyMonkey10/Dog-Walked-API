
# Dog Walked API

This is an API that should be self-hosted to see if someone in your family has walked your dog, and sends a push notification if the dog hasn't been walked past a certain time. It integrates with the Alertzy app.

## Features

- Integrates with your own Alertyz account
- Easily deployable on a Synology Nas
- 100% Open Source
- Extremely light weight
- Free


## Installation

Install Dog Walked API using Git & Python. This setup guide has been written using an Ubuntu 22.04 server from Digital Ocean. To setup the later part of the guide, using a Synology Nas is recommended however the instructions will on how to set it up using and Ubuntu 22.04 server, but it will explain how to do it with a Synology.

```bash
  git clone https://github.com/WhineyMonkey10/Dog-Walked-API
  cd Dog-Walked-API/
```

Now, create a Dockerfile to setup and run the API part of the app.

```bash
  nano Dockerfile
```

Now, paste in this into the Dockerfile, remember to modify the environment variables:

```
FROM python:3.9

WORKDIR /app

ENV MONGO-URI <mongoURI>
ENV ALERTZY-KEY <alertzyaccountkey>
ENV SERVER-IP <your server ip>

COPY requirements.txt /app/

RUN pip install --no-cache-dir -r requirements.txt

COPY main.py /app/

EXPOSE 8000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]
```

When setting up your MongoDB database for the environment variable, ensure that the database is called 'dog' and the collection is called 'dogWalked'.

Now run these following commands to finsih the setup of the API

```bash
  docker build -t dog_walk_api .
  docker run -p 8000:8000 dog_walk_api
```

If you'd like to check out your API, go to: ```http://serverIP:8000/docs```

Now, to setup the reminder, you can either use a Synology Nas or do it through the server using Cron Jobs. Even though using a Synology Nas is recommended, this guide will only show the other way for simplicity.

#### Without a Synology Nas

To do it without a Synology Nas, follow these steps:

```bash
  crontab -e
```
I'd recommend selecting '1'. Then, go all the way to the bottom of the file and add the following line:

```0 18 * * 1-5 python3 Dog-Walked-API/reminder.py```

That will run the check to see if the dog was walked every day Monday through Friday at 6pm. However, you can modify the cron timing if you'd like. '18' is the hour of the day, and 1-5 are the days of the week. You can validate your cron time [here](https://crontab.cronhub.io/) buy simply pasting in your new time in the area that says '*/5 * * * *'.

#### With a Synology Nas

To do it with a Synology Nas, just use the control panel and setup a recurring task for 6pm every day Monday - Friday (if that's what you want of course). A more detailed guide on this will come later.

Now, save the file and if you set everything up correctly, you should be good to go! If the notification doesn't send at the time you set even though it should, verify the time on your server and adjust the cron time according to that. If that still doesn't work, ensure that you set everything up as the root user OR modify the cron job line to run the reminder.py file from the users's files.

## Further Steps

If you'd like to use this program as I do, I'd recommend purchasing some NFC stickers online and writing the link to your API to set the dog walked status to it, so that while leaving your house to walk the dog, you can just scan it and set the dog walked status to true.
## API Reference

#### Check the dog's walked status

```http
  GET /dogWalked
```

It can either return 'true' or 'false'


#### Set the dog's walked status

```http
  POST /dogWalked/set
```

Sets the dog walked status to 'true' and returns 'Successfully set the dog walked status to True!'

## Contributing

Contributions are always welcome!

If you'd like to contribute, please fork the repo and make all the changes you think would go well.

Happy programming!

## Authors

- [@WhineyMonkey10](https://www.github.com/whineymonkey10)

- My dog, he wrote all the code hehe
## License

[MIT](https://choosealicense.com/licenses/mit/)

