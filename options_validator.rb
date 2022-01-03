require 'optparse'

# Used option parser to validate required arguments
module OptionsValidator

  def parse_options(args)
    options = {}
    OptionParser.new do |opts|
      opts.banner = 'Usage: Log Parser'
      opts.on('-f', '--file=FILE', 'Enter the log file with absolute path to parse') do |file|
        raise Errno::ENOENT unless File.exist? file

        options[:file] = file
      end
    end.parse(args)
    options
  end

  def get_file(args)
    options = parse_options(args)
    options[:file]
  end
end
