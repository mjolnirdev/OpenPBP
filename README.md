# OpenPBP

OpenPBP is a partially developed asynchronous tabletop gaming application written in Ruby.

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

* Ruby 2.3.1+ (Earlier versions may work but were not tested)
* Ruby Gems
* MySQL/MariaDB
* Amazon AWS Account
* Fresh Ubuntu 16.04 Server (Tested on Linode)
* Direnv (Optional)

### Installing
This section assumes you have Ruby/MariaDB running with the databases setup and configured, if not check the [PREREQUISITES.md](PREREQUISITES.md) file.

#### Download the Project

Clone the project

```
git clone https://github.com/mjolnirdev/OpenPBP.git
```

Enter application directory and run bundler

```
cd OpenPBP/OpenPBP
bundle
```

#### Setup your environment

Install Direnv (optional)

```
sudo apt install direnv
```

Add Direnv to your .bashrc and refresh it
```
echo 'eval "$(direnv hook bash)"' >> ~/.bashrc
source ~/.bashrc
```

Copy .envrc_example to .envrc
```
cp .envrc_example .envrc
```

Configure .envrc with your information
```
nano .envrc
```

Allow the newly edited file
```
direnv allow
```

Note: If you choose not to use direnv you'll need to manually set the values therein using `export`.

#### Migrate the database
```
rake db:migrate
```

#### Run the Padrino server

```
padrino s
```


### Deployment

Deployment to production is outside the scope of this readme, but I recommend [Phusion Passenger](https://www.phusionpassenger.com/install#open-source).

## Built With

* [Padrino](https://github.com/padrino/padrino-framework) - Web Framework.
* [Bulma](https://github.com/jgthms/bulma) - CSS Framework.
* [Ruby](https://rometools.github.io/rome/) - Core language.
* [jQuery](https://github.com/jquery/jquery) - Javascript library.
* [jQuery-Cookie](https://github.com/carhartl/jquery-cookie) - Cookie support for jQuery.
* [Croppie](https://github.com/Foliotek/Croppie) - Javascript image cropping.

## Contributing

If you want to make improvements just submit a pull request and I'll merge it ASAP, don't be shy.

## Authors

* **John Stone** - *Initial work* - [GitHub](https://github.com/john-stone)

## License

This project is licensed under the GPLv2 License - see the [LICENSE.md](LICENSE.md) file for details.

## Acknowledgments

* Don, Peace and Theo.