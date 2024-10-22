#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

MAIN_MENU() {
	if [[ -z $1 ]]
	then
		echo "Please provide an element as an argument."
    exit
	else
		GET_ELEMENT $1
	fi
}

GET_ELEMENT() {
	INPUT=$1
  #If input is string
	if [[ ! $INPUT =~ ^[0-9]+$ ]]
	then
		ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE name = '$1' or symbol = '$1';")
	#If input is atomic number
  else
		ELEMENT=$($PSQL "SELECT atomic_number, name, symbol, type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM elements JOIN properties USING(atomic_number) JOIN types USING(type_id) WHERE atomic_number = $1;")
	fi
  
	if [[ -z $ELEMENT ]]
	then
		echo "I could not find that element in the database."
    exit
	else
    echo $ELEMENT | while IFS=" |" read NUMBER NAME SYMBOL TYPE MASS MP BP
    do
      echo "The element with atomic number $NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MP celsius and a boiling point of $BP celsius."
    done
	fi
}

MAIN_MENU $1
