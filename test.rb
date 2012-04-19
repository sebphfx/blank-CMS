require './app'
require 'test/unit'
require 'rack/test'


class BlankTest < Test::Unit::TestCase
  include Rack::Test::Methods

  def app
    Blank
  end

  def test_login_on_admin_page 
     authorize "sebastien","admin"
        request '/admin'
         assert_equal "Basic c2ViYXN0aWVuOmFkbWlu\n",last_request.env["HTTP_AUTHORIZATION"]
  end


	   
  



end
