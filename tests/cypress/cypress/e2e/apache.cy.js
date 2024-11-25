describe('Apache Tests', () => {

    it('Empty Apache Exists', () => {

        cy.visit('/', { failOnStatusCode: false });

        cy.contains('You don\'t have permission to access this resource.');
        cy.contains('Apache/2.4');
    })

})

