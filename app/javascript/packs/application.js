// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

//Sprocket Zone
//= require dropzone

import Rails from '@rails/ujs'
import Turbolinks from 'turbolinks'
import * as ActiveStorage from '@rails/activestorage'
import 'channels'
import 'jquery'
// Needs to be imported here in order to work further along in the project
import Dropzone from 'dropzone'

Rails.start()
Turbolinks.start()
ActiveStorage.start()

window.Dropzone = Dropzone
window.ActiveStorage = ActiveStorage
