module Chianna

  class Session
    include DataMapper::Resource

    storage_names[:default] = 'chianna_sessions'
    
    property :session_key, String
    has n, :components
  end

  class SessionHandler

    def initialize(app, options={})
      @app = app
      @key = options[:key] || "rack.session"
      @default_options = {:domain => nil, :path => "/", :expire_after => nil}.merge(options)
    end

    def call(env)
      load_session(env)
      status, headers, body = @app.call(env)
      commit_session(env, status, headers, body)
    end

    private

    def load_session(env)
      request = Rack::Request.new(env)
      session_key = request.cookies[@key]

      session_data = Chianna::Session.first(:session_key => session_key) || Chianna::Session.create(:session_key => generate_session_key)
      env["rack.session"] = session_data
      env["rack.session.options"] = @default_options.dup
      
      puts "=> loaded session #{session_key}"
    end

    def commit_session(env, status, headers, body)
      session_data = env["rack.session"]
      session_data.save
      
      options = env["rack.session.options"]
      cookie = Hash.new
      cookie[:value] = session_data.session_key
      cookie[:expires] = Time.now + options[:expire_after] unless options[:expire_after].nil?
      
      response = Rack::Response.new(body, status, headers)
      response.set_cookie(@key, cookie.merge(options))
      response.to_a
    end
    
    def generate_session_key
      
      #key = Base64.encode64(Digest::MD5.digest("---#{Process.pid}---#{Time.now.usec}---#{Time.now.to_i}----")).chomp
      key = rand(1000000).to_s
      key = generate_session_key if Chianna::Session.first(key)
      return key
    end
  end
end
