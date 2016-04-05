$(document).ready(function() {

  var currCell = $('td').first();
  var editing = false;
  update();

  function edit() {
    if (currCell.attr('contentEditable') == 'true') {
      editing = true;
      currCell.focus();
    }
  }

  function exit() {
    if (editing) {
      editing = false;
      currCell.blur();
      window.getSelection().removeAllRanges();
    }
  }

  function update() {
    // update css
    $('td').css('border-color', 'rgba(0, 0, 0, 0)');
    $('td').css('border-right', '1px solid lightgrey');
    $('td').css('border-bottom', '1px solid lightgrey');
    currCell.css('border', '3px solid #1CABCC');
  }

  // define Excel hotkeys for spreadsheet
  $('body').keydown(function(e) {
    if (!editing) {
      if (e.which == 39) {
        // right arrow
        currCell = currCell.next();
      } else if (e.which == 37) { 
        // left arrow
        currCell = currCell.prev();
      } else if (e.which == 38) { 
        // up arrow
        currCell = currCell.closest('tr').prev().find('td:eq(' + 
          currCell.index() + ')');
      } else if (e.which == 40) { 
        // down arrow
        currCell = currCell.closest('tr').next().find('td:eq(' + 
          currCell.index() + ')');
      } else if (e.which == 13 || e.which == 32) {
        // enter or spacebar - edit cell
        e.preventDefault();
        e.stopPropagation();
        edit();
      }
      update();
    }
  });

  $('td').focus(function() {
    // click into a cell
    currCell = $(this);
    update();
    edit();
  }).blur(function() {
    // click out of a cell
    exit();
  }).keydown(function(e) {
    // escape - exit edit cell
    if (editing) {
      if (e.which == 13 || e.which == 27) {
        e.stopPropagation();
        exit();
      }
    }
  });

  // listener for edits in data values
  $('.data-value').focus(function(){
    var startVal = $(this).text();
    var id = $(this).attr('data-id');
    $(this).data('startVal', startVal);
    $(this).data('id', id);

    // populate cell with input formula if one exists
    var inputFormula = $(this).attr('data-input-formula');
    $(this).html(inputFormula);
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
    var showSuccess = true
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
      if (oldFormula == newFormula) {
        showSuccess = false
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
