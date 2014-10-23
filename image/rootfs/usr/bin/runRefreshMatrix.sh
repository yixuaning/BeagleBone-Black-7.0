echo " "
echo " "
echo "Refreshing Matrix"
cd /usr/share/matrix-gui-2.0/
rm cache/* > /dev/null 2>&1
php generate.php
cd -
echo "Refresh Complete"
