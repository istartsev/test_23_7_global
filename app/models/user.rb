class User < ApplicationRecord
  include NotDeleted

  has_many :posts
  has_many :likes

  validates :username, presence: true, length: {minimum: 4, maximum: 16}
  validates :password, presence: true, length: {minimum: 6, maximum: 16}
end
