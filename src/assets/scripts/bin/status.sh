echo apache2 status:
service apache2 status

echo ""
echo ""
echo "**********************************************"
echo "DOCKWARE CONTAINER STATUS"
echo "**********************************************"
echo ""
echo "PHP: $(php -v | grep cli)"
echo ""
service php${PHP_VERSION}-fpm status
echo ""
php -v
