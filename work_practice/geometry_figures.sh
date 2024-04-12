#!/bin/bash

# Author: Paul Flores
# Date Created: 26/03/2024
# Last Modified 26/03/2024

# Description
# This program is used for the area calculation of Square, Rectangle or Triangle

# Usage
# ./geometry_figures.sh <Triangle> <Base measure> <Height measure>
# ./geometry_figures.sh <Square> <Side meausere>
# ./geometry_figures.sh <Rectangle> <Length measure> <Width measure>

FIGURE=$1
FIRST_MEASURE=$2
SECOND_MEASURE=$3
LOG="calculates.log"
ERR="calculates.err"

main(){

    echo "Exec calculate area $(date)" > $LOG 

    if [ ${FIGURE,,} == "triangle" ] || [ ${FIGURE,,} == "square" ] || [ ${FIGURE,,} == "rectangle" ] ; then

        if [ ${FIGURE,,} == "triangle" ] && ! [ -z "$FIRST_MEASURE" ] && ! [ -z "$SECOND_MEASURE" ]; then
            TRIANGLE_AREA=$(( ($FIRST_MEASURE * $SECOND_MEASURE) / 2 ))

            echo "Great, a Triangle was selected by you with a $FIRST_MEASURE base and $SECOND_MEASURE height" >> $LOG
            echo "Your triangle area is $TRIANGLE_AREA" >> $LOG


        elif [ ${FIGURE,,} == "rectangle" ] && ! [ -z "$FIRST_MEASURE" ] && ! [ -z "$SECOND_MEASURE" ]; then
            RECTANGLE_AREA=$(( $FIRST_MEASURE * $SECOND_MEASURE ))

            echo "Great, a Rectangle was selected by you with a $FIRST_MEASURE length and $SECOND_MEASURE width" >> $LOG
            echo "Your rectangle area is $RECTANGLE_AREA" >> $LOG


        elif [ ${FIGURE,,} == "square" ] && ! [ -z "$FIRST_MEASURE" ]; then
            SQUARE_AREA=$(( $FIRST_MEASURE ** 2 ))

            echo "Great, a Square was selected by you with a $FIRST_MEASURE side" >> $LOG
            echo "Your square area is $SQUARE_AREA" >> $LOG

        else
            echo "You didn´t write a valid param" > $ERR
            exit 1
        fi
    else
        echo "You didn't write a valid figure" > $ERR
    fi
}

main $FIGURE $FIRST_MEASURE $SECOND_MEASURE
