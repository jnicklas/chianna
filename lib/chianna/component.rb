class Component
  
  include DataMapper::Resource
  include DataMapper::Is::Tree
  
  storage_names[:default] = 'chianna_components'
  
  property :kind, Class
  property :identity, String
  property :parent_id, Fixnum
  property :session_id, Fixnum
  property :value, String
  property :persistent_attributes, String
  belongs_to :session
  is_a_tree
  
  class << self
    def find_or_create_by_session_id(session_id)
      self.first(:session_id => session_id) || self.create(:session_id => session_id)
    end
    
    def find_or_create_by_session_id_and_identity(session_id, identity)
      c = self.first(:session_id => session_id, :identity => identity)
      c ||= self.new(:parent_id => self.id, :identity => identity, :session_id => session_id)
      return c
    end
    
    def attr_persistent(*attrs)
      
      attrs.each do |attr|
        
        self.class_eval <<-CLASS
          
          def #{attr}
            fetch_persistent_attribute(:#{attr})
          end
          
          def #{attr}=(value)
            set_persistent_attribute(:#{attr}, value)
          end
          
        CLASS
        
      end
      
    end
  end
  
  protected
  
  include Chianna::Helpers
  
  def fetch_persistent_attribute(attr)
    @persistent_attributes[attr]
  end
  
  def set_persistent_attribute(attr, value)
    @persistent_attributes[attr] = value
  end
  
  def render
    h1 "Override the render method to change this output"
  end
  
  def component(identity, component_klass = nil)
    component_klass, identity = identity, nil unless component_klass
    
    session = Chianna::Session.first(:id => self.session_id)
    puts self.inspect
    puts session.inspect
    if identity
      c = component_klass.find_or_create_by_session_id_and_identity(session.id, identity)
    else
      c = component_klass.find_or_create_by_session_id(session.id)
    end
    return c.call(@env)[2]
  end
  
  def call(env)
    @env = env
    return [200, {"Content-Type" => "text/html"}, render.to_s]
  end
  
  def method_missing(*a, &b)
    m = Markaby::Builder.new({}, self)

    if a[0].to_s !~ /^_/
      s = m.capture { send(*a, &b)}
      if self.respond_to? :layout
        s = m.capture { send(:layout){s} }
      end
      return s
    else
      super
    end
  end
  
end