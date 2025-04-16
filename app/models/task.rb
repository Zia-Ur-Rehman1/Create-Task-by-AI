class Task < ApplicationRecord
  belongs_to :user

  validates :title, presence: true
  validates :description, presence: true

  scope :search, ->(query) { where("title LIKE ?", "%#{query}%") }
end
