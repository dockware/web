describe('Apache Tests', () => {

    before(() => {
        cy.script('clear-container.sh');
    });

    it('Empty page without directory listing', () => {

        cy.visit('/', {failOnStatusCode: false});

        cy.contains('You don\'t have permission to access this resource.');
        cy.contains('Apache/2.4');
    })

})

describe('PHP Tests', () => {

    context('Apache renders PHP', () => {
        before(() => {
            cy.script('setup-phpinfo.sh');
        });

        it('PHP info is visible', () => {
            cy.visit('/', {failOnStatusCode: false});
            cy.contains('PHP Version');
            cy.contains('PHP License');
        })
    })

    context('Xdebug enabled', () => {
        before(() => {
            cy.script('xdebug-on.sh');
            cy.script('setup-phpinfo.sh');
        });

        it('Xdebug data in PHP info', () => {
            cy.visit('/', {failOnStatusCode: false});
            cy.contains('xdebug.idekey');
            cy.contains('PHPSTORM');
        })
    })

    context('Xdebug disabled', () => {
        before(() => {
            cy.script('xdebug-off.sh');
            cy.script('setup-phpinfo.sh');
        });

        it('No Xdebug data in PHP info', () => {
            cy.visit('/', {failOnStatusCode: false});
            cy.contains('xdebug.idekey').should('not.exist');
            cy.contains('PHPSTORM').should('not.exist');
        })
    })

    context('Switch PHP Version', () => {
        before(() => {
            cy.script('switch-php.sh 8.3');
            cy.script('setup-phpinfo.sh');
        });

        it('Switch to PHP 8.3', () => {
            cy.visit('/', {failOnStatusCode: false});
            cy.contains('PHP Version 8.3.');
        })

    })

})

