// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'jquery'
import {} from 'jquery-ujs'
require('jquery-bridget')
import 'bootstrap-icons/font/bootstrap-icons.css'
import toastr from 'toastr' // Notifications https://github.com/CodeSeven/toastr
import Dropzone from 'dropzone'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

// Global options for toastr https://codeseven.github.io/toastr/demo.html
toastr.options = {
    "closeButton": true,
    "positionClass": "toast-bottom-center",
    "progressBar": true,
    "timeOut": "10000",
}

window.Dropzone = Dropzone
window.ActiveStorage = ActiveStorage
window.toastr = toastr // very ugly but otherwise .js.erb files don't receive toastr
window.$ = $
window.jquery = $



$( document ).on('turbolinks:load', function() {
    let notice = $(".notice").text();
    if(notice) {
        toastr.success(notice); 
    }

    let alert = $(".alert").text();
    if(alert) {
        toastr.error(alert);
    }
});