#!/bin/bash
source ./includes/basic.sh

SITENAME=$1
CSTEP=0;
echo "================================================================="
echo "| New Site Configuration                                        |"
echo "| With this script we'll drive you to a complete creation of a  |"
echo "| new site into this development enviroment. Please follow the  |"
echo "| steps in order to get it completed.                           |"
echo "================================================================="


CSTEP=$(nextStep $CSTEP)
echo "STEP: $CSTEP - Wich repo should i use?"
chooseRepo || exit 1

configureApache || exit 1


STEP=$(nextStep $CSTEP)
