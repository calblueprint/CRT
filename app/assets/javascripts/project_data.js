$(document).ready(function() {

  // listener for edits in data values
  $('.data-value').focus(function(){
    var startVal = $(this).text();
    var id = $(this).attr('data-id');
    $(this).data('startVal', startVal);
    $(this).data('id', id);

    // populate cell with input formula if one exists
    var inputFormula = $(this).attr('data-input-formula');
    if (inputFormula) {
      $(this).html(inputFormula);
    }
  }).blur(function() {
    var newVal = $(this).text();

    if ($(this).data('startVal') != newVal) {
      var data_id = $(this).data('id');
      $.ajax('/data_values/' + data_id, {method: 'PATCH', data: {data_value: {input_value: newVal}}, success: handleData, error: handleError});
    }
  });

  // handle update for all data values after edit
  function handleData(data) {
    var data_values = data["data_values"]
    var showSuccess = false
    for (var i = 0; i < data_values.length; i++) {
      var dataAttrString = '[data-id="'+ data_values[i].id +'"]';
      var dataVal = data_values[i].value;
      if (isCustomData(dataVal)) {
        $(dataAttrString).html(dataVal);
      } else {
        $(dataAttrString).html(data_values[i].formula_value);
      }
      // update cell with input formula if one exists
      var oldFormula = $(dataAttrString).attr('data-input-formula');
      var newFormula = data_values[i].input_formula
      if (oldFormula != newFormula) {
        showSuccess = true
      }
      $(dataAttrString).attr('data-input-formula', newFormula);
    }
    if (showSuccess) {
      complete();
    }
  }

  // checks if there is a custom entered value or not. Returns true if custom value.
  function isCustomData(data) {
    return data != null;
  }

  function handleError(xhr, textStatus, errorThrown) {
    toastr.error(xhr.responseJSON.errors);
  }

  function complete() {
    toastr.success("Update Successful!");
  }
});
