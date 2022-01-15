if (sessionStorage.getItem('nextDestination') === 'images') {
	console.log('images')
	sessionStorage.setItem('nextDestination', '')
	//just requesting the correct partial gets it to display
	// beacuse of ruby routing
	$.ajax('userpanels/show_images.js')
}
if (sessionStorage.getItem('nextDestination') === 'collections') {
	sessionStorage.setItem('nextDestination', '')
	//just requesting the correct partial gets it to display
	// beacuse of ruby routing
	$.ajax('userpanels/show_collections.js')
}
