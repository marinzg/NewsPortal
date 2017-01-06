class Article# < ActiveRecord::Base
  attr_accessor :title
  attr_accessor :author
  attr_accessor :text
  attr_accessor :image
  attr_accessor :timeSort

  def initialize(article)
    self.title = article["title"]
    self.author = article["author"]
    self.text = article["text"]
    self.image = article["image"]
    self.timeSort = article["timeSort"]
  end
end
