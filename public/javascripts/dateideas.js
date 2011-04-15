//dateideas core javascript
$(document).ready(function() {
	function lightbox() {
 		//When you click on a link with class of poplight and the href starts with a #
		$('a.poplight[href^=#]').click(function() {
		    var popID = $(this).attr('rel'); //Get Popup Name
		    var popURL = $(this).attr('href'); //Get Popup href to define size

		    //Pull Query & Variables from href URL
		    var query= popURL.split('?');
		    var dim= query[1].split('&');
		    var popWidth = dim[0].split('=')[1]; //Gets the first query string value

		    //Fade in the Popup and add close button
		    $('#' + popID).fadeIn().css({ 'width': Number( popWidth ) }).prepend('<a href="#" class="close"><img src="/images/close_pop.jpeg" class="btn_close" title="Close Window" alt="Close" width="16px" height="16"/></a>');

		    //Define margin for center alignment (vertical + horizontal) - we add 80 to the height/width to accomodate for the padding + border width defined in the css
		    var popMargTop = ($('#' + popID).height() + 100) / 2;
		    var popMargLeft = ($('#' + popID).width() + 50) / 2;

		    //Apply Margin to Popup
		    $('#' + popID).css({
		        'margin-top' : -popMargTop,
		        'margin-left' : -popMargLeft
		    });

		    //Fade in Background
		    $('body').append('<div id="fade"></div>'); //Add the fade layer to bottom of the body tag.
		    $('#fade').css({'filter' : 'alpha(opacity=80)'}).fadeIn(); //Fade in the fade layer
		    //$('#map' + popID).jMapping({metadata_options: {type: 'html5'}});
		    //$('#map' + popID).jMapping('update');
		    $(document).ready(function(){
		  	  $('#map' + popID).jMapping({
		  	    side_bar_selector: '#map-locations' + popID + ':first',
		  	    location_selector: '.location' + popID,
		  	    link_selector: 'a.map-item' + popID,
		  	    info_window_selector: '.info-html' + popID,
			force_zoom_level: 15,
			link_selector: false,
		          metadata_options: {type: 'html5'}
		  	  });
		    });
		    return false;
		});


		//Close Popups and Fade Layer
		$('a.close, #fade').live('click', function() { //When clicking on the close or fade layer...
		      $('#fade , .popup_block').fadeOut(function() {
		        $('#fade, a.close').remove();
				}); //fade them both out
		    return false;
		});
	}
	
	function pin(parent, element, style) {
		var scrollable = parent;
		var pos_element_origin = element.offset().top;
		
		scrollable.scroll(function(){
			// console.log("scrollable " + scrollable.scrollTop());
			// console.log("element pos " + pos_element_origin);
			if(scrollable.scrollTop() > pos_element_origin + 60) {
				// console.log("pin-cart")
				element.addClass(style);
			} else {
				// console.log("unpin-cart");
				element.removeClass(style);
			}
		});
	}
	
	var cart = $('#di_cart_front');
	var map = $('#sidebar_left_pinned');
	// console.log(cart);
	if(cart.length){
		pin($(window), cart, "pin-cart");
	}
	if(map.length){
		pin($(window), map, "pin-map");
	}
	
	//open print dialog
	$("#print_me").click(function(){
			window.print();
	});
	#lightbox();

	//close the dialog if clicked on the modal overlay
	$(".ui-widget-overlay").live('click', function(){
		$(".dialog").each(function() {
			$(this).dialog("close");
		});
	});
	
	$('a[rel="external"]').click(function(){
		this.target = "_blank";
	});
});
