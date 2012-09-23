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

	if [ ! -d "$DIR/$PROJ_NAME" ];
		then
			mkdir "$DIR/$PROJ_NAME"
	fi

	# its really up to each project handler to take it from here.
	# So what do we need:
	
	# Wordpress installation lets get it from Github
	git clone git://github.com/WordPress/WordPress.git "$DIR/$PROJ_NAME/wordpress"
	
	# a bootstrapped Theme directory, we'll ln -s it in wordpress content. I like using HTML5 Boilerplate so lets use this thing
	git clone git://github.com/asmedrano/html5-boilerplate-for-wordpress.git "$DIR/$PROJ_NAME/$PROJ_NAME-theme"
	
	# get rid of all the .git files so this is really just a bunch of files. TODO: is there an actual way to do this?
	rm -rf "$DIR/$PROJ_NAME/$PROJ_NAME-theme/.git"

	# now we need to ln -s the theme into wordpress content, cause we dont want to check in the wordpress install into github.
	ln -s `readlink -e $DIR/$PROJ_NAME/$PROJ_NAME-theme` "$DIR/$PROJ_NAME/wordpress/wp-content/themes/$PROJ_NAME-theme"	
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


