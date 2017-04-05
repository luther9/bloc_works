require('rack/test')

class BlocWorksTest < Test::Unit::TestCase
  include(Rack::Test::Methods)

  def app
    BlocWorks::Application.new
  end

  def test_call
    get('/')
    assert(last_response.ok?)
  end
end
