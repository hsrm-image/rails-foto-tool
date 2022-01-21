$('.cross').on('click', () => {
	//remove create modal
	$('.shadow').remove()
})

$('.submitButton').on('click', () => {
	//Submit new Collection
	var title = $('input[name=title]').val()
	$.ajax({
		url: 'collections',
		type: 'POST',
		data: {collection: {name: title}},
	}).done(() => {
		$('.shadow').remove()
		$.ajax({url: 'userpanel/show_collections'})
		toastr.success('nice bro')
	})
})
