// Handles panel collapses (entries index)
function handle_entries() {
	$(document).off("show.bs.collapse").on("show.bs.collapse", ".panel-collapse", function() {
		var panel_body = $(this).children();
		if(panel_body.html()=="") {
			$.get("/entries/"+$(this).attr("id")+".json", function(data) {
				panel_body.html(data["content"]["html"]);
			});
		}
	});
}

// Handles "load more" button
function load_more() {
	var last_date = $(".entry").last().attr("date");
	var source = $(this);

	source.hide();
	$("#totop").hide();
	$(".loading-icon").css("display", "inline");

	$.ajax({
		url: source.attr("href"),
		type: "GET",
		data: {
			date: last_date
		},
		success: function(result) {
			var entries = $(result).find(".entry");

			if(entries.length > 0) {
				$("#entries").append(entries);
				source.show();
				$("#totop").show();
				$(".loading-icon").css("display", "none");
			}
			else {
				source.show();
				$("#totop").show();
				$(".loading-icon").css("display", "none");
				source.attr("disabled", "");
				source.off("click").on("click", function() { return false });
			}
		},
	});

	return false;
}

// Handles the "back to top" link
function go_to_top() {
	$('body,html').animate({
		scrollTop: 0
	}, 600);

	return false;
}

// Handles "clear" button for entries filtering
function handle_clear_btn() {
	sidebar_unselect();
	right_sidebar_uncheck();
}

//...
function entries_js() {
    handle_entries();
    $("#load-more-btn").off("click.load-more-btn").on("click.load-more-btn", load_more);
	$("#totop").off("click.totop").on("click.totop", go_to_top);
	$("#clear-filters-btn").off("click.clear-filters-btn").on("click.clear-filters-btn", handle_clear_btn);
}
