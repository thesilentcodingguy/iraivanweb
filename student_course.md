

# ✅ 1. Create Project

```bash
rails new student_course_app
cd student_course_app
```

---

# ✅ 2. Generate Scaffolds

```bash
rails g scaffold Student name:string email:string
rails g scaffold Course name:string instructor:string
rails g scaffold Lesson name:string description:text course:references
rails g scaffold Enrollment student:references course:references
```

---

# ✅ 3. Migrate

```bash
rails db:migrate
```

---

# ✅ 4. Define Relationships (VERY IMPORTANT 🔥)

### `app/models/student.rb`

```ruby
class Student < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :courses, through: :enrollments
end
```

---

### `app/models/course.rb`

```ruby
class Course < ApplicationRecord
  has_many :enrollments, dependent: :destroy
  has_many :students, through: :enrollments
  has_many :lessons, dependent: :destroy
end
```

---

### `app/models/lesson.rb`

```ruby
class Lesson < ApplicationRecord
  belongs_to :course
end
```

---

### `app/models/enrollment.rb`

```ruby
class Enrollment < ApplicationRecord
  belongs_to :student
  belongs_to :course

  # 🚫 Prevent duplicate enrollment
  validates :student_id, uniqueness: { scope: :course_id, message: "already enrolled in this course" }
end
```

---

# ✅ 5. Update Routes

```ruby
Rails.application.routes.draw do
  resources :students
  resources :courses do
    resources :lessons
  end
  resources :enrollments
end
```

---

# ✅ 6. Enrollment Form (Dropdown instead of IDs 🔥)

Edit: `app/views/enrollments/_form.html.erb`

```erb
<div>
  <%= form.label :student_id %>
  <%= form.collection_select :student_id, Student.all, :id, :name %>
</div>

<div>
  <%= form.label :course_id %>
  <%= form.collection_select :course_id, Course.all, :id, :name %>
</div>
```

---

# ✅ 7. Show Success / Failure Message

Edit: `app/controllers/enrollments_controller.rb`

```ruby
def create
  @enrollment = Enrollment.new(enrollment_params)

  if @enrollment.save
    redirect_to @enrollment, notice: "Enrollment successful"
  else
    redirect_to enrollments_path, alert: @enrollment.errors.full_messages.join(", ")
  end
end
```

---

# ✅ 8. Display Data

## ▶ Show all students

`/students`

## ▶ Show all courses

`/courses`

---

## ▶ Show lessons under course

Edit: `app/views/courses/show.html.erb`

```erb
<h3>Lessons</h3>

<% @course.lessons.each do |lesson| %>
  <p>
    <strong><%= lesson.name %></strong> - <%= lesson.description %>
  </p>
<% end %>
```

---

## ▶ Show enrolled students in a course

```erb
<h3>Enrolled Students</h3>

<% @course.students.each do |student| %>
  <p><%= student.name %></p>
<% end %>
```

---
