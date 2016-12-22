class Article# < ActiveRecord::Base
  attr_accessor :title
  attr_accessor :author
  attr_accessor :text
  attr_accessor :image

  def initialize(article)
    self.title = article["title"]
    self.author = article["author"]
    self.text = article["text"]
    self.image = article["image"]
  end
end
