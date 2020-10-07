ALTER USER 'root'@'localhost' IDENTIFIED BY 'MyPass@1';
uninstall plugin validate_password;
ALTER USER 'root'@'localhost' IDENTIFIED BY '{{MYSQL_ROOT_PASSWORD}}';