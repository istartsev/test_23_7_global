class Post < ApplicationRecord
  include NotDeleted

  belongs_to :user

  validates :title, presence: true, length: {minimum: 4}
  validates :body, presence: true, length: {minimum: 6}
  validates :likes_count, presence: true, length: {minimum: 0}
  validates :user_id, presence: true
  validates :status, presence: true
end
