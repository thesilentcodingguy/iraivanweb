

# 🧱 1. Create App

```bash
rails new event_manager
cd event_manager
bundle install
rails db:create
```

---

# ⚙️ 2. Generate Scaffolds

### Event

```bash
rails generate scaffold Event name:string date:date location:string
```

### Registration (linked to Event)

```bash
rails generate scaffold Registration participant_name:string email:string event:references
```

---

# 🗄️ 3. Migrate Database

```bash
rails db:migrate
```

---

# 🔗 4. Add Relationships

### `app/models/event.rb`

```ruby
class Event < ApplicationRecord
  has_many :registrations, dependent: :destroy
end
```

### `app/models/registration.rb`

```ruby
class Registration < ApplicationRecord
  belongs_to :event
end
```

---

# 🌐 5. Routes (Nested)

Edit `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  resources :events do
    resources :registrations
  end

  root "events#index"
end
```

---

# 🎮 6. Run App

```bash
rails server
```

👉 Open:
`http://localhost:3000`

---

# ✨ 7. Improve UI (IMPORTANT for marks)

## Show registrations inside Event

### Edit: `app/controllers/events_controller.rb`

```ruby
def show
  @registrations = @event.registrations
end
```

---

### Edit: `app/views/events/show.html.erb`

```erb
<p>
  <strong>Name:</strong>
  <%= @event.name %>
</p>

<p>
  <strong>Date:</strong>
  <%= @event.date %>
</p>

<p>
  <strong>Location:</strong>
  <%= @event.location %>
</p>

<hr>

<h2>Registrations</h2>

<%= link_to "Register Participant", new_event_registration_path(@event) %>

<ul>
  <% @registrations.each do |r| %>
    <li>
      <%= r.participant_name %> (<%= r.email %>)
      |
      <%= link_to "Show", [@event, r] %>
      <%= link_to "Edit", edit_event_registration_path(@event, r) %>
      <%= link_to "Delete", [@event, r], method: :delete, data: { confirm: "Are you sure?" } %>
    </li>
  <% end %>
</ul>
```

---

# 🔒 8. Auto-assign Event (VERY IMPORTANT)

When creating registration, it should automatically attach to event.

### Edit: `app/controllers/registrations_controller.rb`

#### Update `new`

```ruby
def new
  @event = Event.find(params[:event_id])
  @registration = @event.registrations.build
end
```

#### Update `create`

```ruby
def create
  @event = Event.find(params[:event_id])
  @registration = @event.registrations.build(registration_params)

  if @registration.save
    redirect_to @event, notice: "Registration successful."
  else
    render :new
  end
end
```

---

# 🧠 9. Strong Params (keep default)

```ruby
def registration_params
  params.require(:registration).permit(:participant_name, :email)
end
```


<%= form_with(model: [@event, registration]) do |form| %>
def edit
  @event = Event.find(params[:event_id])
end


Edit: app/views/registrations/new.html.erb
<%= link_to "Back to Event", event_path(@event) %>

