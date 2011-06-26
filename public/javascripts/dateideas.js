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
		$(this).parent().html("<img src='/images/ajax-loader.gif' />");
	});                                                                
	
	$('.remove_button').live("ajax:beforeSend", function() {
		$(this).parent().html("<img src='/images/ajax-loader.gif' />");
	});
	
	// Ajax pagination
	$('.pagination a').attr('data-remote', 'true');
	$('.pagination a').live("ajax:beforeSend", function(){
		$('#main_results').addClass('ajax_load_and_fade');
	}).live("ajax:complete", function(){
		$('#main_results').removeClass('ajax_load_and_fade');
	});
	
	$('.pagination a').live("ajax:beforeSend", function(){
		$('#main_results').addClass('ajax_load_and_fade');
	}).live("ajax:complete", function(){
		$('#main_results').removeClass('ajax_load_and_fade');
	});
	
	// Wizard UI indicator while loading results
	$('#main input[name="commit"]').click(function(){
		$("form:first").submit();
		$('#wizard_loader').attr('style', 'display:block');
		$('select').attr('disabled', 'disabled');
		$('input').attr('disabled', 'disabled');
	});
	
	$('#di_filter_section select').live('change', function(){
		$('#di_filter_section select').attr('disabled', false);
		$("form:first").live("ajax:beforeSend", function(){			
			$('#main_results').addClass('ajax_load_and_fade');
		}).submit();
	});
	
});
