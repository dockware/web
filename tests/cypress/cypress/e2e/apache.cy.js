describe('Apache Tests', () => {

    before(() => {
        cy.script('clear-container.sh');
    });

    it('Empty Apache Exists', () => {

        cy.visit('/', {failOnStatusCode: false});

        cy.contains('You don\'t have permission to access this resource.');
        cy.contains('Apache/2.4');
    })

})

describe('PHP Tests', () => {

    before(() => {
        cy.script('setup-phpinfo.sh');
    });

    it('PHP is rendered', () => {

        cy.visit('/', {failOnStatusCode: false});

        cy.contains('PHP Version 8.4.1');
    })

})

