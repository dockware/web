# Changes in Project

All notable changes of releases are documented in this file
using the [Keep a CHANGELOG](https://keepachangelog.com/) principles.

## [Unreleased]

### Changed

- Remove "Xdebug Beta" for PHP 8.4 and switch to official release

### Fixed

- It was possible to start the image with an unsupported Node version which led to problems. The container will now crash during startup to give you immediate feedback.

## [1.1.0]

### Added

- Add "patch" package to support patching Composer vendors

## [1.0.0]

- Add Supervisor
- Initial release with PHP 7.4, 8.0, 8.1, 8.2, 8.3 and 8.4, as well as Node 22 and 24