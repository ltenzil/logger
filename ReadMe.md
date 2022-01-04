Log Parser:

The program reads through a given log file and calculates
the total and unique page views.

It uses OptionParser, a class for command-line option analysis.

Log Parser application includes 3 files.
1. Log.rb
2. OptionsValidator.rb
3. webserver.log

Test Files:
1. log_test.rb
2. options_validator_test.rb


OptionsValidator:

  This is a module, which utilises option parser to validate arguments passed.

  Has 2 methods:
  
  parse_options:
    The main method which does the validation and checks for the presence of the file.
    
  get_file:
    This method calls parse_options and get the file name which is passed in the argument.

Log:

  Log is a class, and it extends OptionsValidator.

  It has a series of method:

  parse:         Parse the user given file and throw error if any
  
  format_log:    Read through the contents of the file and create page information.
  
  sort_results:  Sorts the page info, in descending order.
  
  uniq_results:  Collects the unique page visits
  
  total_results: Collects the total visits for the given page.
  
  print_info:    Prints the collected data in console for the user.
