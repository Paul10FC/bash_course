#!/bin/bash
read -p "What is your first name? " first_name
read -p "What is your surname/family name? " surname
read -N 4 -p "What is your extension number " extension_number
echo ""
read -N 4 -s -p "What access code would you like to use when dialing in? " pin_code
echo ""

echo "NAME: $first_name" > extensions.csv
echo "SURNAME: $surname" >> extensions.csv
echo "EXTENSION: $extension_number" >> extensions.csv
echo "PIN: $pin_code" >> extensions.csv

PS3="Select your type of phone: "
select phone_type in headset handheld;
do
echo "phone type: $phone_type" >> extensions.csv
break
done

PS3="Choose your departament: "
select departament_type in finance sales customer\ service engineering
do
echo "Departament: $departament_type" >> extensions.csv
break
done

echo "---------------------------------" >> extensions.csv

