Got it — this is basically a **minimal forum app with authentication + authorization**. I’ll keep it **simple, clean, scaffold-heavy**, and step-by-step.

---

# 🚀 1. Create Rails App

```bash
rails new forum_app
cd forum_app
bundle install
rails db:create
```

---

# 🔐 2. Add Authentication (Login System)

Use **Devise** (fastest + standard)

### Add gem

```bash
bundle add devise
rails generate devise:install
```

### Generate User

```bash
rails generate devise User
rails db:migrate
```

👉 Now you already have:

* Sign up
* Login
* Logout

---

# 🧱 3. Create Post Model (Scaffold)

```bash
rails generate scaffold Post title:string content:text user:references
rails db:migrate
```

👉 This gives:

* CRUD routes
* Controller
* Views

---

# 🔗 4. Setup Association

### `app/models/user.rb`

```ruby
has_many :posts, dependent: :destroy
```

### `app/models/post.rb`

```ruby
belongs_to :user
```

---

# 🔒 5. Restrict Access (Login Required)

### `app/controllers/posts_controller.rb`

Add:

```ruby
before_action :authenticate_user!
```

---

# ✍️ 6. Assign Post to Logged-in User

In `create`:

```ruby
@post = current_user.posts.build(post_params)
```

---

# 👀 7. Show ONLY Others' Posts (Forum Page)

Modify `index`:

```ruby
def index
  @posts = Post.where.not(user_id: current_user.id)
end
```

👉 This ensures:

* User **does NOT see their own posts**

---

# 🧑‍💻 8. Show Username with Post

In views (`index.html.erb`):

```erb
<p><strong><%= post.title %></strong></p>
<p><%= post.content %></p>
<p>By: <%= post.user.email %></p>
```

---

# ❌ 9. Allow Delete ONLY Own Posts

### Controller:

```ruby
before_action :set_post, only: [:show, :edit, :update, :destroy]
before_action :authorize_user!, only: [:destroy, :edit, :update]

def authorize_user!
  redirect_to posts_path, alert: "Not allowed" unless @post.user == current_user
end
```

---

# 🧾 10. “My Posts” Page

### Add route

```ruby
get "my_posts", to: "posts#my_posts"
```

### Controller:

```ruby
def my_posts
  @posts = current_user.posts
end
```

### Create view:

`app/views/posts/my_posts.html.erb`

```erb
<h1>My Posts</h1>

<% @posts.each do |post| %>
  <p><%= post.title %></p>
  <%= link_to "Delete", post, method: :delete %>
<% end %>
```

---

# 🔗 11. Navigation Links

In layout (`application.html.erb`):

```erb
<% if user_signed_in? %>
  <%= link_to "Forum", posts_path %> |
  <%= link_to "My Posts", my_posts_path %> |
  <%= link_to "New Post", new_post_path %> |
  <%= link_to "Logout", destroy_user_session_path, method: :delete %>
<% else %>
  <%= link_to "Login", new_user_session_path %> |
  <%= link_to "Sign Up", new_user_registration_path %>
<% end %>
```

---

# 🧹 12. Remove Edit Option (Optional Minimal)

If you want strict minimal:

* Remove `edit/update` routes
* Only allow `create + delete`

---

# ⚡ Final Flow

✔ User logs in
✔ Sees **posts from others only**
✔ Can:

* View post
* Create post
  ✔ Cannot delete others’ posts
  ✔ Can delete own posts in **My Posts page**

---
