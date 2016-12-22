require 'mongo'
require 'BSON'
class HomeController < ApplicationController
  def index
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
    @articles = db[:articles].find()
    first = @articles.first["image"].data
    #p first
    buffer = BSON::ByteBuffer.new(first)
    #buffer = BSON::ByteBuffer.new(@articles.first["image"])
    @image_b = BSON::Binary.from_bson(buffer)
  end

  #def add
  #  @article = Article.new
  #  p @article.title
  #end

  def create
      @article = Article.new(params.require(:article).permit(:title, :author, :text, :image))

      db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
      articles = db[:articles]

      f = File.read(@article.image.tempfile, :mode => 'rb')
      img = BSON::Binary.new(f, :generic)
      #f = File.open(Rails.root.join('public', 'uploads', @article.image.original_filename), 'wb')
      #p f#@article.image.tempfile
      p @article.title
      p @article.author
      p @article.text
      tmp = {title: @article.title, author: @article.author, text: @article.text, image: img, comments: []}
      n = articles.insert_one(tmp)

      p "Ovo je broj spremljenih u bazu."

      p n
  end
end
