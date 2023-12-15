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
        echo -e "$2 install $R fail ayndhi ra babu $N"
    else
        echo -e "$2 $G install baga ayndhi mama $N"
    fi
}

if [ $ID -ne 0 ]
then 
    echo -e "$R Orey babu you are not user gadivi.. poraaa babu $N" &>> $LOGFILE
    exit 1
else
    echo -e "$G Orey root user mama, Congrats ra $N" &>> $LOGFILE
fi

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE
VALIDATE $? "copied mongodb repo"
dnf install mongodb-org -y &>> $LOGFILE
VALIDATE $? "installed mondb"
systemctl enable mongod &>> $LOGFILE
VALIDATE $? "enabled mongodb"
systemctl start mongod &>> $LOGFILE
VALIDATE $? "started mongodb"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE
VALIDATE $? "updated remote server IP"
systemctl restart mongod &>> $LOGFILE
VALIDATE $? "restarted mongodb"