require 'lib/chianna.rb'

class Counter < Component
  
  def render
    puts self.value.inspect
    self.value ||= rand(10000)
    
    div.counter {
      h1 "This is the counter component"
      h2 self.value
      p "How's it going?"
      div.test! {
        component Clock
      }      
    }
  end
  
end

class Clock < Component
  
  def render
    self.value ||= Time.now.to_s
    
    div.clock {
      p self.value
    }
  end
  
end

Chianna.connect

app = Chianna::Application.new

app.map Counter, '/'
app.map Counter, '/counter'
app.map Clock, '/clock'

app.run