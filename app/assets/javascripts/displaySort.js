function selectSort() {
  var type = document.getElementById('sortSelect').value;


  $.ajax({
    url: '/home/index',
    data: {type: type},
    method: "GET"
  }).success(function(result) {
    alert(result);
    //document.write(result);
    //document.getElementById('sortSelect').value = type;
    //alert(type);
    //document.close();

  });
}
