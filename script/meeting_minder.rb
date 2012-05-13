#!/usr/bin/env ruby

ENV['RAILS_ENV']="production"

require File.dirname(__FILE__) + '/../config/boot'
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")

# TODO: 7am at first, but then can have --morning and --afternoon for 3pm too (and evening, if needed), with a new column on the minders (or do this hourly and just enter the hour?)

MeetingMinder.send_all
