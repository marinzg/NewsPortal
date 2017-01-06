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
