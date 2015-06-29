#!/bin/bash

CWD=$(/usr/bin/pwd)
EXCLUDE_FILTER=$CWD/exlude-path.txt
HN=$(/bin/hostname)
SSH_USER=pi
LOCAL_FOLDER=$(/)
REMOTE_FOLDER=$(/media/1TORRHDD)
MAIL=pasettodavide@gmail.com
TESTO_MAIL=$CWD/mail.txt


echo "Copia in corso di $(LOCAL_FOLDER) dentro la cartella remota $(REMOTE/FOLDER)"

rsync -avx --timeout --exlude-from=$EXCLUDE_FILTER $(LOCAL_FOLDER) -e ssh pi:$REMOTE_FOLDER

# Invia una mail per informare il corretto backup
# https://www.youtube.com/watch?v=A_jehHsTzvE
# video di Morrolinux su come impostare un mail server che ci farà da supporto

mail -s "backup-completato" $MAIL $TESTO_MAIL
