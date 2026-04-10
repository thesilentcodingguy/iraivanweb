
# ✅ 1. Create API-only Rails App

```bash
rails new college_api --api
cd college_api
```

---

# ✅ 2. Generate Scaffold

```bash
rails g scaffold Student name:string email:string course:string year_of_study:integer
```

---

# ✅ 3. Run Migration

```bash
rails db:migrate
```

---

# ✅ 4. Add Validations (Model)

Edit: `app/models/student.rb`

```ruby
class Student < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :course, presence: true
  validates :year_of_study, presence: true, numericality: { only_integer: true }

  # Scope for search
  scope :by_course, ->(course) { where(course: course) }
end
```

---

# ✅ 5. Create API Namespace

Edit: `config/routes.rb`

```ruby
Rails.application.routes.draw do
  namespace :api do
    resources :students do
      collection do
        get :search
      end
    end
  end
end
```

---

# ✅ 6. Move Controller to API Namespace

Move file:

```
app/controllers/students_controller.rb
➡ app/controllers/api/students_controller.rb
```

Then update:

```ruby
module Api
  class StudentsController < ApplicationController
```

---

# ✅ 7. Modify Controller (JSON + Error Handling)

Edit: `app/controllers/api/students_controller.rb`

```ruby
module Api
  class StudentsController < ApplicationController
    before_action :set_student, only: [:show, :update, :destroy]

    # GET /api/students
    def index
      students = Student.all
      render json: students, status: :ok
    end

    # GET /api/students/:id
    def show
      render json: @student, status: :ok
    end

    # POST /api/students
    def create
      student = Student.new(student_params)
      if student.save
        render json: student, status: :created
      else
        render json: { errors: student.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # PATCH/PUT /api/students/:id
    def update
      if @student.update(student_params)
        render json: @student, status: :ok
      else
        render json: { errors: @student.errors.full_messages }, status: :unprocessable_entity
      end
    end

    # DELETE /api/students/:id
    def destroy
      @student.destroy
      render json: { message: "Deleted successfully" }, status: :ok
    end

    # 🔍 Custom Search
    # GET /api/students/search?course=ECE
    def search
      if params[:course].present?
        students = Student.by_course(params[:course])
        render json: students, status: :ok
      else
        render json: { error: "Course parameter missing" }, status: :bad_request
      end
    end

    private

    def set_student
      @student = Student.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: "Student not found" }, status: :not_found
    end

    def student_params
      params.require(:student).permit(:name, :email, :course, :year_of_study)
    end
  end
end
```

---

# ✅ 8. Test API (Important for Viva 💯)

### ▶ Start Server

```bash
rails s
```

---

### ▶ Sample Requests

**1. Create Student (POST)**

```bash
POST /api/students
```

Body:

```json
{
  "student": {
    "name": "Anirudh",
    "email": "ani@gmail.com",
    "course": "ECE",
    "year_of_study": 3
  }
}
```

---

**2. Get All Students**

```
GET /api/students
```

---

**3. Get One Student**

```
GET /api/students/1
```

---

**4. Update**

```
PATCH /api/students/1
```

---

**5. Delete**

```
DELETE /api/students/1
```

---

**6. Search**

```
GET /api/students/search?course=ECE
```

---
