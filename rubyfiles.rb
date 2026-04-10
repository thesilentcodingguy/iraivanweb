class Book
  attr_accessor :isbn, :name, :author, :available

  def initialize(isbn, name, author, available)
    @isbn = isbn
    @name = name
    @author = author
    @available = available
  end
end

# Load books from file
def load_books
  books = []
  if File.exist?("books.txt")
    File.readlines("books.txt").each do |line|
      isbn, name, author, available = line.chomp.split(",")
      books << Book.new(isbn, name, author, available == "true")
    end
  end
  books
end

# Save books to file
def save_books(books)
  File.open("books.txt", "w") do |file|
    books.each do |b|
      file.puts "#{b.isbn},#{b.name},#{b.author},#{b.available}"
    end
  end
end

# View books
def view_books(books)
  puts "\n--- Library Books ---"
  books.each do |b|
    status = b.available ? "Available" : "Not Available"
    puts "#{b.isbn} | #{b.name} | #{b.author} | #{status}"
  end
end

# Add book
def add_book(books)
  print "Enter ISBN: "
  isbn = gets.chomp
  print "Enter Name: "
  name = gets.chomp
  print "Enter Author: "
  author = gets.chomp

  books << Book.new(isbn, name, author, true)
  puts "Book added successfully!"
end

# Find book by ISBN
def find_book(books, isbn)
  books.find { |b| b.isbn == isbn }
end

# Borrow book
def borrow_book(books)
  print "Enter ISBN to borrow: "
  isbn = gets.chomp

  book = find_book(books, isbn)

  if book
    if book.available
      book.available = false
      puts "Book borrowed successfully!"
    else
      puts "Book is not available!"
    end
  else
    puts "Book not found!"
  end
end

# Return book
def return_book(books)
  print "Enter ISBN to return: "
  isbn = gets.chomp

  book = find_book(books, isbn)

  if book
    book.available = true
    puts "Book returned successfully!"
  else
    puts "Book not found!"
  end
end

# ---------------- MAIN PROGRAM ----------------

books = load_books

loop do
  puts "\n===== Library Menu ====="
  puts "1. View Books"
  puts "2. Add Book"
  puts "3. Borrow Book"
  puts "4. Return Book"
  puts "5. Exit"
  print "Enter choice: "

  choice = gets.chomp.to_i

  case choice
  when 1
    view_books(books)
  when 2
    add_book(books)
    save_books(books)
  when 3
    borrow_book(books)
    save_books(books)
  when 4
    return_book(books)
    save_books(books)
  when 5
    save_books(books)
    puts "Exiting... Thank you!"
    break
  else
    puts "Invalid choice!"
  end
end
