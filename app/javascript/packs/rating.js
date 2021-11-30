var set_stars = function(rateable_type, rateable_id, stars) {
    for(i=1; i<=5; i++) {
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
    $('.rating-star').on( "click", function() {
        
        var star = $(this);
        var stars = $(this).attr('data-stars');
        var rateable_type = $(this).attr('data-rateable-type');
        var rateable_id = $(this).attr('data-rateable-id');
        var user_id = "eeev2";
        //alert("Clicked " + star.attr('id') + " on " + rateable_type + " " + rateable_id);

        set_stars(rateable_type, rateable_id, stars);

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
            console.log( msg );
            });
    });
});