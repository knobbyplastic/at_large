# Auto At-Large

When distributing invitations to the National Championship, a certain portion of them are allocated based on performance 
at various qualifying tournaments, the regional qualifiers and National Opens. The competitors that receive these 
invitations are determined based a formula described in documents that can be accessed through your NCFCA account. This 
program allows its user to enter results from tournaments and then export the current at-large standings. Since the final 
calculations of Individual Event standings require knowledge of information not publicly released, any found using this 
program are to a certain degree estimates. Completely accurate debate standings can be found if all records are known.

## Usage

Pretty easy (as long as you have Ruby installed): just download the contents of the `lib` folder into its very own 
directory on your computer and run `interface.rb`. Use `new` to input results from a tournament and `export` to export 
standings to a text file. It requires at least Ruby 2.1.0.

## Organization

Results information are stored in CSV files. The logic concerned with placing results in those files are found in the 
`Event` class (in the `event.rb` file). Some other methods as well as the standings calculation and export code are found 
in the `AtLarge` module (in the `at_large.rb` file). The command line interface is found in `interface.rb` and needed 
constants are stored in `constants.rb`.

## Todo

* A complete testing suite is needed
* Better organization
* Trawling of results (perhaps using Nokogiri)
* An improved interface
* More contained, organized results storage