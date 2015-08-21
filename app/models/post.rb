class Post < ActiveRecord::Base
  validates :title, :author, presence: true
  validate :has_at_least_one_sub

  # belongs_to :sub
  belongs_to :author,
    class_name: "User",
    foreign_key: :author_id

  has_many :post_subs, inverse_of: :post

  has_many :subs,
    through: :post_subs,
    source: :sub

  has_many :comments, inverse_of: :post

  def comments_by_parent_id
    comment_hash = Hash.new { |h, k| h[k] = [] }
    comments.each do |comment|
      comment_hash[comment.parent_comment_id] << comment
    end
    # p comment_hash
    comment_hash
  end

  private
  def has_at_least_one_sub
    return unless subs.empty?
    errors[:post] << "must have at least one sub"
  end

end
