require 'test/unit'
require_relative './log'

# Test cases for log class
class LogTest < Test::Unit::TestCase
  def setup
    file_name = "#{File.dirname(__FILE__)}/webserver.log"
    @argv = "-f#{file_name}"
  end

  def test_get_file
    log = Log.new
    assert_empty log.file
  end

  def test_set_file
    log = Log.new(file: 'webserver1.log')
    assert_equal log.file, 'webserver1.log'
  end

  def test_get_page_info
    log = Log.new
    assert_equal log.page_info, {}
  end

  def test_set_page_info
    log = Log.new(page_info: { 'home' => [] })
    assert_equal log.page_info, { 'home' => [] }
  end

  def test_parse_args_error
    assert_raise(OptionParser::InvalidOption) { Log.parse_options('-d') }
  end

  def test_parse
    log = Log.parse @argv
    assert_instance_of Log, log
    assert_equal log.file, "#{File.dirname(__FILE__)}/webserver.log"
    assert_true log.page_info.keys.include?('/contact')
    assert_equal log.page_info['/contact'].count, 89
  end

  def test_file_presence
    file_name = "#{File.dirname(__FILE__)}/no_file.log"
    argv      = "-f#{file_name}"
    log       = Log.parse(argv)
    assert_equal log.error, 'No such file or directory'
  end

  def test_invalid_argument
    file_name = "#{File.dirname(__FILE__)}/web.log"
    argv = "-d#{file_name}"
    log = Log.parse(argv)
    assert_equal log.error, "invalid option: #{argv}"
  end

  def test_missing_argument
    log = Log.parse('-f')
    assert_equal log.error, 'missing argument: -f'
  end

  def test_uniq_views
    log = Log.parse @argv
    assert_true log.uniq_views.include?('/contact 23 unique views')
  end

  def test_total_views
    log = Log.parse @argv
    assert_true log.total_views.include?('/about 81 views')
  end

  def test_sort_total_results
    log         = Log.parse @argv
    results     = log.sort_results
    pages       = results.keys
    first_page  = pages.first
    second_page = pages[1]
    assert_true(results[first_page].count > results[second_page].count)
  end

  def test_sort_uniq_results
    log         = Log.parse @argv
    results     = log.sort_results('uniq')
    pages       = results.keys
    first_page  = pages.first
    last_page   = pages.last
    assert_true(results[first_page].count > results[last_page].count)
  end
end
