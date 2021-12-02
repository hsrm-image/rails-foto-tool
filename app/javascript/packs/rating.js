"use strict";
/**
 * Change the clicked stars to give the User a feedback
 * @param {number} stars The Number of stars to change to "active"
 */
var set_stars = function(stars) {
    for(var i=1; i<=5; i++) {
        if(i <= stars) {
            $('#star_' + i).addClass("star-active");
            $('#star_' + i).removeClass("star-inactive");
        } else {
            $('#star_' + i).removeClass("star-active");
            $('#star_' + i).addClass("star-inactive");
        }
    }
}

$(function() {
    // Get the static page Elements
    var score_area = $("#score-area");
    var score = score_area.find("#score");
    var nr_ratings = score_area.find("#nr-ratings");
    var user_id = $('[name="session_id"]')[0].value;
    $('.rating-star').on( "click", function() {
        // Find all the Attributes of the clicked Star
        var stars = $(this).attr('data-stars');
        var rateable_type = $(this).attr('data-rateable-type');
        var rateable_id = $(this).attr('data-rateable-id');

        // Change the class of the stars to reflect the clicked stars
        set_stars(stars);

        // Now send the clicked value to the server
        // TODO only submit when leaving page? https://stackoverflow.com/questions/18783535/jquery-beforeunload-when-closing-not-leaving-the-page
        // TODO click again to remove rating?
        $.ajax({
            url: "/ratings",
            method: "POST",
            data: {
                authenticity_token: $('[name="csrf-token"]')[0].content,
                "rating": 
                        {"rateable_id": rateable_id,
                        "rateable_type": rateable_type,
                        "user_id": user_id,
                        "rating": stars}
            }
        }).done(function( msg ) {
            // Update the displayed score
            score.text((Math.round(msg.rating * 10) / 10).toFixed(1));
            nr_ratings.text(msg.nr_ratings);
            score_area.show();
        });
    });
});