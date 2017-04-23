require("erubis")

module BlocWorks
  class Controller
    def initialize env
      @env = env
    end

    def render view, locals={}
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
