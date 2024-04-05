#!/bin/bash
PS3="Select the day of the week: "
select day in mon tue wed thu fri sat sun;
do
echo "The day of the week is $day"
break # This will break the cycle
done
