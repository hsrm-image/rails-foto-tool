if (sessionStorage.getItem('nextDestination') === 'images') {
	sessionStorage.setItem('nextDestination', '')
	//just requesting the correct partial gets it to display
	// beacuse of ruby routing
	$.ajax('userpanel/show_images.js')
}
if (sessionStorage.getItem('nextDestination') === 'collections') {
	sessionStorage.setItem('nextDestination', '')
	//just requesting the correct partial gets it to display
	// beacuse of ruby routing
	$.ajax('userpanel/show_collections.js')
}
