function authorsWordCount(id) {
  var fields = id.split('_');
  var last = fields.length - 1;
  var mainDivId = fields.slice(0, -1).join('_');
  var subDivId = fields.slice(0, -2).join('_');

  var className = document.getElementById(id).className;
  if(className !== 'glyphicon glyphicon-chevron-down'){
    document.getElementById(id).className = 'glyphicon glyphicon-chevron-down';
    document.getElementById(mainDivId).style.display = 'block';

    var divs = document.getElementsByClassName(subDivId);
    var flag = 0;
    //check if there is any text in authors divs
    if(divs.length != 0)
      for(var i = 0; i < divs.length; i++) {
        if(divs[i].innerHTML !== '')
          flag = 1;
      };

    if(flag == 0)
      getWordsCount();

  } else {
    document.getElementById(id).className = 'glyphicon glyphicon-chevron-right';
    document.getElementById(mainDivId).style.display = 'none';
  }
};
function getWordsCount() {
  $.ajax({
    url: '/home/wordsForAuthors',
    method: "POST"
  }).success(function(result) {
    result.values.forEach(function(res) {
      var divs = document.getElementsByClassName(res._id.replace(/\s/, '_'));
      var table = '<table  style="width: 20%; border-bottom: 0.5px solid black;"><tbody>';
      res.value.forEach(function(word) {
        table += '<tr style="border-bottom: 0.5px solid black;"><td style="width:80%;">' + word.word + '</td><td style="text-align: right;">' + word.count + "</td></tr>";
      });
      table += "</tbody></table>";

      for(var i = 0; i < divs.length; i++) {
        divs[i].innerHTML = table;
      }
    });
  });
};
