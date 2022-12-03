#compdef cs

color_folder=~/Programs/Color-Scripts/color-scripts
test_color_folder=$HOME/Programs/Color-Scripts/test-color-support

_arguments \
	'(-l --list)'{-l,--list}'[List all completion scripts]' \
	'(-t --test :)'{-t,--test}'[Look in the test folder]' \
	':file:($(ls $color_folder))'
