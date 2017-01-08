function submit(id) {
  var comment = document.getElementById('com'+id).value;
  var noOfComments = document.getElementById(id + '_comment_count').innerHTML.replace('[', '').replace(']', '');

  var sendData = {id: id, comment: comment};

  //send a comment to the server
  $.ajax({
    url: '/home/comment',
    data: sendData,
    method: "POST"
  }).success(function(result) {
    //update HTML
    document.getElementById('com'+id).value = "";
    document.getElementById('comments' + id).innerHTML += '<li>[' + result.timestamp + '] => ' + result.text + '</li>';
    noOfComments = parseInt(noOfComments)+ 1;
    document.getElementById(id + "_comment_count").innerHTML = '[' + noOfComments + ']'
  });
};

function klik(e, id){
  if(e.keyCode == 13) {
    submit(id);
  }
}

function commentsToogle(id) {
  var className = document.getElementById(id).className;
  var commentsDivId = id + "s";

  //toogle coments div
  if(className !== 'glyphicon glyphicon-chevron-down'){
    document.getElementById(id).className = 'glyphicon glyphicon-chevron-down';
    document.getElementById(commentsDivId).style.display = 'block';
  } else {
    document.getElementById(id).className = 'glyphicon glyphicon-chevron-right';
    document.getElementById(commentsDivId).style.display = 'none';
  }
}
