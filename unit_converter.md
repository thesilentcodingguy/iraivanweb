
# ✅ 1. Create Rails API App

```bash
rails new unit_converter --api
cd unit_converter
```

---

# ✅ 2. Generate Controller

```bash
rails g controller api/conversions
```

---

# ✅ 3. Add Routes

`config/routes.rb`

```ruby
Rails.application.routes.draw do
  namespace :api do
    get 'convert', to: 'conversions#convert'
  end
end
```

---

# ✅ 4. Controller Logic

`app/controllers/api/conversions_controller.rb`

```ruby
module Api
  class ConversionsController < ApplicationController

    def convert
      value = params[:value].to_f
      type  = params[:type]

      case type
      when "length"
        result = value / 1000.0
        render json: {
          input: "#{value} meters",
          output: "#{result} kilometers"
        }, status: :ok

      when "mass"
        result = value / 1000.0
        render json: {
          input: "#{value} grams",
          output: "#{result} kilograms"
        }, status: :ok

      else
        render json: { error: "Invalid conversion type" }, status: :bad_request
      end

    end

  end
end
```

---

# ✅ 5. Test URLs

### ▶ Meter → Kilometer

```
GET /api/convert?value=1000&type=length
```

Response:

```json
{
  "input": "1000 meters",
  "output": "1.0 kilometers"
}
```

---

### ▶ Gram → Kilogram

```
GET /api/convert?value=5000&type=mass
```

Response:

```json
{
  "input": "5000 grams",
  "output": "5.0 kilograms"
}
```

---
