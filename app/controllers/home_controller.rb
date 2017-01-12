require 'mongo'
require 'BSON'
class HomeController < ApplicationController

  # GET /
  #   Controller for displaying list of
  #   articles sorted by date.
  def index
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')

    # mongo _id is created based on timestamp of insertion
    # so sort by date is simply sort by _id
    @articles = db[:articles].find().sort({_id:-1}).limit(10)
    db.close
  end

  # GET /home/byNoOfComments
  #   Controller for displaying list of
  #   articles sorted by number of comments.
  def byNoOfComments
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
    m_r = Strings.new

    # use map reduce to get list of article ids
    # and number of comments in that article
    aggregate =  db[:articles].find().map_reduce(m_r.comments_map, m_r.comments_reduce)
    sorted = aggregate.find().entries.sort! { |b, a| a["value"] <=> b["value"] }

    @articles = []

    # Get full article based on _id
    sorted.each do |var|
      @articles << db[:articles].find({:_id => var["_id"]}).first
    end
    db.close
  end

  # POST /home/create
  #   Controller that saves new article
  #   in the database and the article image on the disk.
  def create
      @article = Article.new(params.require(:article).permit(:title, :author, :text, :image))


      img = BSON::Binary.new(Base64.encode64(@article.image.read), :md5)
      exstension = @article.image.content_type.split('/')[1]
      tmp_article = {title: @article.title, author: @article.author, text: @article.text, image: img, imgType: exstension,  comments: []}

      # add article to the database
      db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
      db[:articles].insert_one(tmp_article)
      db.close

      redirect_to root_path
  end

  # POST /home/comment
  #   Method that saves comment in the database.
  def comment
    j = ActiveSupport::JSON
    id = params["id"]
    comment = params["comment"]
    timestamp = Time.now

    # save comment in the database
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
    db[:articles].update_one({:_id => BSON::ObjectId("#{id}")}, '$push' => { comments: {timestamp: timestamp, text: comment}})
    db.close

    # format timestamp => Sun Jan 08 2017 14:10
    timestamp = timestamp.strftime("%a %b %d %Y %H:%M")

    # return comment and formated timestamp to ajax call
    result = j.encode({:timestamp => timestamp, :text => comment})
    respond_to do |format|
      format.json {render json: result}
    end
  end

  # POST /home/wordsForAuthors
  #   Get 10 most used words for authors
  #   using second M/R
  def wordsForAuthors
    j = ActiveSupport::JSON
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')

    # use map reduce to get top 10 used
    # words for every author
    m_r = Strings.new
    aggregate = db[:articles].find().map_reduce(m_r.authors_map, m_r.authors_reduce).finalize(m_r.authors_finalize)
    values = aggregate.find().entries
    db.close

    # return values to ajax call
    result = j.encode({:values => values})
    respond_to do |format|
      format.json {render json: result}
    end
  end

end
