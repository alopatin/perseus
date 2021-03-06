#!/bin/sh

if [ "X$1" = "X-w" ]
then
    webapp=$1
else
    webapp=../webapp
fi

if ! test -d "$webapp"
then
    echo "Could not find webapp at $webapp" >&2
    echo "Use -w [location] to set webapp location" >&2
    exit 1
fi

case $1 in
    -h | --help | help)
        echo "Use -w as an initial option to change the webapp path"
        echo "Command: get-css, put-js, put-css"
        exit 0
        ;;
    get-css)
        pwd=$(pwd)
        cd "$webapp"
        make css
        cd "$pwd"
        manifest="$webapp/genfiles/stylesheets-packages-compressed.json"
        shared=$(node stylesheets/get_css_name.js "$manifest")
        cp "$webapp/stylesheets/shared-package/$shared" stylesheets/shared.css
        ;;

    put-js)
        cp build/perseus.min.js "$webapp/javascript/perseus-package"
        ;;

    put-css)
        pap="stylesheets/perseus-admin-package"
        files=$(find $pap -maxdepth 1 -type f)
        cp $files "$webapp/$pap"
        files=$(find stylesheets/exercise-content-package -maxdepth 1 -type f)
        cp $files "$webapp/stylesheets/exercise-content-package"
        ;;
esac
