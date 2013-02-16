class Note < ActiveRecord::Base
  attr_accessible :client_id,
    :content,
    :user_id,
    :share_token

  belongs_to :user
  belongs_to :client

  validates :user, :content, presence: true

  def markdown_converted_content
    Redcarpet::Markdown.new(Redcarpet::Render::HTML).render(content).html_safe
  end

  def remove_share_token
    self.share_token = nil
  end

  def set_share_token
    self.share_token = SecureRandom.hex(20)
    save
  end

  def is_shared?
    share_token != nil && share_token.length != 0
  end

  def share_link
    Rails.application.routes.url_helpers.public_note_url(self, host: ENV['ZDOMAIN'], t: self.share_token)
  end

  def unshare!
    self.share_token = nil
    save
  end

end
