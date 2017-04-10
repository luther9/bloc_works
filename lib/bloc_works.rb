require "bloc_works/version"
require("bloc_works/dependencies")
require("bloc_works/controller")

# The following are not specified by the checkpoint.
#require('bloc_works/router')
#require('bloc_works/utility')

module BlocWorks
  class Application
    def call env
      [
       200,
       {'Content-Type' => 'text/html'},
       # I'm changing the message here to show that this is coming from
       # BlocWorks, not the client app.
       ["This is BlocWorks! Your app isn't doing anything."],
      ]
    end
  end
end
