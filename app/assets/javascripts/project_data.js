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
      $.ajax('/data_values/' + data_id, {method: 'PATCH', data: {data_value: {value: newVal}}, success: handleData, error: handleError})
    }
  });

  // handle update for all data values after edit
  function handleData(data) {
    var data_values = data["data_values"]
    for (var i=0; i < data_values.length; i++) {
      var dataAttrString = '[data-id="'+ data_values[i].id +'"]';
      var dataVal = data_values[i].value;

      if (isCustomData(dataVal)) {
        $(dataAttrString).html(dataVal);
      } else {
        $(dataAttrString).html(data_values[i].formula_value);
      }
    }
    complete();
  }

  // Checks if there is a custom entered value or not. Returns true if custom value.
  function isCustomData(data) {
    return data != null;
  }

  function handleError(xhr, textStatus, errorThrown) {
    toastr.error("Update Failed.");
  }

  function complete() {
    toastr.success("Update Successful!");
  }
});

