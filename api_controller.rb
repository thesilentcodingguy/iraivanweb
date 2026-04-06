class BooksController < ApplicationController
  # GET /books
  def index
    @books = Book.all
    render json: @books
  end

  # GET /books/:id
  def show
    @book = Book.find_by(id: params[:id])
    
    if @book
      render json: @book
    else
      render json: { error: 'Book not found' }, status: :not_found
    end
  end

  # POST /books
  def create
    @book = Book.new(book_params)
    
    if @book.save
      render json: @book, status: :created
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PUT/PATCH /books/:id
  def update
    @book = Book.find_by(id: params[:id])
    
    if @book.nil?
      render json: { error: 'Book not found' }, status: :not_found
      return
    end
    
    if @book.update(book_params)
      render json: @book
    else
      render json: { errors: @book.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /books/:id
  def destroy
    @book = Book.find_by(id: params[:id])
    
    if @book.nil?
      render json: { error: 'Book not found' }, status: :not_found
      return
    end
    
    @book.destroy
    render json: { message: 'Book successfully deleted' }, status: :ok
  end

  private

  def book_params
    params.permit(:title, :author, :price, :published_date)
  end
end


#MODEL
class Book < ApplicationRecord
  validates :title, presence: true
  validates :author, presence: true
  validates :price, presence: true, numericality: { greater_than: 0 }
  validates :published_date, presence: true
end
