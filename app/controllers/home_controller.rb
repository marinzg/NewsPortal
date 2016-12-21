require 'mongo'
class HomeController < ApplicationController
  def index
    db = Mongo::Client.new([ '192.168.56.12:27017' ], :database => 'nmbp')
    @student = db[:cards].find()
  end
end
