#!/bin/env ruby
#

require 'optparse'
require "rubygems"
require 'bundler/setup'
require 'mysql2'
require "active_record"
require File.join(File.dirname(__FILE__), 'lib/generate_report.include.rb')

#load_models()
#xx = get_catalog_projects()
#xx.keys.sort.each {|name|
#  id = xx[name]
#  puts "asdf: #{id} and #{name}"
#}
#exit()

#if ( ARGV.length==0 )
#  puts "USAGE: generate_report.pl:"
#  puts "\t-p [project_id]"
#  puts "\t-o [output filename]"
#end
#

options = {:project_id => nil, :out_fname => nil }
#
parser = OptionParser.new do|opts|
  opts.banner = "Usage: generate_report.rb [options]"
  opts.on('-n', '--project_id project_id', 'project id') do |project_id|
    options[:project_id] = project_id;
  end
  opts.on('-o', '--out_fname out_fname', 'output filename') do |out_fname|
    options[:out_fname] = out_fname;
  end
  opts.on('-h', '--help', 'Displays Help') do
    puts opts
    exit
  end
end
#

parser.parse!

# load the models
load_models()

project_list = get_catalog_projects()

# list out projects if project id not specified
if options[:project_id] == nil
  puts 'Enter project id: '
  project_list.keys.sort.each {|name|
    id = project_list[name]
    puts "#{id}: #{name}"
  }
  options[:project_id] = gets.chomp
end
project_id = options[:project_id].to_i

# exit if invalid project id
if (!project_list.values.include?(project_id))
  puts "Error: #{project_id} is not a valid project id"
  exit
end

# create output filename if not specified

out_fname = options[:out_fname]
if options[:out_fname] == nil
  date = Time.now
  timestamp = sprintf("%4d%02d%02d_%2d%2d", date.year,date.month,date.day,date.hour,date.min)
  project_name = Project.find(project_id).name.downcase
  out_fname = "#{project_name}.#{timestamp}.catalog_stats.txt"
end

# hash where key is category and value is arr of
# category datafiles
stats_hash = get_datafiles_by_category(project_id)

print_report(stats_hash, out_fname)
