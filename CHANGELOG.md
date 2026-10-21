# Changes in Project

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.4.3]

### Security

- Updated PHP to 8.2.35, 8.3.36, 8.4.27 and 8.5.12 to fix CVE-2026-109618 and CVE-2026-109619.
- Updated PHP 7.4, 8.0 and 8.1 packages to the ondrej/php builds with backported fixes for CVE-2026-109618 and CVE-2026-109619 (7.4.33-31, 8.0.30-25, 8.1.34-9).
- Updated Node.js to 22.23.4 and 24.22.1 to include the Node.js security release from 2026-10-20.

### Changed

- Builds now run without Docker cache, because cached layers kept old, vulnerable PHP and Node versions.

## [1.4.2]

### Fixed

- Fix a bug that led to around 30 seconds FPM restart time when switching to PHP 8.5.

## [1.4.1]

### Fixed

- Fix tideways to not ignore the ENV in sudo mode

## [1.4.0]

### Added

- Add AMQP, PCov, Redis and zstd extensions for PHP 8.5
- Add tideways ENV variables (service, environment)

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
