jQuery(function($) {
  // when the #country field changes
  $("#data_farmer_city").change(function() {
    // make a POST call and replace the content
    var city = $('select#data_farmer_city :selected').val();
    if(city == "") city="0";
    jQuery.get('/data_farmers/update_neighbourhood_select/' + city, function(data){
        $("#cities").html(data);
    })
    return false;
  });

})
