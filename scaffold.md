When you run a scaffold in Ruby on Rails like:

```
rails g scaffold Student name:string age:integer email:string
```

Rails auto-generates a full CRUD setup. Let’s break it cleanly 👇

---

# 🔧 Files Generated (for `Student`)

## 1. Model

**`app/models/student.rb`**

```ruby
class Student < ApplicationRecord
end
```

👉 Handles DB logic (ActiveRecord)

---

## 2. Migration

**`db/migrate/xxxx_create_students.rb`**

```ruby
class CreateStudents < ActiveRecord::Migration[7.0]
  def change
    create_table :students do |t|
      t.string :name
      t.integer :age
      t.string :email

      t.timestamps
    end
  end
end
```

👉 Creates table in DB

---

## 3. Controller

**`app/controllers/students_controller.rb`**

```ruby
class StudentsController < ApplicationController
  before_action :set_student, only: %i[ show edit update destroy ]

  def index
    @students = Student.all
  end

  def show
  end

  def new
    @student = Student.new
  end

  def edit
  end

  def create
    @student = Student.new(student_params)

    if @student.save
      redirect_to @student
    else
      render :new
    end
  end

  def update
    if @student.update(student_params)
      redirect_to @student
    else
      render :edit
    end
  end

  def destroy
    @student.destroy
    redirect_to students_url
  end

  private

  def set_student
    @student = Student.find(params[:id])
  end

  def student_params
    params.require(:student).permit(:name, :age, :email)
  end
end
```

👉 Full CRUD logic

---

## 4. Views (UI files)

📁 `app/views/students/`

### index.html.erb

```erb
<h1>Students</h1>

<%= link_to "New Student", new_student_path %>

<% @students.each do |student| %>
  <p>
    <%= student.name %>
    <%= link_to "Show", student %>
    <%= link_to "Edit", edit_student_path(student) %>
    <%= link_to "Delete", student, method: :delete %>
  </p>
<% end %>
```

---

### show.html.erb

```erb
<p>
  <strong>Name:</strong>
  <%= @student.name %>
</p>

<%= link_to "Edit", edit_student_path(@student) %>
<%= link_to "Back", students_path %>
```

---

### new.html.erb & edit.html.erb

```erb
<h1>New Student</h1>
<%= render "form", student: @student %>
```

---

### _form.html.erb (partial)

```erb
<%= form_with(model: student) do |form| %>
  <div>
    <%= form.label :name %>
    <%= form.text_field :name %>
  </div>

  <div>
    <%= form.label :age %>
    <%= form.number_field :age %>
  </div>

  <div>
    <%= form.label :email %>
    <%= form.text_field :email %>
  </div>

  <%= form.submit %>
<% end %>
```

---

## 5. Routes

**`config/routes.rb`**

```ruby
Rails.application.routes.draw do
  resources :students
end
```

👉 Generates routes like:

```
GET    /students
GET    /students/:id
POST   /students
PATCH  /students/:id
DELETE /students/:id
```

---

## 6. Helper

**`app/helpers/students_helper.rb`**

```ruby
module StudentsHelper
end
```

---

## 7. Tests (optional but generated)

* `test/models/student_test.rb`
* `test/controllers/students_controller_test.rb`
* Fixtures

---

## 8. Assets (if not API-only)

* CSS + JS files for students

---
