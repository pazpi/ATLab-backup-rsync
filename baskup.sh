#!/bin/bash

CWD=$(/usr/bin/pwd)
EXCLUDE_FILTER=$CWD/exlude-path.txt
HN=$(/bin/hostname)
SSH_USER=pi
LOCAL_FOLDER=$(/)
REMOTE_FOLDER=$(/media/1TORRHDD)

echo "Copia in corso di $(LOCAL_FOLDER) dentro la cartella remota $(REMOTE/FOLDER)"

rsync -avx --timeout --exlude-from=$EXCLUDE_FILTER $(LOCAL_FOLDER) -e ssh pi:$REMOTE_FOLDER

