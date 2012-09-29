#!/bin/bash

SCRIPTPATH=`perl -e 'use Cwd "abs_path";print abs_path(shift)'`
DIR="." # the directory that holds this project
PROJ_TYPE=""
PROJ_NAME="UNTITLED"


if [ "$1" == "--help" ];
then
	clear

	echo
	echo "projRocket: A command line project bootstrapper."
	echo 
	echo "Usage: ./projRocket -t <project_type> See: Project Types -n <project_name> Default: UNTITLED -d <project_directory>Default: CWD"
	echo 
	echo -e "Supported Project Types\n"
	
	#--------STATICPLAIN-------------------------------
	echo -e " ----------\n Static\n ----------"
	echo " Use: -t static"
	echo " What happens:"
	echo -e " Creates index.html with some basic markup."
	
	echo 
	
	#--------STATIC SITE-------------------------------
	echo -e " ----------\n Static Site\n ----------"
	echo " Use: -t staticsite"
	echo " What happens:"
	echo -e " Creates a static site based on html5Boilerplate"
	
	echo

	#--------Python Module-------------------------------
	echo -e " ----------\n Python Module\n ----------"
	echo " Use: -t pymodule"
	echo " What happens:"
	echo -e " Creates a skeleton python module that adheres to \n http://guide.python-distribute.org/creation.html"
	
	echo 

	#--------WORDPRESS-------------------------------
	echo -e " ----------\n Wordpress\n ----------"
	echo " Use: -t wordpress"
	echo " What happens:"
	echo -e " Creates a new theme folder based on the html5boilerplate theme \n and grabs Wordpress from github. Your theme is ln -s'd into the wordpress theme directory \n You will also be asked if you want to configure your DB which will set up wp-config.php."
	


	echo
	exit 1
fi



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


start_static (){
	echo "Starting Static Html project, codename: $PROJ_NAME"
	
	if [ ! -d "$DIR/$PROJ_NAME" ];
		then
			mkdir "$DIR/$PROJ_NAME"
	fi
	
	# we are just gonna a file from the templates directory
	cp $SCRIPTPATH/templates/html/index.html $DIR/$PROJ_NAME/.

}


start_static_site (){
	echo "Starting Static Site project, codename: $PROJ_NAME"

	if [ ! -d "$DIR/$PROJ_NAME" ];
		then
			mkdir "$DIR/$PROJ_NAME"
	fi

	git clone git://github.com/h5bp/html5-boilerplate.git $DIR/$PROJ_NAME
	# ungit html5bp
	rm -rf "$DIR/$PROJ_NAME/.git"

	# get rid of some files from html5 boilerplate
	rm "$DIR/$PROJ_NAME/CHANGELOG.md"
	rm "$DIR/$PROJ_NAME/CONTRIBUTING.md"
	rm -rf "$DIR/$PROJ_NAME/doc"
}


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
	ln -s "$DIR/$PROJ_NAME/$PROJ_NAME-theme" "$DIR/$PROJ_NAME/wordpress/wp-content/themes/$PROJ_NAME-theme"
	
	echo "Do you want to configure a database? I'm assuming one already exists in mysql...(y/n)"
	read DB_Y_N
	
	if [ $DB_Y_N == "y" ];
	then
		echo "Enter DB Name:"
		read DB_NAME

		echo "Enter DB User:"
		read DB_USER

		echo "Enter DB Password"
		read DB_PASS

		echo "You entered Db name: $DB_NAME, Db user: $DB_USER, Pass: $DB_PASS"

		# we are gonna use SED to edit config.sample that exists in wordpress/wp-config-sample.php
		cp $DIR/$PROJ_NAME/wordpress/wp-config-sample.php $DIR/$PROJ_NAME/wordpress/wp-config.php
		sed -i -e 's/username_here/'${DB_USER}'/g' $DIR/$PROJ_NAME/wordpress/wp-config.php
		sed -i -e 's/database_name_here/'${DB_NAME}'/g' $DIR/$PROJ_NAME/wordpress/wp-config.php
		sed -i -e 's/password_here/'${DB_PASS}'/g' $DIR/$PROJ_NAME/wordpress/wp-config.php
	fi


	echo "ALL DONE!"

}

start_pymodule (){
	echo "Starting Python Module, codename: $PROJ_NAME"
	
	if [ ! -d "$DIR/$PROJ_NAME" ];
		then
			mkdir "$DIR/$PROJ_NAME"
	fi
	
	cp -r $SCRIPTPATH/templates/python/pymodule/* $DIR/$PROJ_NAME/.

	MODULE_NAME=` echo $PROJ_NAME | awk '{print tolower($0)}'`
	
	# rename module template
	mv $DIR/$PROJ_NAME/your_module $DIR/$PROJ_NAME/$MODULE_NAME


}


#--------------------------- Options are parsed, do the buisness

# check if project type is specified
if [ "$PROJ_TYPE" == '' ];
	then
	echo "Project Type is required, use -t <project_name>...Exiting"
	exit
fi	


# always create the dir if it doesnt exist
if [ ! -d $DIR ];
	then
		mkdir $DIR
		
fi


if [ "$PROJ_TYPE" == "wordpress" ];
	then
	start_wp_project
	
fi

if [ "$PROJ_TYPE" == "static" ];
	then
	start_static
	
fi

if [ "$PROJ_TYPE" == "staticsite" ];
	then
	start_static_site
	
fi

if [ "$PROJ_TYPE" == "pymodule" ];
	then
	start_pymodule
	
fi

