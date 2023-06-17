#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"

#echo $($PSQL "TRUNCATE customers, appointments RESTART IDENTITY")

echo -e "\n~~~ Hairdresser & Barber Salon ~~~\n"

MAIN_MENU() {
  if [[ $1 ]]
  then
    echo -e "\n$1"
  fi

  echo -e "How may I help you?"
  echo -e "
  $($PSQL "SELECT service_id FROM services WHERE name='cut'")) $($PSQL "SELECT name FROM services WHERE service_id=1")
  $($PSQL "SELECT service_id FROM services WHERE name='trim'")) $($PSQL "SELECT name FROM services WHERE service_id=2")
  $($PSQL "SELECT service_id FROM services WHERE name='color'")) $($PSQL "SELECT name FROM services WHERE service_id=3")
  "
  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1 | 2 | 3) ASK_NUMBER ;;
    *) MAIN_MENU "Please enter a valid option." ;;
  esac

}

ASK_NUMBER () { 
  echo "What's your phone number?"
  read CUSTOMER_PHONE

  CUSTOMER_PHONE_CHECK=$($PSQL "SELECT phone FROM customers WHERE phone='$CUSTOMER_PHONE'")
  if [[ -z $CUSTOMER_PHONE_CHECK ]]
  then
    # get customer name
    echo "No number in database. What's your name?"
    read CUSTOMER_NAME
    # set appointment time
    echo "What time?"
    read SERVICE_TIME
    # insert customer info
    INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(phone, name) VALUES('$CUSTOMER_PHONE', '$CUSTOMER_NAME')")

    # insert appointment info
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")
    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    # appointment summary
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."
  else
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE name='$CUSTOMER_NAME'")

    echo "What time?"
    read SERVICE_TIME

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES($CUSTOMER_ID, $SERVICE_ID_SELECTED, '$SERVICE_TIME')")
    SERVICE_NAME=$($PSQL "SELECT name FROM services WHERE service_id=$SERVICE_ID_SELECTED")
    echo "I have put you down for a $SERVICE_NAME at $SERVICE_TIME, $CUSTOMER_NAME."  
  fi
}

TRIM() { 
  echo "trim" 
}

DYE() { 
  echo "dye" 
}

MAIN_MENU