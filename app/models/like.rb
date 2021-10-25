class Like < ApplicationRecord
  include NotDeleted

  self.primary_keys = :user_id, :post_id

  belongs_to :user
end
