#!/usr/bin/env bash
set -e
if [ ! -f var/setup ]; then
    echo "Getting ready to start. Waiting 15 seconds for mariadb to start if you are using docker compose"
    sleep 15
    echo "env not found. Copying from example"

    echo "Generating application key"
    php artisan key:generate
    echo "Setting up db and email settings"
    php artisan pterodactyl:env --dbhost=$db_host --dbport=$db_port --dbname=$db_name --dbuser=$db_user --dbpass=$db_pass --url=$panel_url --timezone=$timezone
    case "$email_driver" in
        mail)
        echo "      PHP Mail was chosen"
        php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email
        ;;
        mandrill)
        php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user
        echo "      Mandrill was chosen"
        ;;
        postmark)
        php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user
        echo "      Postmark was chosen"
        ;;
        mailgun)
        php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user --host=$email_domain
        echo "      Mailgun was chosen"
        ;;
        smtp)
        php artisan pterodactyl:mail --driver=$email_driver --email=$panel_email --username=$email_user --password=$email_pass --host=$email_domain --port=$email_port
        echo "      smtp was chosen"
        ;;
        *)
        echo "      There was an error and you need to run the container again with the email information"
     esac
    echo "      Migrating Database"
    php artisan migrate --force
    echo "      Seeding Database"
    php artisan db:seed --force
    echo "      Setting up user"
    php artisan pterodactyl:user --email=$admin_email --password=$admin_pass --admin=$admin_stat

    echo "writing file to say setup has finished"
    touch var/setup
    ls var/setup

else # Found an env file and testing for panel version
    echo "Starting up"
fi

apache2-foreground