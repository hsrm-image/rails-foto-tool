$(function() {
    $('#extend-description').on("click", function(event) {
        event.preventDefault();
        $('#description-preview').hide();
        $('#description-full').show();
    });
    $('#truncate-description').on("click", function(event) {
        event.preventDefault();
        $('#description-full').hide();
        $('#description-preview').show();
    });
});
