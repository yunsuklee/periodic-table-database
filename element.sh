#!/bin/bash

# to query the database
PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

# if an argument is passed
if [[ $1 ]] 
then
  # get element
  # if argument is a number
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE atomic_number=$1")
  else
    ELEMENT_RESULT=$($PSQL "SELECT * FROM elements WHERE symbol='$1' OR name='$1'")
  fi
  
  # if element was not found
  if [[ -z $ELEMENT_RESULT ]]
  then
   echo "I could not find that element in the database."
  else
    echo "$ELEMENT_RESULT" | while read ATOMIC_NUMBER BAR SYMBOL BAR NAME
    do
      # get its properties
      PROPERTIES=$($PSQL "SELECT type, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties FULL JOIN types USING(type_id) WHERE atomic_number=$ATOMIC_NUMBER")

      # print output  
      echo "$PROPERTIES" | while read TYPE BAR ATOMIC_MASS BAR MELTING BAR BOILING
      do
        echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING celsius and a boiling point of $BOILING celsius."
      done
    done
  fi 
# if there is no argument
else
  echo "Please provide an element as an argument."
fi
