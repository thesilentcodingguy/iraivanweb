class CalculatorController < ApplicationController
  def index
  end

  def calculate
    @num1 = params[:num1].to_f
    @num2 = params[:num2].to_f
    @operation = params[:operation]

    begin
      @result = case @operation
                when "+"
                  @num1 + @num2
                when "-"
                  @num1 - @num2
                when "*"
                  @num1 * @num2
                when "/"
                  raise "Cannot divide by zero" if @num2 == 0
                  @num1 / @num2
                else
                  "Invalid operation"
                end
    rescue => e
      @error = e.message
    end

    render :index
  end
end