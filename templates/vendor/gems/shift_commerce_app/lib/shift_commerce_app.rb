require "shift_commerce_<%= app_name.gsub(/^shift-/,'') %>/version"
require 'shift/api/core'
require "shift_commerce/<%= app_name.gsub(/^shift-/,'') %>"

module ShiftCommerce<%= app_name.gsub(/^shift-/,'').camelize %>
  # Your code goes here...
end
