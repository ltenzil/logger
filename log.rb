#!/usr/bin/ruby

require_relative './options_validator'

# This class reads through given log file and
# returns uniq and total views for each page
class Log
  attr_accessor :file, :page_info, :error

  extend OptionsValidator

  def initialize(file: '', page_info: {})
    @file = file
    @page_info = page_info
  end

  def self.parse(args)
    begin
      log      = Log.new
      log.file = Log.get_file(args)
      log.format_log
    rescue StandardError => e
      puts "Exception encountered: #{e} \nTry running `ruby log.rb -h` for more details"
      log.error = e.message
    end
    log
  end

  def format_log
    file_contents = File.read file
    content_array = file_contents.split(/[\r\n]+/)
    content_array.each do |row|
      page, ip = row.split
      if page_info[page].nil?
        page_info[page] = [ip]
      else
        page_info[page] << ip
      end
    end
  end

  def total_views
    puts 'Total page views :'
    sorted_results = sort_results
    results = sorted_results.map do |key, value|
      "#{key} #{value.count} views"
    end
    results.join("\n")
  end

  def uniq_views
    puts 'Unique page views :'
    sorted_results = sort_results('uniq')
    results = sorted_results.map do |key, value|
      "#{key} #{value.uniq.count} unique views"
    end
    results.join("\n")
  end

  def sort_results(view = 'total')
    page_info.sort_by do |_page, ips|
      view == 'uniq' ? ips.uniq.count : ips.count
    end.reverse.to_h
  end

  def print_info
    puts '-' * 100
    puts uniq_views
    puts '-' * 100
    puts total_views
    puts '-' * 100
  end
end

log = Log.parse(ARGV)
log.print_info unless log&.page_info == {}
