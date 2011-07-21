= Tropo Hangman

Hangman over SMS using the tropo framework.  Coded in two hours on a Thursday.

= How to play

To start a new game, text anything to 321-710-8879.  Once the game has started, type a single letter to guess a letter or a command for other options.  The commands all start with a colon.  They are:

* :new Start a new game
* :word Show the current word
* :helpr View this information

= Setup

* Signup for a new tropo account
* Attach it to a routed server or a herkou address
* Change the tropo key to match the tropo key on the account
* Push the application to the server and make sure to run migrate and seed

= Future work

* Major refactor of the game controller, moving the message handling to the message model
* Add a front end showing phone number, active games, and users
* Add losing the code
* Add support for guessing multiple letters
