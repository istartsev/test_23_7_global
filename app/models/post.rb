class Post < ApplicationRecord
  include NotDeleted

  belongs_to :user
  has_many :likes
end
