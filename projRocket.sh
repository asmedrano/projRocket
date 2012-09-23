#!/bin/bash

DIR="." # the directory that holds this project
PROJ_TYPE=""
PROJ_NAME="UNTITLED"

while getopts ":t:n:d:" opt; do
  case $opt in
    t)
      #echo "-t was triggered, Parameter: $OPTARG" >&2
      PROJ_TYPE=$OPTARG
      ;;
    n)
      #echo "-t was triggered, Parameter: $OPTARG" >&2
      PROJ_NAME=$OPTARG
      ;;
    d)
      DIR=$OPTARG
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      exit 1
      ;;
    :)
      echo "Option -$OPTARG requires an argument." >&2
      exit 1
      ;;
  esac
done


start_wp_project (){
	echo "Starting Wordpress project, codename: $PROJ_NAME"
	mkdir "$DIR/$PROJ_NAME"

}


#--------------------------- Options are parsed, do the buisness

# check if project type is specified
if [ $PROJ_TYPE == "" ];
	then
	echo "Project Type is required, use -t <project_name>...Exiting now..."
	exit
fi	


# always create the dir if it doesnt exist
if [ ! -d $DIR ];
	then
		mkdir $DIR
		
fi


if [ $PROJ_TYPE == 'wordpress' ];
	then
	start_wp_project
	
fi


