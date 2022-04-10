# Collective Voice - Dancer + Linode Deployment: A Comprehensive Guide
Updated: December 28, 2020
OS: Debian 10


## Step 1: Setup your account
(see also https://www.linode.com/docs/getting-started/)
1. Create a new account (use the Dancer affiliate link?)
2. Create a new Linode
3. Choose your OS (the rest of this guide is based on Debian 10)
4. Choose your region for the server
5. Select a Linode Plan (I'm using the Nanode 1Gb plan for $5/mo)
6. Enter a Linode label for your server
7. Choose a root password
8. (Recommended) Upload your SSH key
9. Click on “Create” button to right to start the build & launch


## Step 2: Setup the new OS
(see also https://www.linode.com/docs/security/securing-your-server/)
1. SSH into your new server as root
2. Create a `dancer` user account with sudo access (see also https://linuxize.com/post/how-to-create-a-sudo-user-on-debian/)
      1. adduser --disabled-password --gecos "" --shell /bin/bash dancer
      2.  usermod -g sudo dancer
      3. passwd -d dancer
      4. Now you can `sudo su - dancer` to access the new account and set a password (e.g., ComeDance).
      5. As root, copy the /root/.ssh/authorized_keys file to the new users ~/.ssh folder (be sure to setup the permissions correctly)
      6. Logout as root
      7. Login as the new user (fix any issues that may arise in step #5)
      8. Setup your favorite environment and shell scripts
3. Harden ssh (see https://medium.com/@jasonrigden/hardening-ssh-1bcb99cd4cef which includes fail2ban configuration)
      1. restrict root login
      2. disable passwords
      3. set port to non-standard (e.g., 3122)
4. Set the hostname (see https://www.linode.com/docs/tools-reference/linux-system-administration-basics/)
5. Configure Postfix for outgoing email (see https://www.linode.com/docs/email/postfix/configure-postfix-to-send-mail-using-gmail-and-google-apps-on-debian-or-ubuntu/)
      1. You will need to take an extra step to send via the server https://www.linode.com/docs/email/running-a-mail-server/#sending-email-on-linode
6. Configure automatic security updates (see https://help.ubuntu.com/community/AutomaticSecurityUpdates)
      1. `sudo apt-get install unattended-upgrades`
7. Add packages needed for setting up our environment
      1. `sudo apt-get install git perl build-essential libssl-dev rsync zlib1g-dev unzip`


## Step 3: Configure Linode for Perl via plenv as `dancer` user
(see also https://kappataumu.com/articles/modern-perl-toolchain-for-web-apps.html)
1. Install plenv via GitHub instructions at https://github.com/tokuhirom/plenv
      1. Install cpanm - `plenv install-cpanm && plenv rehash`
2. Add `export PATH="$HOME/.plenv/bin:$PATH”` to the top of ~/.profile (before .bashrc is sourced)

## Step 4: Deploy code to server
1. This will depend on your app. Oftentimes, apps will have deploy scripts in the bin/ directory to facilitate local development. In our example here, we’d be pushing code to the /home/dancer directory.
      1. Configure the shell-env-local file to match your server settings
      2. Run `bin/cvdeploy`

## Step 5: Setup code and launch app
1. Logon to server and cd to the upload directory
2.  Run `carton install --deployment` (or whatever tool you prefer to load the module requirements)
3. 1. Create a server version of `shell-env-local`
      1. Set $CV_ROOT value
      2. set the environment to "production"
4. Run `bin/cvlauncher start` to start the app


## Step 6: Add Nginx with reverse proxy to Dancer
(see also https://www.linode.com/docs/web-servers/nginx/nginx-installation-and-basic-setup/)
1. `sudo apt-get install nginx`
2. Create an nginx config file (for Ubuntu, add this file to `/etc/nginx/sites-enabled`)
3. Reload the nginx configuration (for Ubuntu, `sudo service nginx reload`)
4. There are lots of resources online for configuring SSL, etc.


## Step 7: Setup SSL certificate
(see also https://www.linode.com/docs/guides/how-to-install-certbot-on-ubuntu-18-04/)
1. Install certbot — `sudo apt install certbot python-certbot-nginx`
2. Get a certificate — `sudo certbot --nginx`
3. Certbot will store all generated keys and issued certificates in the `/etc/letsencrypt/live/$domain` directory


## Step 8: Secure the server with ufw firewall
 (see https://www.linode.com/docs/security/firewalls/configure-firewall-with-ufw/)
1. Setup ufw firewall — `sudo apt-get install ufw`
2. Set default rules
      1. `sudo ufw default allow outgoing`
      2. `sudo ufw default deny incoming`
3. Allow ssh — e.g., `sudo ufw allow 3122`
4. Configure ufw for https access
      1. `sudo systemctl start ufw && sudo systemctl enable ufw`
      2. `sudo ufw allow http`
      3. `sudo ufw allow https`
      4. `sudo ufw enable`
5. Check rules & status — `sudo ufw status`


## Step 9: Configure the app to start on reboot (systemd)
(see https://www.linode.com/docs/quick-answers/linux/start-service-at-boot/ and https://www.linode.com/docs/guides/introduction-to-systemctl/)
1. Copy the unit file in `bin/collectivevoice.service` to /etc/systemd/system and give it permissions
      1. `sudo cp bin/collectivevoice.service /etc/systemd/system/collectivevoice.service`
      2. `sudo chmod 644 /etc/systemd/system/collectivevoice.service`
2. Enable the service to start on reboot
      1. `sudo systemctl enable collectivevoice`
3. Start the service & test availability
      1. `sudo systemctl start collectivevoice`
      2. `sudo systemctl status collectivevoice`
4. Test by rebooting the server


## Tips & Trouble-shooting

1. Useful systemd commands
      1. To get status of a service -- `sudo systemctl status collectivevoice`
      2. To restart the service -- `sudo systemctl restart collectivevoice`
      3. To reset after 'start-limit-hit' -- `sudo systemctl reset-failed collectivevoice.service`
      4. View failed services -- `sudo systemctl list-units --state failed`
      5. View logfiles - `sudo journalctl UNIT=collectivevoice.service`
2. Managing Nginx
      1. Status -- `sudo service nginx status` || `sudo systemctl status nginx`
      2. Restart nginx -- `sudo systemctl restart nginx`
      3. View error log -- `sudo less /var/log/nginx/error.log`
      4. View access log -- `sudo less /var/log/nginx/access.log`
3. Review your Perl environment & tests
      1. Re-run `carton install`
      2. Re-run the test suite to see if it's failing
4. Error "start_server: command not found"
      1. Add `export PATH=local/bin:$PATH` to your `shell-env-local` file
