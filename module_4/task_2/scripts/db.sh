#!/usr/bin/env bash

file=../data/users.db
date=$(date +"%d_%m_%Y")
backup=../data/$date-users.db.backup


check_file() {

	if [ ! -f $file ]; 
	then
		read -p "Do you want to create users.db file? (y/n) " answer
		
		case $answer in 
			[yY]) touch $file;;
			[nN]) exit;;
			* ) exit;;
		esac
	fi
}

backup() {
	cp $file $backup
}

restore() {
	local filename=$(ls -1t ../data | grep -Ev "^users.db$")
	cp ../data/$filename $file
}

help() {
	echo "Adds new user"
}

add() {
	echo "Type username"
read username

echo "Type role"
read role

echo "_${username}_, _${role}_" >> $file
}

for i in "$@"
do
	case $i in
		help)
			help;;
		add) 
			check_file;
			add;;
		backup)
			check_file;
			backup;;
		restore) 
			check_file;
			restore;;
		find) check_file;;
		list) check_file;;
		sort) check_file; restore;;
		*) exit;;
	esac
done

echo "done"
