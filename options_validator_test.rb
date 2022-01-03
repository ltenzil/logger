require 'test/unit'
require_relative './options_validator'

# Test cases for options_validator module
class OptionsValidatorTest < Test::Unit::TestCase
  def setup
    @dummy_class = Class.new { extend OptionsValidator }
  end

  def test_parse_options
    file_name = "#{File.dirname(__FILE__)}/webserver.log"
    argv = "-f#{file_name}"
    opts = @dummy_class.parse_options argv
    assert_equal opts, { file: file_name }
  end

  def test_get_file
    file_name = "#{File.dirname(__FILE__)}/webserver.log"
    argv = "-f#{file_name}"
    opts = @dummy_class.get_file argv
    assert_equal opts, './webserver.log'
  end

  def test_file_not_found
    assert_raise(Errno::ENOENT) { @dummy_class.parse_options('-f no-file.log') }
  end

  def test_get_file_not_found
    assert_raise(Errno::ENOENT) { @dummy_class.get_file('-f./no-file.log') }
  end

  def test_invalid_args
    assert_raise(OptionParser::InvalidOption) { @dummy_class.parse_options('-d') }
  end

  def test_invalid_file_args
    assert_raise(OptionParser::InvalidOption) { @dummy_class.get_file('-d') }
  end

  def test_missing_args
    assert_raise(OptionParser::MissingArgument) { @dummy_class.parse_options('-f') }
  end
end
