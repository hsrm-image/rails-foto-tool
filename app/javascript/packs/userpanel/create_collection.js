$('.cross').on('click', () => {
	//remove create modal
	$('.shadow').remove()
})

$('.submitButton').on('click', () => {
	//Submit new Collection
	var title = sanatizeUserInput($('input[name=title]').val())
	console.log(title)
	$.ajax({
		url: 'collections',
		type: 'POST',
		data: {
			collection: {name: title},
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
	}).done(() => {
		$('.shadow').remove()
		$.ajax({url: 'userpanel/show_collections'})
	})
})

function sanatizeUserInput(input) {
	return input.replace(/[^\w. ]/gi, '')
}
