// Helper function to pin an element on the page
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

//dateideas core misc javascript
$(document).ready(function() {
	//pin the datecart and the filters in the sidebar

	$(window).load(function(){
		var right = $('#sidebar_right_pinned');
		var left = $('#sidebar_left_pinned');
	   	var info = $('#di_related_info');

		if(right.length){
			pin($(window), right, "pin-right");
		}
		if(left.length){
			pin($(window), left, "pin-left");
		}
	});

	//opens print dialog
	$("#print_me").click(function(){
		window.print();
	});

	//Closes modal dialogs
	$(".ui-widget-overlay").live('click', function(){
		$(".dialog").each(function() {
			$(this).dialog("close");
		});
		$(".login_dialog").each(function(){
			$(this).dialog("close");
		});
	});

	$('a[rel="external"]').click(function(){
		this.target = "_blank";
	});

	//Display spinners for a add/remove button while item is being added to cart
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
	// Doesn't work in Firefox but works in Chrome
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
			// calls for the filter are not ajax.  Ajax doesn't really speed things up 
			// in this case anyways.
			// $('#main_results').addClass('ajax_load_and_fade');
		}).submit();
		// Show spinners around the page to indicate results are being loaded
		$('.filter_loaders').removeClass('ajax-hidden');
		// disabling leads to no parameters sent in Firefox, but works in Chrome
		// $('select').attr('disabled', 'disabled');
	});

	$('input[type="text"],input[type="password"], textarea').focus(function(){
        $(this).css("color","black");
        clear_input($(this));
    }).blur(function(){
        show_input($(this));
    });

	// Hack to extend the sidebar container to the bottom
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

	// Show datetimepicker (this appears on the datecart "notepad views")
	// Uses datetimepick jquery ui add-on
	// http://trentrichardson.com/examples/timepicker/
	$('.hidden_date_picker').datetimepicker({
	    buttonImage: '/images/datecart_calendar_icon.png',
		buttonImageOnly: true,
        showOn: 'button',
		altField: '#alt_show_date',
		altFieldTimeOnly: false,
		altFormat: "DD MM d, yy",
		dateFormat: "yy/mm/dd",
		ampm: true,
        hourGrid: 4,
        minuteGrid: 10,
		setDate: new Date(),
		onClose: function(dateText) {
			$('#date_display').html($("#alt_show_date").attr('value'));
		}
	});

	//
	$('.ui-datepicker-trigger').click(function(){
		$('#ui-datepicker-div').css('top','300px');
	});

	// Allow certain fields to be editable in-place
	// Uses jeditable
	// www.appelsiini.net/projects/jeditable
	$('.editable').editable(function(value, settings){
		return value;
	}, {
		type : 'textarea',
		submit : 'Done'
	});
});
