require "bloc_works/version"
require("bloc_works/dependencies")
require("bloc_works/controller")

# The following are not specified by the checkpoint.
require('bloc_works/router')
require('bloc_works/utility')

module BlocWorks
  class Application
    def call env
      action = controller_and_action(env)
      str = action[0].new(env).send(action[1])
      [
       200,
       {'Content-Type' => 'text/html'},
       [str],
      ]
    end
  end
end
