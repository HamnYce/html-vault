require "active_support/core_ext/string/inflections"

class Snippet < ActiveRecord::Base
  before_validation :generate_slug_from_title,
    if: ->(snippet) { !snippet.slug || snippet.slug.empty? }
  validates :slug, uniqueness: true, presence: true
  validates :title, presence: true
  validates :html_content, presence: true

  def tag_list
    tags.split(",").map(&:strip).reject { |tag| tag.blank? }
  end

  private

  # generates the slug using the title if it is empty
  def generate_slug_from_title
    self.slug = title.parameterize
  end
end
