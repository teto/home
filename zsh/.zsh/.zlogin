# /etc/zsh/zlogin ou ~/.zlogin
# Fichier de configuration de zsh, lu au lancement des shells de login
# Formation Debian GNU/Linux par Alexis de Lattre
# http://formation-debian.via.ecp.fr/

# Ce fichier contient les commandes qui s'exécutent quand l'utilisateur
# ouvre une console

# Affiche des informations sur le système
uname -a
uptime

# Accepte les messages d'autres utilisateurs
mesg y

# Pour les ordinateurs avec un pavé numérique...
# Active le pavé numérique quand on se loggue en console
#case "`tty`" in /dev/tty[1-6]*)
#    setleds +num
#esac
