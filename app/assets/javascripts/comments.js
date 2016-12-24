function submit(id) {
  var comment = document.getElementById('com'+id).value;
  //document.getElementById('comments' + id).innerHTML += '<li>' + comment+ '</li>'
//<li>[<%=comment["timestamp"].strftime("%a %b %d %Y %H:%M")%>] => <%= comment["text"] %> </li>

  var sendData = {id: id, comment: comment};
  $.ajax({
    url: '/home/comment',
    data: sendData,
    method: "POST"
  }).success(function(result) {
    document.getElementById('com'+id).value = "";
    document.getElementById('comments' + id).innerHTML += '<li>[' + result.timestamp + '] => ' + result.text + '</li>';
  });
};

function klik(e, id){
  if(e.keyCode == 13) {
    submit(id);
  }
}
