# How to contribute?

<!-- TOC -->
* [How to contribute?](#how-to-contribute)
  * [Modify PHP](#modify-php)
  * [Modify Node](#modify-node)
  * [Other changes](#other-changes)
  * [Testing](#testing)
<!-- TOC -->


## Modify PHP

All PHP installations and configurations can be found in **./src/scripts/install_php.sh** as well as the **php** folder inside.

A specific PHP version should be installed in a separate file **./src/scripts/php/install_phpX.Y.sh**.
To use that script, please modify the **./src/scripts/install_php.sh** file and add the PHP version.
When building the image, the PHP modifications will be automatically applied.

If you want to update PHP specific things for all PHP versions, please try to add it inside the **install_php.sh** file.

Things that are related to PHP, but not directly, should be added to the PHP **run layer** inside the **Dockerfile**.

## Modify Node

All Node installations and configurations can be found in **./src/scripts/install_node.sh**.
Please add the Node version to the **./src/scripts/install_node.sh** file.
When building the image, the Node modifications will be automatically applied.

Things that are related to Node, but not directly, should be added to the Node **run layer** inside the **Dockerfile**.

## Other changes

If you want to add or modify other things, please try to keep the **Dockerfile** as clean as possible.
Installation of tools are only done in the run layer with **apt-get install** commands.

## Testing

When adding new features or modifying existing ones, please also write **SVRUnit** tests for them.

You can then simply run the tests by executing the corresponding command in the **makefile**.

SVRUnit tests are structured into different sections like **core**, **features**, **php* and **node**.
This helps to keep the tests organized and easy to maintain.