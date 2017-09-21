## Install Ruby with rbenv
### Install Dependencies in Ubuntu:

```
sudo apt install git build-essential libssl-dev libreadline-dev zlib1g-dev mariadb-server libmariadb-client-lgpl-dev libmariadb-client-lgpl-dev-compat
```

### Install rbenv:
```
git clone https://github.com/rbenv/rbenv.git ~/.rbenv
```

### Export rbenv to .bashrc

```
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
```

### Refresh Your Environment
```
source ~/.bashrc
```

### Install ruby-build for rbenv

```
mkdir -p "$(rbenv root)"/plugins
git clone https://github.com/rbenv/ruby-build.git "$(rbenv root)"/plugins/ruby-build
```

### Install Ruby 2.4.2 (This will take a while)

```
rbenv install 2.4.2
```

### Set Global Ruby Version in rbenv

```
rbenv global 2.4.2
```

## Install/Configure MariaDB Client/Server

### Secure MariaDB

```
sudo mysql_secure_installation
```

### Login to MariaDB

```
sudo mysql -u root -p
```

### Create the Database

```
CREATE DATABASE openpbp_development;
```

### Create a User

```
CREATE USER 'openpbp'@'localhost' IDENTIFIED BY 'YOUR-PASSWORD';
```

### Grant Your New User Access to the Database

```
GRANT ALL ON openpbp_development.* TO 'openpbp'@'localhost';
```

### Flush Privileges for the Database Server
```
FLUSH PRIVILEGES;
```

### Exit MariaDB Server

```
exit
```

## Install bundler
```
gem install bundle
```

## Amazon AWS
OpenPBP uses Amazon S3 and CloudFront to serve user submitted media. It's a cheap, scalable way to host media content from a highly available CDN. You will need the following:

* An S3 Bucket setup.
  * You will need the `Bucket name`, `AWS Region` and two folders created inside the bucket. `campaign-images` and `character-portraits`.
* A CloudFront distribution setup for that bucket.
  * The `URL` for that bucket.
* Your `AWS Access Key ID` and `AWS Secret Key`

The specifics of setting this up are outside of the scope of this README but it's a very simple process and guides are widely available.