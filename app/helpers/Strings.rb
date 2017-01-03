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

  def initializeComments
    self.comments_map = %{
      function() {
        if(this.comments !== undefined)
          emit(this._id, this.comments.length);
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')

    self.comments_reduce = %{
      function(key, values) {
        var article = {
          _id : key,
          count : 0
        };

        values.forEach(function(value) {
          article.count += value;
        });
        return article;
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')
  end

  def initializeAuthors
    self.authors_map = %{
      function() {
        var words =this.text.match(/[a-zA-Z]+\'*[a-zA-Z]+/g);
        if(words !== null) {
          for(var i = 0; i < words.length; i++) {
            emit({author: this.author, word: words[i]}, {count: 1});
          }
        }
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')

    self.authors_reduce = %{
      function(key, values){
        var sum = 0;
        var result = {
          author: key.author,
          word: {}
        };
        for(var i = 0; i < values.length; i++) {
          sum += values[i].count;
        }
        return {count: sum};
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')

    self.authors_finalize = %{
      function(key, value){
        print(key.author + "-" + key.word + "-" + value.count);
      }
    }.gsub(/\n/, '').gsub(/\s+/, ' ')
  end
end
