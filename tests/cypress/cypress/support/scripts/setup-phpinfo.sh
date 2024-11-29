
docker exec app bash -c "cd /var/www/html/public && rm -rf *"

docker exec app bash -c "cd /var/www/html/public && echo '<?php phpinfo();' > index.php"
