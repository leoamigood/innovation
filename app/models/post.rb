class Post < ApplicationRecord
  include Discard::Model

  attribute :palette, Palette.to_type

  validates :title, :body, presence: true
end
