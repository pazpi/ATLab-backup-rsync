#!/bin/bash

# Qui ci sono le variabili da modificare per il vostro utilizzo
CWD=$(/usr/bin/pwd)
EXCLUDE_FILTER=$CWD/exlude-path.txt
HN=$(/bin/hostname)
SSH_NAME=pi
LOCAL_FOLDER=$(/)
REMOTE_FOLDER=$(/media/1TORRHDD)
MAIL=pasettodavide@gmail.com
TESTO_MAIL=$CWD/mail.txt
DATE="date +'%B'"
# Fine! Da qui in poi è a vostro rischio 

echo "Copia in corso di $(LOCAL_FOLDER) dentro la cartella remota $(REMOTE/FOLDER)"
# Make remote folder
ssh $SSH_NAME "mkdir $REMOTE_FOLDER/backup-$HN-$DATE"

rsync -avx --timeout --exlude-from=$EXCLUDE_FILTER $(LOCAL_FOLDER) -e ssh $SSH_NAME:$REMOTE_FOLDER

ssh $SSH_NAME "du -sh $REMOTE_FOLDER | tail -n 1" > $TESTO_MAIL

# Invia una mail per informare il corretto backup
# https://www.youtube.com/watch?v=A_jehHsTzvE
# video di Morrolinux su come impostare un mail server che ci farà da supporto

mail -s "backup-completato" $MAIL $TESTO_MAIL

rm -f $TEST_MAIL
