# Changes in Project

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.3.1]

### Added

- Add Xdebug for PHP 8.5

## [1.3.0]

### Added

- Add official PHP 8.5 release
- Add a built-in healthcheck. You can now use "docker compose up --wait" to wait until the container is fully ready. (@thx for that brilliant idea @BlackScorp)

### Fixed

- Typo: Replaced legacy variant name 'flex' with 'web' (thx @marcoschumacher)

## [1.2.0]

### Added

- Add PHP 8.5 support

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