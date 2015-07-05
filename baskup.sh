#!/bin/bash

#------------------------------------------------------------------------------------------
# Qui ci sono le variabili da modificare per il vostro utilizzo

# Variable per definire la cartella in cui viene eseguito lo script
CWD=$(/usr/bin/pwd)

# File dove si definisce i file/cartelle da escludere dal backup, per maggiori info guardare il file
EXCLUDE_FILTER=$CWD/exlude-path.txt

# Nome della macchina che si vuol fare il backup
HN=$(/bin/hostname)

# Nome della connessione SSH, da definire nel file ~.ssh/config
SSH_NAME=pi

# Cartella da dove iniziare il backup Es. / = root (tutto il computer)
LOCAL_FOLDER=$(/)

# Cartella remota, definire il percorso completo fino alla cartella dove si vuole tenere i backup (esclusa)
REMOTE_FOLDER=$(/media/1TORRHDD)

# Destinatario delle mail rissuntive di ogni backup
MAIL_DEST=pasettodavide@gmail.com

# File dove vengono salvate le informazioni che comporranno il corpo della mail
TESTO_MAIL=mail.txt

# Data corrente, es 2015.06
DATE="date +%Y.%m"

# Giorno corrente Es 05 (quinto giorno del mese)
CURR_DAY="date +%d"

#Se non si vogliono le mail di notifica si imposti 0
MAIL=1

# Per quanti GIORNI si vuole tenere il backup come cartella prima che venga compressa come archivio
MAX_FOLDER_OLD=60

# Per quanti GIORNI si vuole tenere l'archivio come cartella (il periodo viene calcolato dalla creazione della cartella, e quindi dall'eta del backup)
MAX_ARCHIVE_OLD=180

# Fine! Da qui in poi è a vostro rischio e pericolo
#------------------------------------------------------------------------------------------

BACKUP_FOLDER=backup_$HN_$DATE
COMPRESS_FOLDER=compressed-backup

#funzione per inviare una mail in caso di backup fallito
backupFailed() {
    ssh $SSH_NAME (
    echo "Backup fallito, controllare i permessi di scrittura della cartella remota o lo spazio rimanente sul disco" > $TESTO_MAIL
    df -h > $TESTO_MAIL
    mail -s "Backup Fallito" -r noreply@backup.me $MAIL_DEST < $TESTO_MAIL
    rm $TESTO_MAIL
    )
}

echo "Copia in corso di $(LOCAL_FOLDER) dentro la cartella remota $(REMOTE/FOLDER)"
# Make remote folder
if ( ! ssh $SSH_NAME [ -d $REMOTE_FOLDER ]); then
    echo -e "\e[1;31mError: Cartella remota non esite e/o non scrivibile\e[0m"        
    backupFailed
    exit 1
fi

# Entrare dentro ssh e creare le cartelle remote
ssh $SSH_NAME (
    
    # Se la cartella esiste e si puo scrivere allora entra
    if [[ -d $REMOTE_FOLDER && -w $REMOTE_FOLDER ]]; then
        cd $REMOTE_FOLDER
        
        # Se la cartella del backup non esiste, la crea 
        if [[ ! -d $BACKUP_FOLDER ]]; then
            mkdir $BACKUP_FOLDER

            if [[ $(ls -A $BACKUP_FOLDER) ]]; then
                mkdir $CURR_DAY
                LOW_DAY="ls $BACKUP_FOLDER | sort -V | head -n 1 | sed 's/\///'"
                cp -al $LOW_DAY $CURR_DAY
            fi

            HIGH_DAY="ls $BACKUP_FOLDER | sort -V | tail -n 1 | sed 's/\///'"
            # TOMORROW_DAY="date -d 'tomorrow' +%d"
        fi

        if [[ ! -d $COMPRESS_FOLDER ]]; then
            mkdir $COMPRESS_FOLDER
        fi
        cd $REMOTE_FOLDER
        find . archive_* -type f -mtime +$MAX_ARCHIVE_OLD -exec rm {} \;
        find . archive_* -type f -exec mv {} $COMPRESS_FOLDER \;

        
        # tar jcf archive_$HN_'date +%Y.%m.%d'.tar.bz2 backup*
    fi
)

rsync -avx --timeout=30 --exlude-from=$EXCLUDE_FILTER $(LOCAL_FOLDER) -e ssh $SSH_NAME:$REMOTE_FOLDER/$BACKUP_FOLDER/$CURR_DAY

ssh $SSH_NAME "cd $REMOTE_FOLDER && find archive_* -type f -mtime +$MAX_ARCHIVE_OLD -exec rm {} \; && tar"

# Invia una mail per informare il corretto backup
# https://www.youtube.com/watch?v=A_jehHsTzvE
# video di Morrolinux su come impostare un mail server che ci farà da supporto

if [[ $MAIL==1 ]]; then
    ssh $SSH_NAME (
        echo "Backup completato!" > $TESTO_MAIL
        echo -n Spazio totale occupato: && echo -n -e ' \t'
        du -sh $REMOTE_FOLDER/$BACKUP_FOLDER | tail -n 1 >> $TESTO_MAIL
        mail -s "backup-completato" $MAIL $TESTO_MAIL
        rm -f $TESTO_MAIL
        )
fi

