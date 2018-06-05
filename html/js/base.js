$(document).ready(function() {
    var today = new Date().toDateString();
	$('.today').html(today);
})

// dropdown button with hidden input
$(".dropdown-selector .dropdown-list").click(function(e) {
    e.preventDefault();
    var listValue = $(this).find(".dropdown-list-value").first().html();
    $(this).closest(".dropdown-selector").find('input').first().val(listValue);
    $(this).closest(".dropdown-selector").find('.dropdown-button-value').first().html(listValue);
});

// query form
$("#query_form").submit(function(e) {
    e.preventDefault();
    $('#query_result').html('Sending...');
    $.ajax({
        url: '/cgi/peptovar.pl',
        type: 'POST',
        data: $(this).serialize(),
        dataType: 'html',
        success: function (data) {
            $('#query_result').html(data);
        },
        error: function (xhr, status) {
            alert("Internal error!");
        }
    });
});

// query by "press Enter"
$("#query_field").keypress(function(e) {
    if (e.which == 13) {
        e.preventDefault();
        $("#btn_get_annotation").focus().click();
    }
});

// clean the query field
$("#clean_query_field").click(function(){
    $("#query_field").val('');
});

// load examples into the query field
$("#example_pept").click(function(){
    $("#query_field").val($("#example_pept").text());
    $("#input_hidden_field").val('sequence');
    $("#query_type_value").text('sequence');
    $("#length_9").prop('checked', true);
});

$("#example_isoform_id").click(function(){
    $("#query_field").val($("#example_isoform_id").text());
    $("#input_hidden_field").val('isoform_ID');
    $("#query_type_value").text('isoform_ID');
    $("#length_9").prop('checked', true);
});

$("#example_variation_id").click(function(){
    $("#query_field").val($("#example_variation_id").text());
    $("#input_hidden_field").val('variation_ID');
    $("#query_type_value").text('variation_ID');
    $("#length_9").prop('checked', true);
});

$.ajax({
  type: "POST",
  dataType: "json",
  data: {test : worked},
  url: 'ajax/getDude.php',
  success: function(data) {
    alert(data);
  }
});

