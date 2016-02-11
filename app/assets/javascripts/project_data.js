$(document).ready(function() {

  //listener for edits in data values
  $('.data-value').focus(function(){
    var startVal = $(this).html();
    var id = $(this).attr('data-id');
    $(this).data('startVal', startVal);
    $(this).data('id', id);
  }).blur(function() {
    var newVal = $(this).html();
    if ($(this).data('startVal') != newVal) {
      var data_id = $(this).data('id')
      $.ajax('/data_values/' + data_id, {method: 'PATCH', data: {data_value: {value: newVal}}})
    }
  });
});

