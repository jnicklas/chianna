class String
  def underscore
    self.gsub(/::/, '/').
      gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("-", "_").
      downcase
  end
end

module Chianna
  
  module Helpers
    def h(text)
      text.gsub('>', '&gt;').gsub('<', '&lt;')
    end
    
    def markaby(assigns = {}, &block)
      Markaby::Builder.new(assigns, self, &block).to_s
    end
    
    def session
      @env["rack.session"]
    end
  end
  
end