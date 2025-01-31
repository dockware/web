
docker exec web_cypress bash -c "cd /var/www/html/public && rm -rf *"

docker exec web_cypress bash -c "cd /var/www/html/public && echo '<?php phpinfo();' > index.php"
