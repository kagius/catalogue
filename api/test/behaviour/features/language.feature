Feature: Switch language using the language switcher
	Clicking the language buttons should switch the page to the selected language.

	@browser
	Scenario: I click the "English" button in the navigation
		Given that I am on the site
		When I click the "en" language button
		Then the page language should be set to "en"

	@browser
	Scenario: I click the "Italiano" button in the navigation
		Given that I am on the site
		When I click the "it" language button
		Then the page language should be set to "it"

	@browser
	Scenario: I click the "Francais" button in the navigation
		Given that I am on the site
		When I click the "fr" language button
		Then the page language should be set to "fr"

	@browser
	Scenario: I click the "Deutsch" button in the navigation
		Given that I am on the site
		When I click the "de" language button
		Then the page language should be set to "de"