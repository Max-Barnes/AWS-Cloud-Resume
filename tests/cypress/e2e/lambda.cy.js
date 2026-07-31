describe('Basic Tests', () => {
  it('successfully loads', () => {
    cy.visit('/')

    
  })

  it('has a working API', () => {

    cy.visit('/')

    cy.request('GET', 'https://api.maxbarnes.com/getWebsiteVisitors').then(({body}) => {
      const start = Number(body)

      cy.request('POST', 'https://api.maxbarnes.com/writeToWebsiteVisitors') 

      cy.request('GET', 'https://api.maxbarnes.com/getWebsiteVisitors').then(({body}) => { 
        const current = Number(body)
        expect(current).to.be.greaterThan(start)
      })

    })
    cy.reload()
    
    cy.request('GET', 'https://api.maxbarnes.com/getWebsiteVisitors').then(({body}) => {
      const visitors = Number(body)
    cy.get('#Visitors').should('have.text', `Visitor Count: ${visitors}`);
    })
  })
})