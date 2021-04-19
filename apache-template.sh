#!bin/bash
# Sætter en LAMP server op fra bunden af på et Ubuntu OS.
# Kræver sudo rettiheder

echo "installere en LAMP server"
echo "apache2"
echo "mariadb"
echo "php"
echo "phpmyadmin"
echo "certbot"
echo "sshfs"
echo "konfigurere firewall"
echo "installere composer"

if [[ $UID != 0 ]]; then
    echo "Please run this script with sudo:"
    echo "sudo $0 $*"
    exit 1
fi

apt update -y && \
apt upgrade -y  && \
apt install sshfs -y && \
apt install apache2 -y && \
apt install mariadb-server -y && \
apt install php libapache2-mod-php php-mysql -y && \
apt install certbot python3-certbot-apache -y && \
apt install composer -y && \
tput setaf 3 && echo "Tryk enter for at installare phpmyadmin. Åben vejledningen inden du går igang:" && \
echo "https://www.digitalocean.com/community/tutorials/how-to-install-and-secure-phpmyadmin-on-ubuntu-20-04" && \
tput sgr0 && \
read && \
apt install phpmyadmin php-mbstring php-zip php-gd php-json php-curl -y


# Replace 
# <Directory /var/www/>
#        Options Indexes FollowSymLinks
#        AllowOverride None
#        Require all granted
# </Directory>
# >>
# <Directory /var/www/>
#        Options Indexes FollowSymLinks
#        AllowOverride All
#        Require all granted
# </Directory>


# ufw regler
# disable ipv6 https://linuxhint.com/replace_string_in_file_bash/
# Gør så ipv6 bliver slået fra.
filename="/etc/default/ufw"
search="IPV6=yes"
replace="IPV6=no"
if [[ $search != "" && $replace != "" ]]; then
sed -i "s/$search/$replace/" $filename
fi
# lukker alle porte
ufw default deny    && \
ufw allow 22/tcp    && \
ufw allow 80/tcp    && \
ufw allow 443/tcp   && \
tput setaf 3 && echo "Sig ja til at enable firewall 'ufw enable' 'ufw status verbose'"
tput sgr0
ufw enable
echo "Firewall regler:"
ufw status verbose
echo "" 

# Gør så at det kun er private IP'er som kan tilgå phpmyadmin
tput setaf 1 && \
echo "Sørg for at det kun er private ip'er eller en specifik offentlig ip som kan tilgå phpmyadmin."
echo "du kan tilføje ip'er under 'nano /etc/phpmyadmin/apache.conf'"
echo "Sådan her skal det ser ud: det f.eks. ser sådan her ud:"
tput sgr0
echo ""
echo ""
echo "
# phpMyAdmin default Apache configuration

Alias /phpmyadmin /usr/share/phpmyadmin

<Directory /usr/share/phpmyadmin>
"
tput setaf 3
echo "
    Require ip 10.0.0.0/8
    Require ip 172.16.0.0/12
    Require ip 192.168.0.0/24
"
tput sgr0
echo "
    Options SymLinksIfOwnerMatch
    DirectoryIndex index.php

    # limit libapache2-mod-php to files and directories necessary by pma
    <IfModule mod_php7.c>
        php_admin_value upload_tmp_dir /var/lib/phpmyadmin/tmp
        php_admin_value open_basedir /usr/share/phpmyadmin/:/etc/phpmyadmin/:/var/lib/phpmyadmin/:/usr/share/php/php-gettext/:/usr/share/php/php-php-gettext/:/usr/share/javascript/:/usr/share/php/tcpdf/>
    </IfModule>

</Directory>

# Disallow web access to directories that don't need it
<Directory /usr/share/phpmyadmin/templates>
    Require all denied
</Directory>
<Directory /usr/share/phpmyadmin/libraries>
    Require all denied
</Directory>
"





#Ændre hostnavnet
# echo "Hvad skal serveren hedde?"
# read myhostname
# echo $myhostname > /etc/hostname
# Sørg for at installere virtuelle hosts - kør a2ensite

# Tilføj en relevant database

# 

# Opstil
