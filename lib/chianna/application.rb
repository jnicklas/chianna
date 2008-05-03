module Chianna
  
  class Application
    
    attr_reader :routes
    
    include Chianna::Helpers
    
    def initialize
      @components = []
      @routes = {}
    end
    
    def map(component, *routes)
      @components << component
      routes.each do |route|
        @routes[route] = component
      end
    end
    
    def run
      session = Chianna::SessionHandler.new(self)
      Rack::Handler::Mongrel.run(session, :Port => 9000)
    end
    
    def call(env)
      @env = env
      component_klass = match_path(env["REQUEST_URI"])
      
      if component_klass
        c = component_klass.find_or_create_by_session_id(session.id)
        c.call(env)
      else
        return [404, {"Content-Type" => "text/html"}, "Component not Found!"]
      end
    rescue Exception => e
      return [500, {"Content-Type" => "text/html"}, server_error(e)]
    end
    
    def match_path(path)
      @routes.each do |route, component|
        # do something more complicated here later
        return component if path == route
      end
      return nil
    end
    
    def server_error(e)
      markaby do
        html
        head { title "Internal Server Error" }
        body {
          h1 h("Internal Server Error: #{e.class}")
          p e.message
          ul {
            e.backtrace.each do |bt|
              li h(bt.inspect)
            end
          }
        }
      end
    end
    
  end
  
end