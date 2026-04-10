class Recipe < ApplicationRecord
  belongs_to :user
  has_many :comments, dependent: :destroy
end

class User < ApplicationRecord
  has_many :recipes, dependent: :destroy
  has_many :comments, dependent: :destroy
end
