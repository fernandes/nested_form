class Track < ApplicationRecord
  belongs_to :album
  default_scope { order(:order) }
end
