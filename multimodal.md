

# 🧩 1. Create Project

```bash
rails new library_app
cd library_app
bundle install
rails db:create
```

---

# 📚 2. Generate Scaffolds

### 1. Book

```bash
rails g scaffold Book title:string author:string available:boolean
```

### 2. Borrower

```bash
rails g scaffold Borrower name:string email:string
```

### 3. Borrowing (relation)

```bash
rails g scaffold Borrowing book:references borrower:references borrow_date:date return_date:date
```

---

# 🛠 3. Run Migrations

```bash
rails db:migrate
```

---

# 🔗 4. Setup Associations (IMPORTANT)

### 📘 `app/models/book.rb`

```ruby
class Book < ApplicationRecord
  has_many :borrowings
  has_many :borrowers, through: :borrowings
end
```

### 👤 `app/models/borrower.rb`

```ruby
class Borrower < ApplicationRecord
  has_many :borrowings
  has_many :books, through: :borrowings
end
```

### 🔄 `app/models/borrowing.rb`

```ruby
class Borrowing < ApplicationRecord
  belongs_to :book
  belongs_to :borrower
end
```

---

# 🎯 5. Routes (already added)

Check:

```ruby
resources :books
resources :borrowers
resources :borrowings
```

---

# ▶️ 6. Run Server

```bash
rails s
```

Open:

```
http://localhost:3000
```

---

# 🧪 7. What You Can Do (CRUD)

### Books

* Add book
* Edit book
* Delete book

### Borrowers

* Add user
* Edit
* Delete

### Borrowings

* Select **book + borrower**
* Add borrow_date & return_date

---

# ⚡ 8. Make it Slightly Smarter (Optional but good for exam)

### Auto mark book unavailable when borrowed

In `borrowing.rb`:

```ruby
after_create :mark_book_unavailable

def mark_book_unavailable
  book.update(available: false)
end
```

### When returned → available

```ruby
after_update :mark_book_available

def mark_book_available
  if return_date.present?
    book.update(available: true)
  end
end
```

---

# 🧼 9. Simple UI Improvement (Optional)

In Borrowing form:

* Replace book_id with dropdown
* Replace borrower_id with dropdown

Edit:
`app/views/borrowings/_form.html.erb`

```erb
<%= form.collection_select :book_id, Book.all, :id, :title %>
<%= form.collection_select :borrower_id, Borrower.all, :id, :name %>
```

---

Nice, this is exactly what makes your project look **complete in a lab exam** 👌 — a simple home page + buttons.

We’ll keep it **clean + minimal**, no heavy CSS.

---

# 🏠 1. Create Home Controller

```bash
rails g controller Home index
```

---

# 🔗 2. Set Root Route

In `config/routes.rb`:

```ruby
root "home#index"
```

---

# 🎨 3. Home Page UI (Buttons)


Add inline CSS (keep it simple for exam):

```erb
<h1 style="text-align:center;">📚 Library Management System</h1>

<div style="text-align:center; margin-top:30px;">
  <%= link_to "Add Book", new_book_path, style: "padding:10px; background:#4CAF50; color:white; text-decoration:none; margin:5px;" %>

  <%= link_to "Borrow Book", new_borrowing_path, style: "padding:10px; background:#2196F3; color:white; text-decoration:none; margin:5px;" %>
</div>

<br>

<div style="text-align:center;">
  <%= link_to "View Books", books_path %> |
  <%= link_to "View Borrowers", borrowers_path %> |
  <%= link_to "View Borrowings", borrowings_path %>
</div>
```

---

# 📝 5. Improve Forms (VERY IMPORTANT)

Edit:
`app/views/borrowings/_form.html.erb`

Replace ID inputs with dropdowns:

```erb
<div>
  <%= form.label :book_id %>
  <%= form.collection_select :book_id, Book.all, :id, :title %>
</div>

<div>
  <%= form.label :borrower_id %>
  <%= form.collection_select :borrower_id, Borrower.all, :id, :name %>
</div>

<div>
  <%= form.label :borrow_date %>
  <%= form.date_field :borrow_date %>
</div>

<div>
  <%= form.label :return_date %>
  <%= form.date_field :return_date %>
</div>

<div>
  <%= form.submit %>
</div>
```

---

# 🔙 6. Add “Back to Home” Everywhere

Add this at top of each index/show page:

```erb
<%= link_to "🏠 Home", root_path %>
<hr>
```

---

# 🎯 Final Output

At `localhost:3000/` you’ll see:

* 📚 Title
* ✅ Add Book button
* ✅ Borrow Book button
* Links to view everything

---
