# Class with string constants for
# mongodb map and reduce functions.
class Strings

  attr_accessor :comments_map
  attr_accessor :comments_reduce

  attr_accessor :authors_map
  attr_accessor :authors_reduce
  attr_accessor :authors_finalize

  def initialize()
    initializeComments
    initializeAuthors
  end

  # M/R functions for getting the number
  # of comments for each article.
  # (assigment 2.a)
  def initializeComments
    self.comments_map = %{
      function() {
        if(this.comments !== undefined)
          for(var i = 0; i < this.comments.length; i++) {
            emit(this._id, 1);
          }
          if(this.comments.length == 0) emit(this._id, 0);
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')

    self.comments_reduce = %{
      function(key, values) {
        var count = 0;

        values.forEach(function(value) {
          count += value;
        });
        return count;
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')
  end

  # M/R fin functions for getting top
  # ten most used words for each author.
  # (assigment 2.b)
  def initializeAuthors
    self.authors_map = %{
      function() {
        var words =this.text.match(/[a-zA-Z]+\'*[a-zA-Z]+/g);
        var tmp = {};
        var authorsWords = [];

        words.forEach(function(w) {
          if(tmp[w] == undefined)
            tmp[w] = 1;
          else
            tmp[w] +=1;
        });

        Object.keys(tmp).forEach(function(word) {
          authorsWords.push({word: word, count: tmp[word]});
        });
        print(this.author + " - " + authorsWords.length);
        emit(this.author, {words: authorsWords});
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')

    self.authors_reduce = %{
      function(key, values){
        var tmp = {};
        var authorsWords = [];

        values.forEach(function(list) {
          list.words.forEach(function(obj) {
            if(tmp[obj.word] == undefined)
              tmp[obj.word] = obj.count;
            else
              tmp[obj.word] += obj.count;
          });
        });
        
        Object.keys(tmp).forEach(function(word) {
          authorsWords.push({word: word, count: tmp[word]});
        });
        return {words: authorsWords};
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')

    self.authors_finalize = %{
      function(key, value){
        var tmp = value.words.sort(function(a, b){return b.count - a.count;});
        tmp = tmp.slice(0,10);
        return tmp;
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')
  end
end
