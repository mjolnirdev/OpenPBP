## Install Ruby with rbenv
### Install dependencies in Ubuntu:

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

### Refresh your environment
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

### Set Ruby version in rbenv

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

### Create the database

```
CREATE DATABASE openpbp_development;
```

### Create a user

```
CREATE USER 'openpbp'@'localhost' IDENTIFIED BY 'YOUR-PASSWORD';
```

### Grant your user access to the database

```
GRANT ALL ON openpbp_development.* TO 'openpbp'@'localhost';
```

### Flush privileges for the database server
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