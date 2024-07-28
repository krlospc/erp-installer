#!/bin/bash


function print_info {
        echo -n -e '\e[1;36m'
        echo -n $1
        echo -e '\e[0m'
}

function print_warn {
        echo -n -e '\e[1;33m'
        echo -n $1
        echo -e '\e[0m'
}

update_repository(){
  print_info "updating the server..."
  apt update -y >> log_update.log
}


install_php(){
	
	if [ -z "`which php 2>/dev/null`" ]
		print_info "installing php..."
		apt install -y php7.3-cli php7.3-json php7.3-common  php7.3-zip php7.3-gd php7.3-mbstring php7.3-curl php7.3-xml php7.3-bcmath php7.3-pgsql
		php -v
	then
		print_warn "PHP ALREADY INSTALLED ..."
	fi
}

install_apache2(){

	if [ -z "`which apache2 2>/dev/null`" ]
		print_info "INSTALLING APACHE..."
		apt install -y apache2 apache2-utils
		a2enmod ssl
		systemctl restart apache2
		#systemctl status apache2
	then
		print_warn "APACHE ALREADY INSTALLED"
	fi
}

install_git(){
	print_info "INSTALL GIT ..."
	
	if [ -z "`which git 2>/dev/null`" ]
		apt install -y git
		git --version
	then
		print_warn "GIT ALREADY INSTALLED..."
	fi

}

install_postgres(){
     print_info "INSTALLING THE POSTGRES SERVICE..."
	

	if [ -z "`which "postgresql" 2>/dev/null`" ]
        then
		print_info "POSTGRESQL INSTALLED..."
	     	apt update && sudo apt -y install vim bash-completion wget
     		apt -y upgrade
     		curl -fsSL https://www.postgresql.org/media/keys/ACCC4CF8.asc| gpg --dearmor -o /etc/apt/trusted.gpg.d/postgresql.gpg
	     	echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" | tee  /etc/apt/sources.list.d/pgdg.list
	     	apt -y update
		apt install postgresql-12 postgresql-client-12
		pg_ctlcluster 12 main start
		systemctl status postgresql.service

		#psql -c "ALTER USER postgres WITH ENCRYPTED PASSWORD 'postgres'"
		#psql -c "create database dbkerp with encoding='UTF-8'", user='postgres'
		#psql -c "create user dbkerp_conexion with password 'dbkerp_conexion';", user='postgres'
		#psql -c "alter role dbkerp_conexion SUPERUSER;", user='postgres'
		#psql -c "create user dbkerp_admin with password 'a1a69c4e834c5aa6cce8c6eceee84295';", user='postgres'
		#psql -c "alter role dbkerp_admin SUPERUSER;", user='postgres'

	else
		print_warm "POSTGRESQL ALREADY INSTALLED..."
	fi
	
	



}

install_postgresql(){
	apt update
	apt -y install gnupg2
	wget -c --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
	echo "deb http://apt.postgresql.org/pub/repos/apt/ `lsb_release -cs`-pgdg main" |sudo tee  /etc/apt/sources.list.d/pgdg.list
	apt update
	apt -y install postgresql-12 postgresql-client-12
	apt clean && sudo apt autoclean
	systemctl status postgresql.service
	su - postgres
	psql
	sleep 2
	alter user postgres with password 'postgres';
   	create database dbkerpbck with encoding='UTF-8';
        create user dbkerp_conexion with password 'dbkerp_conexion';
        alter role dbkerp_conexion SUPERUSER;
        create user dbkerp_admin with password 'a1a69c4e834c5aa6cce8c6eceee84295';
        alter role dbkerp_admin SUPERUSER;


}

#update_repository
#install_php
#install_apache2
#install_git
#install_postgres
install_postgresql
