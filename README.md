# ATLab-backup-rsync
Soluzione per backup usando rsync

## Cos'è
Questo script serve per creare dei backup dei propri file in una cartella remota tramite SSH

## Come funziona
Lo script usa rsync come metodo per copiare i file nella cartella remota, viene usato rsync perchè per la copia dei file usa la codifica delta, ovvero trasferisce
solo i byte che sono cambiati dall'ultimo backup.
Questo ci consente di ottenere un tempo esiguo per il trasfermimento dei dati che avvenendo sopra SSH vengono pure criptati.
Per risparmiare spazio e tenere una cronologia dei file precedenti, prima di ogni nuovo backup viene prima creato un _hardlink_ di quello precedente e poi rsync
riscrive solo la parte di file che è cambiata.

## Installazione

### Linux 

Apri il terminale e clona questo repository

`$ git clone https://github.com/pazpi/ATLab-backup-rsync.git`

## FAQ

## Implementazioni future
