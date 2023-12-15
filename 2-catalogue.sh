#!/bin/bash
DATE=$(date +%F-%H-%M-%S)
R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"
LOGFILE="/tmp/$0-$DATE.log"
ID=$(id -u)

echo "Mama, mana script start ayndhi at $DATE" &>> $LOGFILE

VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$2 $R fail ayndhi ra babu $N"
    else
        echo -e "$2 $G  baga ayndhi mama $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R Orey babu you are not user gadivi.. poraaa babu $N" &>> $LOGFILE
    exit 1
else
    echo -e "$G Orey root user mama, Congrats ra $N" &>> $LOGFILE
fi


dnf module disable nodejs -y &>> $LOGFILE
VALIDATE $? "diable nodejs lower version"
dnf module enable nodejs:18 -y &>> $LOGFILE
VALIDATE $? "enable nodejs 18 version"
dnf install nodejs -y &>> $LOGFILE
VALIDATE $? "nodejs install"
useradd roboshop &>> $LOGFILE
VALIDATE $? "roboshop useradd"
mkdir /app &>> $LOGFILE
VALIDATE $? "/app directory creation"
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>> $LOGFILE
VALIDATE $? "downloading application code"
cd /app &>> $LOGFILE
unzip /tmp/catalogue.zip &>> $LOGFILE
npm install &>> $LOGFILE
cp /home/centos/roboshop-shellscript/catalogue.service /etc/systemd/system/catalogue.service &>> $LOGFILE
systemctl daemon-reload &>> $LOGFILE
systemctl enable catalogue &>> $LOGFILE
systemctl start catalogue &>> $LOGFILE
cp /home/centos/roboshop-shellscript/mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
dnf install mongodb-org-shell -y &>> $LOGFILE
mongo --host mongodb.kiranku.online </app/schema/catalogue.js &>> $LOGFILE
