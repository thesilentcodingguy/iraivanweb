# =========================
# STRING INTERPOLATION
# =========================
name = "Anirudh"
age = 20
puts "Name: #{name}, Age: #{age}"   # interpolate variables inside string

# =========================
# INPUT & TYPE CONVERSION
# =========================
input = gets                       # takes input with newline
input_clean = gets.chomp           # removes newline
num_int = gets.chomp.to_i          # converts input to integer
num_float = gets.chomp.to_f        # converts input to float
str = 10.to_s                      # converts to string

# =========================
# CONDITIONALS
# =========================
x = 10

if x > 5
  puts "Greater"                  # basic if
elsif x == 5
  puts "Equal"                    # elsif condition
else
  puts "Smaller"                  # fallback
end

# nested if
if x > 0
  if x % 2 == 0
    puts "Positive Even"          # nested condition
  end
end

# one-line if
puts "Positive" if x > 0          # inline condition

# ternary operator
result = x > 5 ? "Big" : "Small"  # short condition
puts result

# case statement
grade = "A"
case grade
when "A"
  puts "Excellent"                # case matching
when "B"
  puts "Good"
else
  puts "Average"
end

# =========================
# LOOPS
# =========================

# while loop
i = 1
while i <= 3
  puts i                          # runs while condition true
  i += 1
end

# until loop
j = 1
until j > 3
  puts j                          # runs until condition becomes true
  j += 1
end

# for loop
for k in 1..3
  puts k                          # iterates over range
end

# infinite loop
loop do
  break                           # breaks immediately
end

# times iterator
3.times do |n|
  puts n                          # runs block n times
end

# each iterator
[1,2,3].each do |num|
  puts num                        # iterates array
end

# each with index
["a","b"].each_with_index do |val, i|
  puts "#{i}: #{val}"             # access index + value
end

# ranges
(1..5).each { |i| puts i }        # inclusive range
(1...5).each { |i| puts i }       # exclusive range

# loop control
(1..5).each do |n|
  next if n == 3                  # skip iteration
  break if n == 5                 # exit loop
  puts n
end

# redo example
i = 0
while i < 1
  puts i
  i += 1
  redo if i == 1                  # repeats same iteration
end

#MENU DRIVEN

loop do
  puts "\n1. Add Numbers"
  puts "2. Multiply Numbers"
  puts "3. Exit"

  print "Enter choice: "
  choice = gets.chomp.to_i

  case choice
  when 1
    print "Enter two numbers: "
    a, b = gets.split.map(&:to_i)
    puts "Sum: #{a + b}"
  when 2
    print "Enter two numbers: "
    a, b = gets.split.map(&:to_i)
    puts "Product: #{a * b}"
  when 3
    puts "Exiting..."
    break                      # exit loop
  else
    puts "Invalid choice"
  end
end


#INPUT VALIDATION

num = nil

loop do
  print "Enter a number > 10: "
  num = gets.chomp.to_i

  if num > 10
    break                      # valid input → exit loop
  else
    puts "Invalid input, try again"
  end
end

puts "You entered #{num}"


#SEARCH IN ARRAY

arr = [4, 7, 2, 9, 5]
target = 9

found = false

arr.each do |num|
  if num == target
    found = true
    break                      # stop when found
  end
end

puts found ? "Found" : "Not Found"

#SKIP VALUES

(1..10).each do |i|
  next if i % 2 == 0           # skip even numbers
  puts i
end

#NESTED LOOP

(1..3).each do |i|
  (1..3).each do |j|
    print "#{i*j} "
  end
  puts
end

# COUNT AND ACCUMULATE

nums = [10, 20, 30, 40]

sum = 0

nums.each do |n|
  sum += n                     # accumulate values
end

puts "Total: #{sum}"

count = 0

nums.each do |n|
  count += 1 if n > 20         # conditional counting
end

puts "Count > 20: #{count}"

#FREQUENCY COUNTER

arr = ["a", "b", "a", "c", "b", "a"]

freq = {}

arr.each do |item|
  freq[item] = (freq[item] || 0) + 1
end

puts freq

#REVERSE ITER

arr = [1, 2, 3, 4]

(arr.length - 1).downto(0) do |i|
  puts arr[i]
end

#LOOP WITH CONDITION

(1..10).each do |i|
  next if i == 3              # skip 3
  break if i == 8             # stop at 8
  puts i
end

# USER INPUT WITH EXIT

loop do
  print "Type something (exit to quit): "
  input = gets.chomp

  break if input == "exit"     # stop loop

  puts "You typed: #{input}"
end

# FILTER SYSTEM

numbers = [5, 12, 7, 20, 3]

result = []

numbers.each do |n|
  if n > 10
    result << n               # collect filtered values
  end
end

puts result.inspect

# =========================
# FUNCTIONS (METHODS)
# =========================

def greet(name)
  "Hello #{name}"                 # returns last expression
end

puts greet("Anirudh")

# default parameter
def greet_default(name="Guest")
  "Hello #{name}"                 # default argument
end

# multiple params
def add(a, b)
  a + b                           # addition
end

# explicit return
def subtract(a, b)
  return a - b                    # explicit return
end

# variable arguments
def sum(*nums)
  nums.sum                        # accepts multiple inputs
end

# keyword arguments
def intro(name:, age:)
  "#{name} is #{age}"             # named parameters
end

# bang method
str = "hello"
str.upcase!                       # modifies original string

# recursion factorial
def fact(n)
  return 1 if n == 0             # base case
  n * fact(n-1)                  # recursive call
end

# recursion fibonacci
def fib(n)
  return n if n <= 1             # base case
  fib(n-1) + fib(n-2)            # recursion
end

# recursion sum
def sum_n(n)
  return 0 if n == 0
  n + sum_n(n-1)
end

# recursion reverse string
def reverse_str(s)
  return s if s.length <= 1
  s[-1] + reverse_str(s[0...-1])
end

# =========================
# ARRAYS
# =========================
arr = [1,2,3]

arr << 4                         # add element
arr.push(5)                      # push element
arr.unshift(0)                   # add to front
arr.pop                          # remove last
arr.shift                        # remove first

arr[0]                           # access element
arr[-1]                          # last element

arr.each { |x| puts x }          # iterate
arr.map { |x| x*2 }              # transform
arr.select { |x| x.even? }       # filter
arr.reject { |x| x.even? }       # reject
arr.include?(2)                  # check existence
arr.sort                         # sort array
arr.sort!                        # sort in-place

matrix = [[1,2],[3,4]]           # 2D array
matrix[0][1]                     # access nested

# =========================
# HASHES
# =========================
person = {name: "A", age: 20}

person[:name]                    # access value
person[:city] = "Chennai"        # add/update
person.delete(:age)              # delete key

person.each do |k,v|
  puts "#{k}: #{v}"              # iterate key-value
end

person.keys                      # get keys
person.values                    # get values
person.has_key?(:name)           # check key
person.fetch(:name)              # safe access

# nested structures
data = [
  {name: "A", marks: 80},
  {name: "B", marks: 90}
]

data.each { |d| puts d[:name] }  # iterate nested hash

# =========================
# OOP (CLASSES)
# =========================
class Person
  attr_accessor :name, :age      # getter & setter

  def initialize(name, age)
    @name = name                 # constructor
    @age = age
  end

  def greet
    "Hi #{@name}"                # instance method
  end
end

p = Person.new("A", 20)
puts p.greet

# inheritance
class Animal
  def speak
    "Sound"
  end
end

class Dog < Animal
  def speak
    "Bark"                       # override method
  end
end

puts Dog.new.speak

# super keyword
class Cat < Animal
  def speak
    super + " Meow"              # call parent method
  end
end

# class method
class MathUtil
  def self.add(a,b)
    a+b                          # class-level method
  end
end

# =========================
# MODULES & MIXINS
# =========================
module Walkable
  def walk
    "Walking..."                 # module method
  end
end

module Speakable
  def speak
    "Speaking..."                # another module
  end
end

class Human
  include Walkable               # mixin module
  include Speakable
end

h = Human.new
puts h.walk
puts h.speak

# extend (class-level mixin)
module ClassMethods
  def hello
    "Class Hello"
  end
end

class Test
  extend ClassMethods            # adds method to class
end

puts Test.hello
