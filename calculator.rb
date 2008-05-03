# This is how I envision this to work somewhere in the future,
# this app doesn't actually work yet!

class Calculator < Component

  map '/calculator'

  attr_persistent :current, :total, :operation
  bind :display
  
  def initialize
    self.current = 0
    self.total = 0
    self.display.text.bind_to! :current
  end

  def number(i)
    self.current = (self.current * 10) + i
  end
  
  def operation(op)
    self.compute
    self.operation = op
  end
  
  def compute
    case self.operation
    when '+'
      self.total += self.current
    when '-'
      self.total -= self.current
    when '*'
      self.total *= self.current
    when '/'
      self.total /= self.current
    end
    self.current = 0
    self.operation = nil
  end

  def clear
    self.current = 0
    self.total = 0
    self.operation = nil
  end
  
  protected
  
  def render
    div.display! :bind => :display
    
    ol.numbers! do
      (0..9).each do |i|
        li i, :click => [:number, i]
      end
    end
    
    ul.operations! do  
      li '+', :click => [:operation, '+']
      li '-', :click => [:operation, '-']
      li '*', :click => [:operation, '*']
      li '/', :click => [:operation, '/']
      li '=', :click => :compute
      li 'AC', :click => :clear
    end
  end
  
end