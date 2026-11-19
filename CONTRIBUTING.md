# How to Contribute?

<!-- TOC -->

* [How to Contribute?](#how-to-contribute)
    * [Development](#development)
    * [What to do?](#what-to-do)
    * [Guides](#guides)
    * [Testing](#testing)
    * [Additional Instructions](#additional-instructions)
        * [Modifying PHP](#modifying-php)
        * [Modifying Node](#modifying-node)

<!-- TOC -->


We would love you to contribute to this project! To help you getting started here is a short introduction.

## Development

You can develop and test your changes by using the **Makefile** commands in the root directory.

The all-in-one solution is the "make all" command, but you can also use the individual commands for building, running, and testing the image.

```bash 
# set any version you want, it's just for your local image
make all version=dev
```

## What to do?

We expect you to:

* Add changes to the Dockerfiles, scripts and more.
* Write tests using **SVRUnit** (it's easy) and if it makes sense **Cypress**.
* Add your changes to the **CHANGELOG.md** file.

## Guides

Here are a few things to keep in mind:

* Aim to keep the **Dockerfile** as clean and organized as possible.
* Install additional tools or dependencies in the run layer using **`apt-get install`** commands.

## Testing

When adding new features or modifying existing ones:

1. Write corresponding **SVRUnit** tests to validate your changes.
2. Execute the tests using the appropriate command in the **makefile**.

**SVRUnit** tests are categorized into sections such as **core**, **features**, **php**, and **node**.
This structure ensures the tests are organized and easy to maintain.

**Cypress** tests are created to simulate real-world scenarios and user interactions within web browsers.
Is' a PHP switch really working including the Apache Web Server, can Xdebug be turned on and off, etc.

In that case, we run easy shell scripts, to simulate changing the environments, before running Cypress tests.

## Additional Instructions

### Modifying PHP

All PHP installation scripts and configurations are located in **`./src/scripts/install_php.sh`** and the **`php`** directory.

To install a specific PHP version:

1. Create a separate script in **`./src/scripts/php/install_phpX.Y.sh`**, where `X.Y` is the PHP version.
2. Modify the **`./src/scripts/install_php.sh`** file to reference your new script.

When building the image, your PHP modifications will be automatically applied.

If you need to make changes that affect all PHP versions:

- Add the changes directly to **`install_php.sh`**.

For PHP-related changes that are not tied to the PHP installation itself, include them in the PHP **run layer** within the **Dockerfile**.

#### Automatic PHP releases

The **PHP Watcher** workflow (`.github/workflows/php-watcher.yml`) checks the ondrej/php PPA every hour.
When one of the PHP versions in `install_php.sh` got a new package version and the PPA
is in sync for amd64 and arm64, it bumps the patch version, adds a `CHANGELOG.md` entry, raises the
PHP versions in the existing SVRUnit tests to the complete new version (so a build from an outdated mirror
fails before anything is pushed), commits it to `main`
and starts the CircleCI release with `setLatest=true`.

This is a new PHP release (e.g. 8.4.27 -> 8.4.28) or a new ondrej/php package revision (e.g. 7.4.33-31 -> 7.4.33-32),
which is how security fixes are backported to the EOL versions 7.4, 8.0 and 8.1.
The versions of the last release are stored in `.github/php-versions.json`.
To check locally what the watcher would do:

```bash
python3 tests/scripts/php_watch.py --dry-run
```

### Modifying Node

All Node.js installation scripts and configurations are located in **`./src/scripts/install_node.sh`**.

To install a specific Node.js version:

- Add the version details to **`./src/scripts/install_node.sh`**.

When building the image, your Node.js modifications will be automatically applied.

Adding additional NPM packages should also take place in the **`install_node.sh`** script.
