require 'mongo'
require 'BSON'
class HomeController < ApplicationController
  def index
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
    @articles = db[:articles].find().sort({_id:-1}).limit(10)
    db.close
  end

  #def add
  #  @article = Article.new
  #  p @article.title
  #end

  def create
      @article = Article.new(params.require(:article).permit(:title, :author, :text, :image))

      exstension = @article.image.content_type.split('/')[1]
      tmp = {title: @article.title, author: @article.author, text: @article.text, comments: []}

      db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
      articles = db[:articles]

      id = articles.insert_one(tmp).inserted_id.to_s
      file = File.open("app/assets/stylesheets/" + id + "." +  exstension, 'wb') {|f| f.write(@article.image.read) }
      db.close
  end

  def comment
    j = ActiveSupport::JSON
    id = params["id"]
    comment = params["comment"]
    timestamp = Time.now


    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
    articles = db[:articles]
    articles.update_one({:_id => BSON::ObjectId("#{id}")}, '$push' => { comments: {timestamp: timestamp, text: comment}})
    db.close
    timestamp = timestamp.strftime("%a %b %d %Y %H:%M")

    result = j.encode({:timestamp => timestamp, :text => comment})
    respond_to do |format|
      format.json {render json: result}
    end

  end
end
