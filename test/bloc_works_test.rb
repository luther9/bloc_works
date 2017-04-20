require('rack/test')

require('bloc_works')

class MyController < BlocWorks::Controller
  def welcome
    'Hello'
  end
end

class BlocWorksTest < Test::Unit::TestCase
  include(Rack::Test::Methods)

  def app
    BlocWorks::Application.new
  end

  def test_call
    get('/my/welcome')
    assert(last_response.ok?)
    assert(last_response.body == 'Hello')
  end
end
