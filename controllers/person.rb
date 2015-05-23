require_relative '../lib/controller'

class Person < Shelf::BaseController
  def say_hello
    erb
  end

  def say_age
    @age = @age.to_i + @incrementer.to_i
    erb
  end
end
