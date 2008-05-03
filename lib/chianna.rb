require 'rubygems'
require 'rack'
require 'markaby'
require 'ruby-debug'
require 'ruby2ruby'

gem 'dm-core'
gem 'dm-is-tree'
gem 'dm-migrations'
require 'data_mapper'
require 'data_mapper/is/tree'
require 'dm-validations'

require 'digest/sha1'
require 'base64'

module Chianna
  def self.connect(db_string = "sqlite3://test.sqlite3")
    DataMapper.setup(:sqlite3, db_string)
  end
end

dir = Pathname(File.dirname(__FILE__) + '/chianna')

require dir / 'helpers'
require dir / 'session'
require dir / 'component'
require dir / 'application'