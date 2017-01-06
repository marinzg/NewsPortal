require 'mongo'
require 'BSON'
class HomeController < ApplicationController

  def index
    type = params["type"]
    if(type == nil)
      type = 'time'
    end

    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')

    if (type == 'noOfComments')
      @articles = db[:articles].find().sort({_id:-1}).limit(10)
    else
      @articles = db[:articles].find().sort({_id:-1}).limit(10)
    end


    db.close
  end


  #MAPREDUCE #1
  #tmp = Strings.new
  #res =  db[:articles].find().map_reduce(tmp.comments_map, tmp.comments_reduce).out(:replace => "newArticles")
  #ids = res.find().entries.map{|x| x["_id"]}
  #@articles = db[:articles].find(:_id => {'$in' => ids})


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

  def wordsForAuthors
    p "tu sam"
    j = ActiveSupport::JSON
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')

    #MAPREDUCE #2
    tmp = Strings.new
    res = db[:articles].find().map_reduce(tmp.authors_map, tmp.authors_reduce).finalize(tmp.authors_finalize)
    values = res.find().entries

    db.close
    result = j.encode({:values => values})
    respond_to do |format|
      format.json {render json: result}
    end
  end
end
