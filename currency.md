Alright — you want a **clean Rails API**, using mostly **scaffold + one extra method**, and tested via **JSON (Postman)** without messy query params. Let’s build this the *proper minimal way*.

---

# 🚀 1. Create API-only Rails App

```bash
rails new currency_api --api
cd currency_api
bundle install
```

---

# 🧱 2. Generate Scaffold (Conversions)

You said you want `resources :conversions`, so:

```bash
rails g scaffold Conversion amount:float from_currency:string to_currency:string result:float
rails db:migrate
```

This gives you:

* Model
* Controller
* Routes (`resources :conversions`)
* JSON-ready endpoints

---

# 🔧 3. Add Exchange Logic (Extra Function)

Open:

```bash
app/controllers/conversions_controller.rb
```

Modify it like this 👇

```ruby
class ConversionsController < ApplicationController
  before_action :set_conversion, only: %i[ show ]

  # Static exchange rates (base: USD)
  RATES = {
    "USD" => 1.0,
    "EUR" => 0.9,
    "GBP" => 0.8,
    "JPY" => 110.0,
    "INR" => 83.0
  }

  # POST /conversions
  def create
    @conversion = Conversion.new(conversion_params)

    if valid_currency?(@conversion.from_currency) && valid_currency?(@conversion.to_currency)
      @conversion.result = convert_currency(
        @conversion.amount,
        @conversion.from_currency,
        @conversion.to_currency
      )

      if @conversion.save
        render json: @conversion, status: :created
      else
        render json: @conversion.errors, status: :unprocessable_entity
      end
    else
      render json: { error: "Invalid currency" }, status: :bad_request
    end
  end

  # GET /conversions/:id
  def show
    render json: @conversion
  end

  private

  def set_conversion
    @conversion = Conversion.find(params[:id])
  end

  def conversion_params
    params.require(:conversion).permit(:amount, :from_currency, :to_currency)
  end

  # ✅ Extra function (your requirement)
  def convert_currency(amount, from, to)
    usd_amount = amount / RATES[from]
    usd_amount * RATES[to]
  end

  def valid_currency?(currency)
    RATES.key?(currency)
  end
end
```

---

# 🛣️ 4. Routes (Keep It Clean)

In:

```ruby
config/routes.rb
```

```ruby
Rails.application.routes.draw do
  resources :conversions, only: [:create, :show]
end
```

✔ No long URLs
✔ No `/convert?amount=...`
✔ Only clean REST endpoints

---

# 📮 5. Test in Postman (JSON Only)

## 🔹 POST Request

```
POST http://localhost:3000/conversions
```

### Body (JSON)

```json
{
  "conversion": {
    "amount": 100,
    "from_currency": "USD",
    "to_currency": "INR"
  }
}
```

### Response

```json
{
  "id": 1,
  "amount": 100.0,
  "from_currency": "USD",
  "to_currency": "INR",
  "result": 8300.0,
  "created_at": "...",
  "updated_at": "..."
}
```

---

## 🔹 GET Request

```
GET http://localhost:3000/conversions/1
```

✔ Returns same JSON
✔ No query params needed

---


If you want, I can also give you a **no-database version (pure controller API)** — even cleaner for exams 🔥
