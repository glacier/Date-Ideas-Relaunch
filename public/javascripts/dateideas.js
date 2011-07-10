// Helper functions for toggling input text fields
function clear_input(inputbox){
    input_text = inputbox.val();
    if(input_text == inputbox.attr('title')){
        inputbox.val('');                           
    }
}

function show_input(inputbox) {
    input_text = inputbox.val();
    if (input_text == '' || input_text == ' ') {
        inputbox.val(inputbox.attr('title'));
        inputbox.css("color", "#CCC");
    }
}

//dateideas core javascript
$(document).ready(function() {
	//pin an element to the page
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
	
	//pin the datecart and the filters in the sidebar
	var right = $('#sidebar_right_pinned');
	var left = $('#sidebar_left_pinned');
   	var info = $('#di_related_info');

	if(right.length){
		pin($(window), right, "pin-right");
	}
	if(left.length){
		pin($(window), left, "pin-left");
	}
	
	//open print dialog
	$("#print_me").click(function(){
			window.print();
	});

	//Closes the dialog if clicked on the modal overlay
	$(".ui-widget-overlay").live('click', function(){
		$(".dialog").each(function() {
			$(this).dialog("close");
		});
	});
	
	$('a[rel="external"]').click(function(){
		this.target = "_blank";
	});
	
	//Display spinners for a add/remove button while item has not been added to cart
	$('.add_button').live("ajax:beforeSend", function() {
		$(this).parent().html("<img src='/images/ajax-loader-small.gif' />");
	});

	$('.remove_button').live("ajax:beforeSend", function() {
		$(this).parent().html("<img src='/images/ajax-loader-small.gif' />");
	});
	
	// Ajax pagination
	$('#ajax_paginate a').attr('data-remote', 'true');
	$('.pagination a').live("ajax:beforeSend", function(){
		console.log('pagination: beforeSend');
		$('#main_results').addClass('ajax_load_and_fade');
	}).live("ajax:complete", function(){
		console.log('pagination: complete');
		$('#main_results').removeClass('ajax_load_and_fade');
	});
		
	// Wizard UI indicator while loading results
	// Doesn't work in Firefox
	// $('#main input[name="commit"]').click(function(){
	// 	$('form:first').submit();
	// 	$('select').attr('readonly', true);
	// 	$('input').attr('readonly', true);
	// 	$('#wizard_loader img').removeClass('ajax-hidden');
	// });
	
	$('#di_wizard_form form').submit(function(){
		$('#wizard_loader img').removeClass('ajax-hidden');
		return true;
	});
	
	$('#di_filter_section select').live('change', function(){
		$('#di_filter_section select').attr('disabled', false);
		$("form:first").live("ajax:beforeSend", function(){			
			$('#main_results').addClass('ajax_load_and_fade');
		}).submit();		
		// Show spinners around the page to indicate results are being loaded
		$('.filter_loaders').removeClass('ajax-hidden');
		// disabling may lead to no parameters to be sent in Firefox
		// $('select').attr('disabled', 'disabled');
	});
	
	//Toggle all input text and password fields on site
	//Set title attribute of input to show toggle texts
	$('input[type="text"],input[type="password"], textarea').each(function(){
		$(this).val($(this).attr('title'));
	});
	
	$('input[type="text"],input[type="password"], textarea').focus(function(){
        $(this).css("color","black");
        clear_input($(this));
    }).blur(function(){
        show_input($(this));
    });
	
	//Hack to extend the sidebar container to the bottom
	height = $('#content').outerHeight() + 112;
	$('#sidebar_right').height(height);

    //wizard
    $('#location-without-hood').hide();
    $('#location-with-hood').show();
    console.log("doc ready")
    $('#city').change(function(){
        console.log("wizard selected")
        var city = $('select#city :selected').val();
        if(city == 'Montreal')
        {
            //show the hidden div
            $('#location-with-hood').hide();
            $('#location-without-hood').show();
        }
        else
        {
            //otherwise, hide it
            $('#location-without-hood').hide();
            $('#location-with-hood').show();
        }
    });
});
