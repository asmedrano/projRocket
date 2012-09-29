#projRocket: A command line project bootstrapper

##Installation
```git clone``` or download a zip

Stick it in your ```~/bin``` directory or make a .bashrc ```alias```


##Usage:
```
./projRocket --help

./projRocket -t <project_type> -n <project_name> Default: UNTITLED -d <project_directory> Default: CWD
```

##Supported Project Types

###Static
Use: ```-t static```
What happens:
Creates index.html with some basic markup.

###Static Site
Use: ```-t staticsite```
What happens:
Creates a static site based on html5Boilerplate

###Python Module 
Use: ```-t pymodule```
What happens:
Creates a skeleton python module that adheres to 
http://guide.python-distribute.org/creation.html

###Wordpress
Use: ```-t wordpress```
What happens:
Creates a new theme folder based on the html5boilerplate theme 
and grabs Wordpress from github. Your theme is ```ln -s``` into the wordpress theme directory 
You will also be asked if you want to configure your DB which will set up wp-config.php.


##Tested on:
Ubuntu 12.04
MacOSX
