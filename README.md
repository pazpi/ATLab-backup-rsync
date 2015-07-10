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

Apri il terminale e clona questo repository nella cartella nascosta _.backup_.
Ovviamente è a vostra discrezione il nome della cartella e la sua posizione, ma vi consiglio di metterla in un posto logico e che possiate ricordarvi.

`$ git clone https://github.com/pazpi/ATLab-backup-rsync.git .backup`

Dopo di chè rendere eseguibie lo script _backup.sh_

`sudo chmod +x backup.sh`

e aprirlo per impostare le variabili, tipo la cartella remota.

Per usare questo script è necessario conoscere SSH e inserire la macchina remota nel file ~/.ssh/config
Si consiglia di impostare il login nella macchina attraverso le chiavi e si rimanda a [questa guida] (https://wiki.archlinux.org/index.php/SSH_keys) per maggiori info

Aprite con il vostro editor preferito il file `~/.ssh/config` e copiate queste righe

```
Host pi
    Hostname {INDIRIZZO HOST}
    User     {NOME UTENTE}
    PubKeyAuthentication yes
    IdentitiesOnly yes
    IdentityFile {PERCORSO DELLA CHIAVE PUBBLICA ~/.ssh/id_rsa.pub}
```

Sara necessario aggiungere la chiave privata alla lista delle chiavi conosciute, cosi che venga caricata all'avvio del computer e che lo script di backup
venga lanciato in automatico senza preoccupazioni aggiuntive da parte dell'utente.
Per aggiungere la chiave dovreste lanciare ad ogni avvio il comando _ssh-add_, e vi consiglio di aggiungerlo al file _.xinitrc_ in modo tale che ad ogni avvio
del pc venga caricata la chiave.
La sintassi di _ssh-add_ è molto semplice e per caricare una chiave basterà lanciare il comando _ssh-add_ seguito dal percorso della chiave.
Purtroppo il solo comando _ssh-add_ non basta, dato che bisogna pure far partire il demone che si occupa di tenere al sicuro le chiavi, quindi insieme al comando
_ssh-add_ dovremo lanciare pure il comando _ssh-agent_
Quindi in definitiva le due linee da aggiungere al file _.xinitrc_ sono:
```
eval "$(ssh-agent -s)"
ssh-add "$HOME/.ssh/id_rsa"
```
Ovviamente sostituite il la mia chiave con la vostra!

Ora che abbiamo sistemato il fattore ssh è arrivato il momento di usare cron, che ci consente di lanciare il backup ad intervalli regolari e nei momenti che
decidiamo noi.

Quindi lanciate dal terminale (se non avete cron dovreste installarlo)

`crontab -e`

Qui non si approfondiranno i fondamenti di cron, dato che ci impiegherei troppo e non è lo scopo di questa guida, ma vi lascio il link ad un video che ho trovato
molto istruttivo [Cron by Morrolinux](https://www.youtube.com/watch?v=k8totuSsP_s)
Dopo che vi si è aperto il vostro editor è il momento di inserire il comando per il backup.
Comuqnue la struttura di cron è la seguente 
```
*     *     *     *     *  command to be executed
-     -     -     -     -
|     |     |     |     |
|     |     |     |     +----- day of week (0 - 6) (Sunday=0)
|     |     |     +------- month (1 - 12)
|     |     +--------- day of month (1 - 31)
|     +----------- hour (0 - 23)
+------------- min (0 - 59)

```
Come potete vedere abbiamo ampia libertà su quando eseguire il backup.
Ad esempio se volete eseguire il backup ogni giorno dell'anno alle 12:00 dovreste inserire nel file

`0 12 * * *     cd $HOME/.backup && ./backup.sh`

Oppure se volete eseguire il backup solo la domenica alle 21:00 la vostra riga sara

`0 21 * * 0     cd $HOME/.backup && ./backup.sh`

Semplice :)

Ora dovremo solo aspettare che il backup venga eseguito e poi possiamo tirare un sospiro di sollievo, ora che i nostri dati sono al sicuro.

Un piccolo consiglio, lanciate prima il comando manualmente e verficiate che venga eseguito correttamente, questo programma è realizzato da un'autodidatta che ha
ancora tante cose da imparare e che non si prende nessuna responsabilità per la perdità dei vostri dati
### MAC OSX



## FAQ


## Implementazioni future
