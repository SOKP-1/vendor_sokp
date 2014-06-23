for combo in $(curl -s https://raw.githubusercontent.com/SOKP/hudson/master/sokp-build-targets | sed -e 's/#.*$//' | grep SOKP-kk | awk {'print $1'})
do
    add_lunch_combo $combo
done
