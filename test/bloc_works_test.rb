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
    my_app = BlocWorks::Application.new
    my_app.route {
      map(':controller/:action')
    }
    my_app
  end

  def test_call
    get('/my/welcome')
    assert(last_response.ok?)
    assert(last_response.body == 'Hello')
  end

  def test_map
    router = BlocWorks::Router.new
    assert(router.map(':controller/:action').size == 1)
  end

  def test_look_up_url
    router = BlocWorks::Router.new
    router.map(':controller/:action')
    assert(router.look_up_url('/my/welcome').is_a?(Proc))
  end
end
