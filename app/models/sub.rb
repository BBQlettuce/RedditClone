class Sub < ActiveRecord::Base
  validates :title, presence: true
  validates :moderator, presence: true

  belongs_to :moderator,
    class_name: "User",
    foreign_key: :moderator_id

  has_many :posts,
    through: :post_subs,
    source: :post

  has_many :post_subs, inverse_of: :sub
end
