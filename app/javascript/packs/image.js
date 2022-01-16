$(function() {
    if($('#processing').length > 0) {
        toastr.warning($('#processing').text(), "", {
            "timeOut": 0,
            "extendedTimeOut": 0,
            "tapToDismiss": false, 
            "positionClass": "toast-bottom-full-width", // This does not overwrite the global option for some reason
            "progressBar": false,
        });
    }
});
