# ==============================================================================
# QUESTION 1: SUPERMARKET DISCOUNT BILLING SYSTEM
# Aim: To calculate and display the final bill amount for a customer by applying 
#      discounts based on the total purchase amount.
# ==============================================================================

puts "\n" + "=" * 60
puts "QUESTION 1: SUPERMARKET DISCOUNT BILLING SYSTEM"
puts "=" * 60

print "\nEnter the total purchase amount (in Rs): "
purchase_amount = gets.chomp.to_f

if purchase_amount <= 0
  puts "Error: Invalid purchase amount!"
  exit
end

discount_percentage = 0

if purchase_amount > 5000
  discount_percentage = 15
elsif purchase_amount > 2000
  discount_percentage = 10
elsif purchase_amount > 1000
  discount_percentage = 5
end

discount_amount = (purchase_amount * discount_percentage / 100).round(2)
final_amount = (purchase_amount - discount_amount).round(2)

puts "\n" + "=" * 50
puts "XMart Supermarket - Bill Summary"
puts "=" * 50
puts "Purchase Amount: Rs #{'%.2f' % purchase_amount}"

if discount_percentage > 0
  puts "Discount Applied: #{discount_percentage}%"
  puts "Discount Amount: Rs #{'%.2f' % discount_amount}"
  puts "Final Amount to Pay: Rs #{'%.2f' % final_amount}"
else
  puts "No discount applicable (purchase amount is Rs 1000 or less)"
  puts "Final Amount to Pay: Rs #{'%.2f' % purchase_amount}"
end
puts "=" * 50


# ==============================================================================
# QUESTION 2: EMPLOYEE MONTHLY WAGE CALCULATOR
# Aim: To calculate the monthly wage of an employee based on age, gender, 
#      and number of working days.
# ==============================================================================

puts "\n\n" + "=" * 60
puts "QUESTION 2: EMPLOYEE MONTHLY WAGE CALCULATOR"
puts "=" * 60

puts "\nEmployee Monthly Wage Calculator"

print "Enter employee age: "
age = gets.chomp.to_i

if age < 19 || age > 40
  puts "Error: Please enter appropriate age (19-40)"
  exit
end

print "Enter employee gender (M/F): "
gender = gets.chomp.upcase

unless ['M', 'F'].include?(gender)
  puts "Error: Invalid gender! Please enter M or F."
  exit
end

print "Enter number of days worked this month: "
days_worked = gets.chomp.to_i

if days_worked < 0 || days_worked > 31
  puts "Error: Invalid number of days! Please enter a value between 0 and 31."
  exit
end

daily_wage = if age.between?(19, 30)
  gender == 'M' ? 800 : 850
elsif age.between?(31, 40)
  gender == 'M' ? 900 : 950
else
  0
end

total_wage = daily_wage * days_worked

puts "\n" + "=" * 50
puts "Wage Calculation Summary"
puts "=" * 50
puts "Age: #{age}"
puts "Gender: #{gender == 'M' ? 'Male' : 'Female'}"
puts "Days Worked: #{days_worked}"
puts "Daily Wage: ₹#{daily_wage}"
puts "Total Monthly Wage: ₹#{total_wage}"
puts "=" * 50


# ==============================================================================
# QUESTION 3: VENDING MACHINE SIMULATION
# Aim: To simulate a vending machine that allows users to select products, 
#      make payments, and receive receipts.
# ==============================================================================

puts "\n\n" + "=" * 60
puts "QUESTION 3: VENDING MACHINE SIMULATION"
puts "=" * 60

products = {
  1 => { name: "Soda", price: 30 },
  2 => { name: "Chips", price: 20 },
  3 => { name: "Chocolate", price: 50 }
}

def display_products(products)
  puts "\n" + "=" * 40
  puts "  VENDING MACHINE - AVAILABLE PRODUCTS"
  puts "=" * 40
  products.each do |key, product|
    puts "  #{key}. #{product[:name]} - ₹#{product[:price]}"
  end
  puts "  0. Exit Vending Machine"
  puts "=" * 40
end

def select_product(products)
  loop do
    print "\nEnter product number (1-#{products.size}) or 0 to exit: "
    choice = gets.chomp.to_i

    if choice == 0
      puts "Thank you for using the vending machine. Goodbye!"
      return nil
    elsif products.key?(choice)
      return choice
    else
      puts "Invalid selection! Please enter a number between 1 and #{products.size}."
    end
  end
end

def get_quantity(product_name, price)
  loop do
    print "How many #{product_name}s would you like to buy? (₹#{price} each): "
    quantity = gets.chomp.to_i

    if quantity > 0
      return quantity
    else
      puts "Invalid quantity! Please enter a positive number."
    end
  end
end

def process_payment(total_price, product_name)
  puts "\nTotal amount due: ₹#{total_price}"
  puts "Please insert money (enter amount):"

  total_inserted = 0
  remaining = total_price

  loop do
    print "Insert money (₹#{remaining} remaining) or enter 0 to cancel: ₹"
    money = gets.chomp.to_f

    if money == 0
      puts "Transaction cancelled."
      if total_inserted > 0
        puts "Returning ₹#{total_inserted}"
      end
      return nil
    elsif money > 0
      total_inserted += money
      remaining = total_price - total_inserted

      if remaining <= 0
        change = -remaining
        puts "\nPayment complete!"
        puts "Total inserted: ₹#{'%.2f' % total_inserted}"
        if change > 0
          puts "Change returned: ₹#{'%.2f' % change}"
        end
        return total_inserted
      else
        puts "Remaining amount: ₹#{'%.2f' % remaining}"
      end
    else
      puts "Invalid amount! Please enter a positive value."
    end
  end
end

def display_receipt(product_name, quantity, price, total_paid, change)
  puts "\n" + "=" * 40
  puts "        TRANSACTION RECEIPT"
  puts "=" * 40
  puts "Product: #{product_name}"
  puts "Quantity: #{quantity}"
  puts "Price per item: ₹#{price}"
  puts "Total cost: ₹#{quantity * price}"
  puts "Amount paid: ₹#{'%.2f' % total_paid}"
  if change > 0
    puts "Change returned: ₹#{'%.2f' % change}"
  end
  puts "=" * 40
  puts "Thank you for your purchase!"
end

puts "\n   WELCOME TO THE VENDING MACHINE"
puts "   " + "=" * 35

continue_shopping = true

while continue_shopping
  display_products(products)
  selected_choice = select_product(products)
  break if selected_choice.nil?
  
  selected_product = products[selected_choice]
  quantity = get_quantity(selected_product[:name], selected_product[:price])
  total_price = quantity * selected_product[:price]
  total_paid = process_payment(total_price, selected_product[:name])
  
  if total_paid
    change = (total_paid - total_price).round(2)
    display_receipt(selected_product[:name], quantity, selected_product[:price], total_paid, change)
  end
  
  print "\nWould you like to buy another product? (yes/no): "
  answer = gets.chomp.downcase
  continue_shopping = answer.start_with?('y')
end

puts "\n" + "=" * 40
puts "  Thank you for using our vending machine!"
puts "  Have a nice day!"
puts "=" * 40


# ==============================================================================
# PROBLEM 1: SHOPPING CART WITH CONDITIONAL DISCOUNTS
# Aim: To calculate the final total value of a shopping cart with conditional discounts.
# 
# An array represents the shopping cart where each product contains name, quantity, and price.
# The total is calculated by multiplying quantity and price for each product,
# applying a 10% discount if quantity exceeds 5, and summing all values.
# ==============================================================================

puts "=" * 60
puts "PROBLEM 1: SHOPPING CART WITH CONDITIONAL DISCOUNTS"
puts "=" * 60

cart = [["Laptop", 1, 800], ["Headphones", 6, 50], ["Mouse", 3, 25]]
total = 0

cart.each do |item|
  name, quantity, price = item
  cost = quantity * price
  cost *= 0.9 if quantity > 5
  total += cost
  puts "Item: #{name}, Quantity: #{quantity}, Price: $#{price}, Cost after discount: $#{'%.2f' % cost}"
end

puts "\n" + "-" * 40
puts "Final total: $#{'%.2f' % total}"
puts "=" * 60


# ==============================================================================
# PROBLEM 2: STUDENT GRADEBOOK SYSTEM USING ARRAYS
# Aim: To implement a student gradebook system using arrays with basic management operations.
#
# Student data is stored as nested arrays. The program supports adding, updating,
# removing students, calculating averages, slicing student lists, and displaying
# the complete gradebook.
# ==============================================================================

puts "\n\n" + "=" * 60
puts "PROBLEM 2: STUDENT GRADEBOOK SYSTEM USING ARRAYS"
puts "=" * 60

# Initial students array: [name, id, [grades]]
students = [
  ["Alice", "S001", [85, 90, 78]],
  ["Bob", "S002", [75, 80, 88]],
  ["Charlie", "S003", [90, 92, 95]]
]

puts "\n--- Initial Gradebook ---"
students.each do |s|
  puts "#{s[0]} (ID: #{s[1]}) - Grades: #{s[2].join(', ')}"
end

# 1. Adding a new student
name = "David"
id = "S004"
grades = [88, 92, 85]
students << [name, id, grades]
puts "\n--- After Adding David ---"
puts "Added: #{name}, ID: #{id}, Grades: #{grades.join(', ')}"

# 2. Updating Bob's grades (ID: S002)
students.each do |s|
  if s[1] == "S002"
    old_grades = s[2].dup
    s[2] = [80, 85, 90]
    puts "\n--- After Updating Bob's Grades ---"
    puts "Bob (S002): Old Grades: #{old_grades.join(', ')} → New Grades: #{s[2].join(', ')}"
  end
end

# 3. Removing a student (ID: S001 - Alice)
students.reject! { |s| s[1] == "S001" }
puts "\n--- After Removing Alice (S001) ---"
puts "Remaining students: #{students.map { |s| s[0] }.join(', ')}"

# 4. Calculating average for a specific student (Charlie - S003)
students.each do |s|
  if s[1] == "S003"
    avg = s[2].sum.to_f / s[2].length
    puts "\n--- Average for Charlie ---"
    puts "Average grade for #{s[0]}: #{avg.round(2)}"
  end
end

# 5. Slicing student list (first 2 students after removal)
subset = students[0..1]
puts "\n--- Subset of Students (first 2) ---"
subset.each do |s|
  avg = s[2].sum.to_f / s[2].length
  puts "#{s[0]} (ID: #{s[1]}) - Average Grade: #{avg.round(2)}"
end

# 6. Displaying complete gradebook with averages
puts "\n--- Complete Gradebook with Averages ---"
puts "-" * 60
students.each do |s|
  avg = s[2].sum.to_f / s[2].length
  puts "#{s[0]} | #{s[1]} | Grades: #{s[2].join(', ')} | Average: #{avg.round(2)}"
end
puts "-" * 60


# ==============================================================================
# PROBLEM 3: LIBRARY MANAGEMENT SYSTEM USING HASHES
# Aim: To design a library management system using hashes for efficient book storage.
#
# Books are stored in a hash using ISBN as the key and book details as values.
# The program allows adding, updating, removing, searching, and listing books.
# ==============================================================================

puts "\n\n" + "=" * 60
puts "PROBLEM 3: LIBRARY MANAGEMENT SYSTEM USING HASHES"
puts "=" * 60

# Initial library hash with ISBN as key
library = {
  "978-0143127741" => { title: "The Alchemist", author: "Paulo Coelho", copies: 5 },
  "978-0062315007" => { title: "Sapiens", author: "Yuval Noah Harari", copies: 3 },
  "978-0451524935" => { title: "1984", author: "George Orwell", copies: 4 }
}

puts "\n--- Initial Library Collection ---"
library.each do |isbn, data|
  puts "ISBN: #{isbn} | Title: #{data[:title]} | Author: #{data[:author]} | Copies: #{data[:copies]}"
end

# 1. Adding a new book
library["978-0735211292"] = {
  title: "Atomic Habits",
  author: "James Clear",
  copies: 7
}
puts "\n--- After Adding 'Atomic Habits' ---"
puts "Added: Atomic Habits by James Clear (ISBN: 978-0735211292) - #{library['978-0735211292'][:copies]} copies"

# 2. Updating an existing book's copies (Sapiens - ISBN: 978-0062315007)
library["978-0062315007"][:copies] = 5
puts "\n--- After Updating 'Sapiens' Copies ---"
puts "Sapiens (ISBN: 978-0062315007) - Updated copies: #{library['978-0062315007'][:copies]}"

# 3. Removing a book (1984 - ISBN: 978-0451524935)
library.delete("978-0451524935")
puts "\n--- After Removing '1984' ---"
puts "Removed book with ISBN: 978-0451524935"

# 4. Searching for a book by ISBN (The Alchemist)
book = library["978-0143127741"]
puts "\n--- Search Result for ISBN: 978-0143127741 ---"
if book
  puts "Title: #{book[:title]}"
  puts "Author: #{book[:author]}"
  puts "Copies Available: #{book[:copies]}"
else
  puts "Book not found"
end

# 5. Listing all books in the library
puts "\n--- Complete Library Collection ---"
puts "-" * 70
library.each do |isbn, data|
  puts "ISBN: #{isbn} | Title: #{data[:title]} | Author: #{data[:author]} | Copies: #{data[:copies]}"
end
puts "-" * 70

puts "\n" + "=" * 60
puts "END OF ALL PROBLEMS"
puts "=" * 60

# ==============================================================================
# PROBLEM 1: LIBRARY MANAGEMENT SYSTEM (CLASS INHERITANCE)
# Aim: To implement a library management system using class inheritance in Ruby.
#
# Class Hierarchy:
#   - LibraryItem (Base Class): title, author, publication_year
#   - Book < LibraryItem: isbn, number_of_pages
#   - DVD < LibraryItem: running_time, genre
#   - Magazine < LibraryItem: issue_number, publisher
# ==============================================================================

require 'date'

puts "=" * 60
puts "PROBLEM 1: LIBRARY MANAGEMENT SYSTEM (INHERITANCE)"
puts "=" * 60

class LibraryItem
  attr_accessor :title, :author, :publication_year

  def initialize(title, author, year)
    @title = title
    @author = author
    @publication_year = year
  end

  def due_date
    Date.today + 14
  end

  def display_details
    puts "Title: #{@title}"
    puts "Author: #{@author}"
    puts "Publication Year: #{@publication_year}"
  end
end

class Book < LibraryItem
  attr_accessor :isbn, :pages

  def initialize(title, author, year, isbn, pages)
    super(title, author, year)
    @isbn = isbn
    @pages = pages
  end

  def display_details
    super
    puts "ISBN: #{@isbn}"
    puts "Pages: #{@pages}"
    puts "Type: Book"
  end
end

class DVD < LibraryItem
  attr_accessor :running_time, :genre

  def initialize(title, author, year, running_time, genre)
    super(title, author, year)
    @running_time = running_time
    @genre = genre
  end

  def due_date
    Date.today + 7  # DVDs have shorter loan period
  end

  def display_details
    super
    puts "Running Time: #{@running_time} minutes"
    puts "Genre: #{@genre}"
    puts "Type: DVD"
  end
end

class Magazine < LibraryItem
  attr_accessor :issue_number, :publisher

  def initialize(title, author, year, issue, publisher)
    super(title, author, year)
    @issue_number = issue
    @publisher = publisher
  end

  def display_details
    super
    puts "Issue Number: #{@issue_number}"
    puts "Publisher: #{@publisher}"
    puts "Type: Magazine"
  end
end

puts "\n--- Library Item Creation & Display ---"
puts "1. Book\n2. DVD\n3. Magazine"
print "Choose item type (1-3): "
choice = gets.to_i

case choice
when 1
  book = Book.new("Ruby Guide", "Matz", 2023, "978-1234567890", 300)
  puts "\n--- Book Details ---"
  book.display_details
  puts "Due Date: #{book.due_date}"
when 2
  dvd = DVD.new("Inception", "Nolan", 2010, 148, "Sci-Fi")
  puts "\n--- DVD Details ---"
  dvd.display_details
  puts "Due Date: #{dvd.due_date}"
when 3
  mag = Magazine.new("Tech Today", "Editor", 2024, 5, "TechPub")
  puts "\n--- Magazine Details ---"
  mag.display_details
  puts "Due Date: #{mag.due_date}"
else
  puts "Invalid choice! Showing default Book instead."
  book = Book.new("Ruby Guide", "Matz", 2023, "978-1234567890", 300)
  puts "\n--- Book Details ---"
  book.display_details
  puts "Due Date: #{book.due_date}"
end


# ==============================================================================
# PROBLEM 2: E-COMMERCE PRODUCT SYSTEM (INHERITANCE & METHOD OVERRIDING)
# Aim: To develop an e-commerce product system using inheritance and method overriding.
#
# Class Hierarchy:
#   - Product (Base Class): name, price, description
#   - Book < Product: author, isbn
#   - Clothing < Product: size, color
# ==============================================================================

puts "\n\n" + "=" * 60
puts "PROBLEM 2: E-COMMERCE PRODUCT SYSTEM (INHERITANCE & OVERRIDING)"
puts "=" * 60

class Product
  attr_accessor :name, :price, :description

  def initialize(name, price, desc)
    @name = name
    @price = price
    @description = desc
  end

  def discount
    @price * 0.10  # 10% base discount
  end

  def discounted_price
    @price - discount
  end

  def display_details
    puts "Product: #{@name}"
    puts "Price: $#{'%.2f' % @price}"
    puts "Description: #{@description}"
    puts "Discount Amount: $#{'%.2f' % discount}"
    puts "Final Price: $#{'%.2f' % discounted_price}"
  end
end

class Book < Product
  attr_accessor :author, :isbn

  def initialize(name, price, desc, author, isbn)
    super(name, price, desc)
    @author = author
    @isbn = isbn
  end

  def discount
    @price * 0.20  # 20% discount for books
  end

  def display_details
    super
    puts "Author: #{@author}"
    puts "ISBN: #{@isbn}"
    puts "Category: Book"
  end
end

class Clothing < Product
  attr_accessor :size, :color

  def initialize(name, price, desc, size, color)
    super(name, price, desc)
    @size = size
    @color = color
  end

  def discount
    @price * 0.15  # 15% discount for clothing
  end

  def display_details
    super
    puts "Size: #{@size}"
    puts "Color: #{@color}"
    puts "Category: Clothing"
  end
end

puts "\n--- E-Commerce Product Selection ---"
puts "1. Book\n2. Clothing"
print "Choose product type (1-2): "
product_choice = gets.to_i

case product_choice
when 1
  b = Book.new("Ruby Programming", 500, "Complete guide to Ruby programming", "Matz", "978-1234567890")
  puts "\n--- Book Product Details ---"
  b.display_details
when 2
  c = Clothing.new("Premium T-Shirt", 800, "100% Cotton, Comfortable fit", "M", "Black")
  puts "\n--- Clothing Product Details ---"
  c.display_details
else
  puts "Invalid choice! Showing default Book instead."
  b = Book.new("Ruby Programming", 500, "Complete guide to Ruby programming", "Matz", "978-1234567890")
  puts "\n--- Book Product Details ---"
  b.display_details
end


# ==============================================================================
# PROBLEM 3: GAME CHARACTER SYSTEM (MIXINS)
# Aim: To implement a game character system using mixins in Ruby.
#
# Design (Mixins):
#   - Abilities Module: move, attack, defend
#   - Healing Module: heal
#   - Poison Module: poison
#   - LevelUp Module: level_up
# ==============================================================================

puts "\n\n" + "=" * 60
puts "PROBLEM 3: GAME CHARACTER SYSTEM (MIXINS)"
puts "=" * 60

module Abilities
  def move
    puts "  🚶 #{self.class.name} is moving"
  end

  def attack
    puts "  ⚔️  #{self.class.name} is attacking with full force!"
  end

  def defend
    puts "  🛡️  #{self.class.name} is defending against incoming attacks"
  end
end

module Healing
  def heal
    puts "  💚 #{self.class.name} uses healing magic! Health restored!"
  end
end

module Poison
  def poison
    puts "  ☠️  #{self.class.name} releases a deadly poison cloud!"
  end
end

module LevelUp
  def level_up
    puts "  🌟 #{self.class.name} leveled up! ⭐ Attack and Defense increased significantly!"
  end
end

class Hero
  include Abilities
  include Healing
  include LevelUp

  def initialize
    puts "✨ Hero created! A champion has entered the battlefield!"
  end

  def special_move
    puts "  🔥 #{self.class.name} performs ULTIMATE SLASH!"
  end
end

class Villain
  include Abilities
  include Poison
  include LevelUp

  def initialize
    puts "👿 Villain created! Darkness spreads across the land!"
  end

  def evil_laugh
    puts "  😈 MUAHAHAHA! You cannot defeat me!"
  end
end

class Monster
  include Abilities
  include LevelUp

  def initialize
    puts "👹 Monster created! A wild beast appears!"
  end

  def roar
    puts "  🦁 #{self.class.name} lets out a terrifying ROAR!"
  end
end

puts "\n--- Game Character Selection ---"
puts "1. Hero (Warrior of Light)"
puts "2. Villain (Lord of Darkness)"
puts "3. Monster (Fearsome Beast)"
print "Choose your character (1-3): "
char_choice = gets.to_i

puts "\n" + "-" * 40
puts "Character Actions:"
puts "-" * 40

case char_choice
when 1
  h = Hero.new
  puts "\n--- Hero Actions ---"
  h.move
  h.attack
  h.defend
  h.heal
  h.special_move
  h.level_up
when 2
  v = Villain.new
  puts "\n--- Villain Actions ---"
  v.move
  v.attack
  v.defend
  v.poison
  v.evil_laugh
  v.level_up
when 3
  m = Monster.new
  puts "\n--- Monster Actions ---"
  m.move
  m.attack
  m.defend
  m.roar
  m.level_up
else
  puts "Invalid choice! Showing default Hero instead."
  h = Hero.new
  puts "\n--- Hero Actions ---"
  h.move
  h.attack
  h.defend
  h.heal
  h.level_up
end

puts "\n" + "=" * 60
puts "END OF ALL OOP PROBLEMS"
puts "=" * 60
