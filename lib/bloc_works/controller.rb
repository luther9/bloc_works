require("erubis")

module BlocWorks
  class Controller
    def initialize env, view
      @env = env
      @view = view
      @routing_params = {}
    end

    def dispatch action, routing_params={}
      #5
      @routing_params = routing_params
      text = send(action)
      if has_response?
        rack_response = get_response
        [rack_response.status,
         rack_response.header,
         [rack_response.body].flatten,
        ]
      else
        [200, {'Content-Type' => 'text/html'}, [text].flatten]
      end
    end

    def self.action action, response={}
      #6
      proc { |env|
        new(env, action).dispatch(action, response)
      }
    end

    def request
      @request ||= Rack::Request.new(@env)
    end

    def params
      #7
      request.params.merge(@routing_params)
    end

    #1
    def response text, status=200, headers={}
      if !@response.nil?
        raise 'Cannot respond multiple times'
      end
      @response = Rack::Response.new([text].flatten, status, headers)
    end

    #2
    def render view, locals=nil
      if locals.nil?
        if view.is_a?(Hash)
          locals = view
          view = nil
        else
          locals = nil
        end
      end
      response(create_response_array(view, locals))
    end

    def redirect_to url
      response(nil, 301, 'Location' => url)
    end

    #3
    def get_response
      @response
    end

    #4
    def has_response?
      !@response.nil?
    end

    #5
    def create_response_array view, locals={}
      view ||= @view
      filename = File.join("app", "views", controller_dir, "#{view}.html.erb")
      template = File.read(filename)
      eruby = Erubis::Eruby.new(template)
      vars = Hash[instance_variables.map { |v|
                    [v, instance_variable_get(v)]
                  }]
      eruby.result(vars.merge(locals).merge(env: @env))
    end

    def controller_dir
      klass = self.class.to_s
      klass.slice!("Controller")
      BlocWorks.snake_case(klass)
    end
  end
end
