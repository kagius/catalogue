Feature: Send contact email
	Email should not be sent if no return email is provided.
	Email should not be sent if the email address is invalid.
	Email should not be sent if no message is provided.
	Email should not be sent if the message is too long.
	Email should be sent if both return email and message are provided.

	@browser
	Scenario: I try to contact with no details.
		Given that I am on the contact page
		And I have not provided an email address
		And I have not provided a message
		When I click the send button
		Then I get an error notification saying "We need your email address to reply to your message. Don't worry, we won't give it to anyone else!"
		And I get an error notification saying "Please enter your message in the box above."

	@browser
	Scenario: I try to contact with a message but no email address.
		Given that I am on the contact page
		And I have provided a message
		But I have not provided an email address	
		When I click the send button
		Then I get an error notification saying "We need your email address to reply to your message. Don't worry, we won't give it to anyone else!"

	@browser
	Scenario: I try to contact with a message and an invalid email address.
		Given that I am on the contact page
		And I have provided a message
		And I have provided an invalid email address	
		When I click the send button
		Then I get an error notification saying "This email address looks a bit off. Are you sure it's correct?"

	@browser
	Scenario: I try to contact with an email address but no message.
		Given that I am on the contact page
		And I have provided an email address
		But I have not provided a message
		When I click the send button
		Then I get an error notification saying "Please enter your message in the box above."

	@browser
	Scenario: I try to contact with both email address and message.
		Given that I am on the contact page
		And I have provided an email address
		And I have provided a message
		When I click the send button
		Then I get a success notification

	@browser
	Scenario: I try to contact with an valid email address and a short message.
		Given that I am on the contact page
		And I have provided an email address
		And I have provided a very short message
		When I click the send button
		Then I get an error notification saying "Please enter a longer message - we can't take messages under 50 characters."

	@browser
	Scenario: I try to contact with an valid email address and a long message.
		Given that I am on the contact page
		And I have provided an email address
		And I have provided a very long message
		When I click the send button
		Then I get an error notification saying "Sorry, we can't accept messages over 1000 characters long."