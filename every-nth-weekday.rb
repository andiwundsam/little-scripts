#!/usr/bin/env ruby

require 'date'
require 'optparse'

class Date
    def dayname
        DAYNAMES[self.wday]
    end

    def abbr_dayname
        ABBR_DAYNAMES[self.wday]
    end
end

options = {}
OptionParser.new do |opts|
      opts.banner = "Usage: $0 [Options] Command"

      opts.on("-w", "--wday WDAY", "Weekday to check for") do |w|
          options[:weekday] = w
      end
      opts.on("-n", "--nth NUM", Integer, "Run on nth weekday of the month") do |n|
          options[:nth] = n
      end
      opts.on("-d", "--delta NUM", Integer, "Delta to apply to today before checking") do |n|
          options[:delta] = n
      end
      opts.on("-v", "--verbose", "Debug logging") do |n|
          $DEBUG = true
      end
end.parse!

def debug(s) 
    puts s if $DEBUG
end

date = Date.today
date += options[:delta] if options[:delta]

if options[:weekday]
    raise "Invalid weekday: #{options[:weekday]}" unless Date::ABBR_DAYNAMES.include? options[:weekday]

    if date.abbr_dayname != options[:weekday]
        debug "Wrong weekday: #{date.abbr_dayname} != #{options[:weekday]}"
        exit 1
    end
end

if options[:nth]
    raise "Invalid nth must be 1-5" unless options[:nth] >=1 and options[:nth] <= 5
    nth = ((date.mday - 1) / 7) + 1
    if nth != options[:nth]
        debug "Wrong nth weekday of the month: #{nth} != #{options[:nth]}"
        exit 1
    end
end

if ARGV
    system(*ARGV)
end

