class Post < ApplicationRecord
  include NotDeleted

  belongs_to :user
  has_many :likes

  validates :comment, presence: true, length: {minimum: 4}
  validates :body, presence: true, length: {minimum: 6}
  validates :user_id, presence: true
end
