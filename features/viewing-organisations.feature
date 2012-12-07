Feature: Viewing organisations

Scenario: Organisation page should show policies
  Given the organisation "Attorney General's Office" contains some policies
  And other organisations also have policies
  When I visit the "Attorney General's Office" organisation
  Then I should only see published policies belonging to the "Attorney General's Office" organisation

Scenario: Organisation page should show consultations
  Given the organisation "Attorney General's Office" is associated with consultations "More tea vicar?" and "Cake or biscuit?"
  When I visit the "Attorney General's Office" organisation
  Then I can see links to the consultations "More tea vicar?" and "Cake or biscuit?"

Scenario: Organisation page should show the ministers
  Given the "Attorney General's Office" organisation is associated with several ministers and civil servants
  When I visit the "Attorney General's Office" organisation
  Then I should be able to view all civil servants for the "Attorney General's Office" organisation
  And I should be able to view all ministers for the "Attorney General's Office" organisation

Scenario: Organisation page should show any traffic commissioners
  Given the "Department for Transport" organisation is associated with traffic commissioners
  When I visit the "Department for Transport" organisation
  Then I should be able to view all traffic commissioners for the "Department for Transport" organisation

Scenario: Organisation page should show any chief scientific advisors
  Given the "Department for Transport" organisation is associated with scientific advisors
  When I visit the "Department for Transport" organisation
  Then I should be able to view all civil servants for the "Department for Transport" organisation

Scenario: Organisation pages links to any FOI releases and transparency data publications
  Given the organisation "Cabinet Office" exists
  Then I cannot see links to FOI releases or Transparency data on the "Cabinet Office" about page
  When I associate an FOI release to the "Cabinet Office"
  Then I can see a link to "FOI releases" on the "Cabinet Office" about page
  When I associate a Transparency data publication to the "Cabinet Office"
  Then I can see a link to "Transparency data" on the "Cabinet Office" about page
