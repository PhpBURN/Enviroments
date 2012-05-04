<VirtualHost *:80>
	ServerName test.gnoose.com
	ServerAlias test.gnoose.com
	ServerAdmin webmaster@localhost

	DocumentRoot /home/ubuntu/www/test.gnoose.com
	<Directory />
		Options Indexes FollowSymLinks MultiViews
		AllowOverride All
		Order allow,deny
		allow from all
	</Directory>

	ErrorLog ${APACHE_LOG_DIR}/test.gnoose.com-error.log

	# Possible values include: debug, info, notice, warn, error, crit,
	# alert, emerg.
	LogLevel warn

	CustomLog ${APACHE_LOG_DIR}/test.gnoose.com-access.log combined
</VirtualHost>
