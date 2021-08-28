# Custom Errors 

# Create and raise custom error messages in Ruby 

# Ruby has a hierarchy of errors, or Exception, classes, all of which inherit from the 
# Exception class 
# NoMethodError
# ArgumentError
# SyntaxError

# By defining custom erro messages and handling, we can show other developers a specific 
# error message in the event they use some of our code incorrectly 

# A Refresher on Inheritance 
# If one class inherits from another, that means it takes on all of the methods 
# and behaviors of the class from which in inherits 

# Example: The Child class inherits from the Parent Class. 
# Consequently, all instances of Child have not only the behaviors and methods defined directly 
# in the Child class itself but also all of the methods and behaviors defined in the Parent Class 

# class Child < Parent
# end 
#-------------------------------------------------------------------------

# Building a Custom Error 
# We define an error class that inherits from the Exception class 
# Which class your custom error inherits from will likely depend on the situation 
# in which you want to raise it 

# It's a pretty safe bet to inherit your custom error class from StandardError class 

# Defiing the custom error class 
# Define PartnerError that inherits from StandardError 
class PartnerError < StandardError 
end

# Where does it belong in our code 
# There are a couple of options 
# Place the above code inside the person class 
# Or define it outside of our parent class 
# Or we can create a new module that includes that module inside the Person class 

# For now we're going to include our custom error class inside of our Person class 
class Person
  # rest of class...

  def get_married(person)
    self.partner = person
    person.partner = self
  end

  # Add the following two lines:
  class PartnerError < StandardError
  end
end

beyonce = Person.new("Beyonce")
beyonce.get_married("Jay-Z")
puts beyonce.name 

# Raising our custom error 
# We need to tell the program to raise our PartnerError when the argument is passed into 
# the #get_married method is NOT an instance of the Person class 

# We can do that with the raise keyword 
class Person
  attr_accessor :partner, :name

  def initialize(name)
    @name = name
  end

  def get_married(person)
    if person.is_a?(Person)
      self.partner = person
      person.partner = self
    else
      raise PartnerError
    end
  end

  class PartnerError < StandardError
  end
end

beyonce = Person.new("Beyonce")
beyonce.get_married("Jay-Z")
puts beyonce.name 

# When you run the file, you'll get the following 
#=> custom_errors.rb:11:in `get_married': Person::PartnerError (Person::PartnerError) 


#--------------------------------------------------------------------------------
# Custom Error Handling 
# We can achieve the above goal via something called rescuing 

# Step 1: Writing a Custom Error Message 
class PartnerError < StandardError
  def message
    "you must give the get_married method an argument of an instance of the person class!"
  end
end 

# Now we can use rescue 
# Step 2: Implementing the rescue 
begin
  raise YourCustomError
rescue YourCustomError
end 

# Let's implement this code in our #get_married method 
def get_married(person)
  if person.is_a?(Person)
    self.partner = person
    person.partner = self
  else
    begin
      raise PartnerError
    rescue PartnerError => error
      puts error.message
    end
  end
end 

# If the object passed into the method as an argument is not an instance of the Person class 
# we begin our error handling 
# first we raise our PartnerError, then we rescue our PartnerError. 
# The rescue method creates an instance of the PartnerError class and puts out the resulting of calling 
# message on that instnace. 

# At this point the code in custom_error.rb should look like 
class Person
  attr_accessor :partner, :name

  def initialize(name)
    @name = name
  end

  def get_married(person)
    if person.is_a?(Person)
      self.partner = person
      person.partner = self
    else
      begin
        raise PartnerError
      rescue PartnerError => error
        puts error.message
      end
    end
  end

  class PartnerError < StandardError
    def message
      "you must give the get_married method an argument of an instance of the person class!"
    end
  end
end

beyonce = Person.new("Beyonce")
beyonce.get_married("Jay-Z")
puts beyonce.name 

# If we run the file one more time, you'll get not only our custom error message 
# but the program continues to run and will execute the puts beqonce.name line 
# => you must give the get_married method an argument of an instance of the person class!
#=> Beyonce 