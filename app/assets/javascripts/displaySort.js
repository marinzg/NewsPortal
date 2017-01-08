//function for sort dropdown
function selectSort() {
  var type = document.getElementById('sortSelect').value;
  if(type !== 'time'){
    document.location = '/home/byNoOfComments';
  } else {
    document.location = '/';
  }
}
