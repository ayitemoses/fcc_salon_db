#!/bin/bash

echo -e "\n~~~~~ MY SALON ~~~~~\n"

echo -e "Welcome to My Salon, how can I help you?\n"


# Connecting to the database

PSQL="psql --username=freecodecamp --dbname=salon --no-align --tuples-only -c"


# List of services
#echo -e "\nList of services"
# echo "$($PSQL "select * from services")"

DISPLAY_SERVICES() {
  echo -e "Please choose a service: "
  echo "$($PSQL "select * from services" | sed 's/|/) /')"
}

while true
do
  DISPLAY_SERVICES
  read SERVICE_ID_SELECTED
  SERVICE_CHECK=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
  if [[ -n $SERVICE_CHECK ]]; then
    echo "You selected service ID $SERVICE_ID_SELECTED."
    break
  else
    echo "Invalid selection, please try again."
  fi
done

echo -e "Please enter a phone number (ex.:555-555-5555): "
read CUSTOMER_PHONE
PHONE_CHECK=$($PSQL "SELECT phone FROM customers where phone='$CUSTOMER_PHONE'")
if [[ -z $PHONE_CHECK ]]; then
    echo -e "Please enter a name: "
    read CUSTOMER_NAME
    INSERT_CUSTOMER=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME'); ")
fi

echo -e "Please enter a time: "
read SERVICE_TIME

CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(time, service_id, customer_id) VALUES('$SERVICE_TIME', $SERVICE_ID_SELECTED,$CUSTOMER_ID); ")

SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")

echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."


# making a comment to test git
