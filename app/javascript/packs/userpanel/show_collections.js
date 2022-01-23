$('#collectionButton').on('click', () => {
	//spawn create modal
	$.ajax({url: 'userpanel/create_collection', type: 'GET'})
})

$('#control #imgButton').removeClass('active')
$('#control #colButton').addClass('active')
