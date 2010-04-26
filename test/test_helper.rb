require 'rubygems'
require 'active_support'
require 'active_support/test_case'
require 'action_controller'
require 'action_controller/test_case'

require 'rr'
class ActiveSupport::TestCase
  include RR::Adapters::TestUnit
end

require 'shoulda'

$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../../paperclip/lib'))
require File.expand_path(File.join(File.dirname(__FILE__), '../../paperclip/init'))
$:.unshift File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
require File.expand_path(File.join(File.dirname(__FILE__), '../init'))
