class Note < ActiveRecord::Base
  attr_accessible :client_id,
    :content,
    :user_id

  belongs_to :user
  belongs_to :client

  validates :user, presence: true

  def markdown_converted_content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content).html_safe
  end
end
