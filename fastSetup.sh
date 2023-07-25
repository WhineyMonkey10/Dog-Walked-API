echo -e "\e[32mEnter your mongo uri: \e[0m"
read mongoUri

echo -e "\e[32mEnter your Alertzy key: \e[0m"
read alertzyKey

echo -e "\e[32mEnter your server ip: \e[0m"
read serverIp

echo "Creating Dockerfile..."

touch Dockerfile

echo "FROM python:3.9" >> Dockerfile
echo "" >> Dockerfile
echo "WORKDIR /app" >> Dockerfile
echo "" >> Dockerfile
echo "ENV MONGO-URI $mongoUri" >> Dockerfile
echo "ENV ALERTZY-KEY $alertzyKey" >> Dockerfile
echo "ENV SERVER-IP $serverIp" >> Dockerfile
echo "" >> Dockerfile
echo "COPY requirements.txt /app/" >> Dockerfile
echo "" >> Dockerfile
echo "RUN pip install --no-cache-dir -r requirements.txt" >> Dockerfile
echo "" >> Dockerfile
echo "COPY main.py /app/" >> Dockerfile
echo "" >> Dockerfile
echo "EXPOSE 8000" >> Dockerfile
echo "" >> Dockerfile
echo 'CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "8000"]' >> Dockerfile

echo -e "\e[32mDockerfile created.\e[0m"
echo "Checking for Docker..."

# Check the machine to see if docker is installed
if ! [ -x "$(command -v docker)" ]; then
  echo -e "\e[31mError: Docker is not installed.\e[0m"
  echo -e "\e[32mHow would you like to install Docker?\e[0m"
  echo "[1] Manually"
  echo "[2] Snap"
  echo "[3] sudo apt-get"
  echo "[4] Yum"
  echo "[5] Dnf"
  echo "[6] Pacman"
  echo "[7] Exit"
  read installType
  
  # Install docker based on the user's choice
  
  if [ $installType == "1" ]; then
    echo -e "\e[32mPlease install Docker manually.\e[0m"
    exit 1
  elif [ $installType == "2" ]; then
    sudo snap refresh
    sudo snap install docker
    echo -e "\e[32mDocker installed, please re-launch the script.\e[0m"
    exit 1
  elif [ $installType == "3" ]; then
    sudo apt-get install docker
    echo -e "\e[32mDocker installed, please re-launch the script.\e[0m"
    exit 1
  elif [ $installType == "4" ]; then
    sudo yum install docker
    echo -e "\e[32mDocker installed, please re-launch the script.\e[0m"
    exit 1
  elif [ $installType == "5" ]; then
    sudo dnf install docker
    echo -e "\e[32mDocker installed, please re-launch the script.\e[0m"
    exit 1
  elif [ $installType == "6" ]; then
    sudo pacman -S docker
    echo -e "\e[32mDocker installed, please re-launch the script.\e[0m"
    exit 1
  elif [ $installType == "7" ]; then
    exit 1
  else
    echo -e "\e[31mError: Invalid option.\e[0m"
    exit 1
  fi

else
    echo -e "\e[32mDocker is installed.\e[0m"
    fi

echo -e "\e[32mBuilding Docker image...\e[0m"

docker build -t dog_walk_api .

echo -e "\e[32mDocker image built.\e[0m"
echo -e "\e[32mRunning Docker image...\e[0m"

docker run -d -p 8000:8000 dog_walk_api

echo -e "\e[32mDocker image running as a background process.\e[0m"
echo -e "\e[32mThe API documentation is available at http://$serverIp:8000/docs\e[0m"

echo -e "\e[32mSetting up cron job...\e[0m"

# Set up cron job to run 0 18 * * 1-5 python3 Dog-Walked-API/reminder.py

# Check the machine to see if cron is installed

if ! [ -x "$(command -v cron)" ]; then
  echo -e "\e[31mError: Cron is not installed.\e[0m"
  echo -e "\e[32mHow would you like to install Cron?\e[0m"
  echo "[1] Manually"
  echo "[2] Snap"
  echo "[3] sudo apt-get"
  echo "[4] Yum"
  echo "[5] Dnf"
  echo "[6] Pacman"
  echo "[7] Exit"
  read installType
  
  # Install cron based on the user's choice
  
  if [ $installType == "1" ]; then
    echo -e "\e[32mPlease install Cron manually.\e[0m"
    exit 1
  elif [ $installType == "2" ]; then
    sudo snap refresh
    sudo snap install cron
  elif [ $installType == "3" ]; then
    sudo apt-get install cron
  elif [ $installType == "4" ]; then
    sudo yum install cron
  elif [ $installType == "5" ]; then
    sudo dnf install cron
  elif [ $installType == "6" ]; then
    sudo pacman -S cron
  elif [ $installType == "7" ]; then
    exit 1
  else
    echo -e "\e[31mError: Invalid option.\e[0m"
    exit 1
  fi

else
    echo -e "\e[32mCron is installed.\e[0m"
    fi

# Add the cron job to the crontab

(crontab -l 2>/dev/null; echo "0 18 * * 1-5 python3 Dog-Walked-API/reminder.py") | crontab -

echo -e "\e[32mCron job set up.\e[0m"
echo -e "\e[32mSetup complete.\e[0m"