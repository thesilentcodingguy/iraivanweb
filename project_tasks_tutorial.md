

# 🧱 Step 1: Create Rails App

```bash
rails new project_manager
cd project_manager
bundle install
rails db:create
```

---

# ⚙️ Step 2: Generate Project Scaffold

```bash
rails generate scaffold Project name:string description:text
```

---

# ⚙️ Step 3: Generate Task Scaffold (with relation)

```bash
rails generate scaffold Task title:string details:text project:references
```

👉 `project:references` automatically creates:

* `project_id` column
* Foreign key relationship

---

# 🗄️ Step 4: Run Migration

```bash
rails db:migrate
```

---

# 🔗 Step 5: Add Model Relationships

### `app/models/project.rb`

```ruby
class Project < ApplicationRecord
  has_many :tasks, dependent: :destroy
end
```

### `app/models/task.rb`

```ruby
class Task < ApplicationRecord
  belongs_to :project
end
```

---

# 🌐 Step 6: Set Routes

Open `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  resources :projects do
    resources :tasks
  end

  root "projects#index"
end
```

---

# 🎮 Step 7: Run Server

```bash
rails server
```

Visit:

```
http://localhost:3000
```

---

# 🔥 What You Get (Automatically via Scaffold)

### ✅ Projects

* Create project
* View project
* Edit project
* Delete project

### ✅ Tasks

* Create task
* View task
* Edit task
* Delete task

---

# 🧠 Important Concept (Exam Gold)

### Relationship:

* One-to-Many

```
Project → has_many → Tasks
Task → belongs_to → Project
```

### Database Structure:

* `projects` table
* `tasks` table with `project_id`

---

# ✨ Optional (Nice Touch – show tasks inside project)

Edit:

### `app/controllers/projects_controller.rb`

Inside `show`:

```ruby
@tasks = @project.tasks
```

Then in:

### `app/views/projects/show.html.erb`

```erb
<h2>Tasks</h2>

<%= link_to "Add Task", new_project_task_path(@project) %>

<ul>
  <% @tasks.each do |task| %>
    <li>
      <%= task.title %> -
      <%= link_to "Show", [@project, task] %>
    </li>
  <% end %>
</ul>
```

---
