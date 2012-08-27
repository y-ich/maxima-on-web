/*
 * maxima_mobile.js
 * JavaScript for Maxima Web Frontend
 * author: ICHIKAWA, Yuji
 * Copyright (C) 2011 ICHIKAWA, Yuji
 */

window.onload = function() {
    $('#top')[0].addEventListener('touchmove', function(e){e.preventDefault();}, false);
    $('#command')[0].focus();
}

function submit() {
    if ($('#command').val().length > 0) {
	$.post('cgi-bin/maxima.rb',
	       'cmd=' + encodeURIComponent($('#command').val()),
	       function(data, status) {
		   $('#result').html(data);
		   MathJax.Hub.Queue(["Typeset", MathJax.Hub, $('#result')[0]]);
	       });
    }
};

function caretHead() {
    document.getElementById('command').setSelectionRange(0, 0);
}

function caretLeft() {
    var command = document.getElementById('command');
    var pos = doGetCaretPosition(command);

    if (pos > 0) command.setSelectionRange(pos - 1, pos - 1);
}

function caretRight() {
    var command = document.getElementById('command');
    var pos = doGetCaretPosition(command);

    if (pos < command.value.length) command.setSelectionRange(pos + 1, pos + 1);
}

function caretEnd() {
    var command = document.getElementById('command');
    var end = command.value.length;

    command.setSelectionRange(end, end);
}

function stringInput(str) {
    var command = document.getElementById('command');

    command.focus();
    var pos = doGetCaretPosition(command);

    command.value = command.value.slice(0, pos) + str + command.value.slice(pos);
    pos = pos + str.length;
    command.setSelectionRange(pos, pos); /* resetting caret position. */
}

function clearInput() {
    $('#command').val('');
    $('#command')[0].focus();
};

function bracketInput(elem) {
    var s = $('#command').val();
    var partner;

    switch (s) {
	case '(': partner = ')'; break;
	case '[': partner = ']'; break;
	case '{': partner = '}'; break;
	default : break;
    };
    
};

/* from stackoverflow
http://stackoverflow.com/questions/2897155/get-caret-position-within-an-text-input-field
 */

function doGetCaretPosition (oField) {

  // Initialize
  var iCaretPos = 0;

  // IE Support
  if (document.selection) {

    // Set focus on the element
    oField.focus ();

    // To get cursor position, get empty selection range
    var oSel = document.selection.createRange ();

    // Move selection start to 0 position
    oSel.moveStart ('character', -oField.value.length);

    // The caret position is selection length
    iCaretPos = oSel.text.length;
  }

  // Firefox support
  else if (oField.selectionStart || oField.selectionStart == '0')
    iCaretPos = oField.selectionStart;

  // Return results
  return (iCaretPos);
}
