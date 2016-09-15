$(document).ready(function() {

  // listener for edits in data values
  $('.data-value').focus(function(){
    var startVal = $(this).text().replace(/\$|,/g, "");
    var id = $(this).attr('data-id');
    var type = $(this).attr('data-type');
    $(this).data('startVal', startVal);
    $(this).data('id', id);
    $(this).data('type', type);

    // populate cell with input formula if one exists
    var inputFormula = $(this).attr('data-input-formula');
    if (inputFormula) {
      $(this).html(inputFormula);
    }
    else {
      $(this).html(startVal)
    }
  }).blur(function() {
    var newVal = $(this).text().trim().replace(/\$|,/g, "");
    var startVal = $(this).data('startVal').trim()
    var differentValue =  newVal != startVal;
    var differentFormula = newVal != String($(this).attr('data-input-formula')).trim();
    var isCurrency = ($(this).data('type') == "currency")
    
    if (differentValue && differentFormula) {
      var data_id = $(this).data('id');
      $.ajax('/data_values/' + data_id, {method: 'PATCH', data: {data_value: {input_value: newVal}}, success: handleData, error: handleError});
    } else if (differentValue && !differentFormula) {
      if (isCurrency && startVal) {
        $(this).html(toCurrency(startVal));
      } else {
        $(this).html(startVal);
      }
    } else if (isCurrency && startVal) {
      $(this).html(toCurrency(startVal));
    }
  });

  // handle update for all data values after edit
  function handleData(data) {
    var data_values = data["data_values"];
    for (var i = 0; i < data_values.length; i++) {
      var dataAttrString = '[data-id="'+ data_values[i].id +'"]';
      var dataVal = data_values[i].value;
      var isCurrency = ($(dataAttrString).data('type') == "currency");
      var isFocus = $(dataAttrString).is(":focus");

      if (isCustomData(dataVal)) {
        if (isCurrency && !isFocus) {
          $(dataAttrString).html(toCurrency(dataVal));
        } else if (isCurrency && isFocus) {
          $(dataAttrString).html(parseFloat(dataVal, 10).toFixed(2));
        } else
          $(dataAttrString).html(dataVal);
      } else if (!isFocus) { 
        if (isCurrency && data_values[i].formula_value != null) {
          $(dataAttrString).html(toCurrency(data_values[i].formula_value));
        } else
          $(dataAttrString).html(data_values[i].formula_value);
      }
      // update cell with input formula if one exists
      var newFormula = data_values[i].input_formula;
      $(dataAttrString).attr('data-input-formula', newFormula);
    }
    complete();
  }

  // checks if there is a custom entered value or not. Returns true if custom value.
  function isCustomData(data) {
    return data != null;
  }

  function toCurrency(value) {
    return '$' + parseFloat(value, 10).toFixed(2).replace(/(\d)(?=(\d{3})+\.)/g, "$1,").toString();
  }

  function handleError(xhr, textStatus, errorThrown) {
    toastr.error(xhr.responseJSON.errors);
  }

  function complete() {
    toastr.success("Update Successful!");
  }
});
