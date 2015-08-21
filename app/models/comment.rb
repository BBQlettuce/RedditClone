class Comment < ActiveRecord::Base
  validates :author, :post, presence: true

  belongs_to :author,
    class_name: "User",
    foreign_key: :author_id

  belongs_to :post

  has_many :child_comments,
    class_name: "Comment",
    foreign_key: :parent_comment_id,
    inverse_of: :parent_comment,
    dependent: :destroy

  belongs_to :parent_comment,
    class_name: "Comment",
    foreign_key: :parent_comment_id
end
