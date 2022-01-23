//var id = $('*[data-collection-id]').data().collectionId
$('.deleteButton').on('click', () => {
	$.ajax({
		url: 'collections/' + $('*[data-collection-id]').data().collectionId,
		type: 'DELETE',
		data: {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
	}).done(() => {
		setTimeout(() => {
			$.ajax({url: 'userpanel/show_collections.js', type: 'GET'})
		}, 500)
	})
})
$('.headerImages input[type="checkbox"]').on('click', e => {
	updateHeaderImage($(e.target))
})
$('.headerImages img').on('click', e => {
	var matchingCheckbox = $(
		'.headerImages input[type="checkbox"][data-img=' +
			$(e.target).data().img +
			']',
	)
	matchingCheckbox.attr('checked', !matchingCheckbox.attr('checked'))
	updateHeaderImage(matchingCheckbox)
})

//spawn & remove done button
$('[class^=attr_edit_]').on('keyup', e => {
	var input = $(e.target)
	if (input.next().prop('class') != 'doneButton2') {
		$('.doneButton2').remove()
		input.after('<span class="doneButton2">✓</span>')
	}
})
//start update
$('body').on('click', '.doneButton2', () => {
	$('.doneButton2').remove()
	updateCollection()
})

function updateCollection() {
	var id = $('*[data-collection-id]').data().collectionId
	let collection_info = {
		name: sanatizeUserInput($('.attr_edit_name').val()),
	}
	$.ajax({
		url: 'collections/' + id,
		type: 'PUT',
		data: {
			collection: {
				name: collection_info.name,
			},
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
	}).done(() => {
		$.ajax('userpanel/show_collections.js').done(() => {
			$.ajax('userpanel/show_collection_details.js?collection_id=' + id)
		})
	})
}

function updateHeaderImage(checkbox) {
	var id = $('*[data-collection-id]').data().collectionId
	if (!checkbox.prop('checked')) {
		$.ajax({
			url: 'userpanel/set_collection_header',
			data: {
				image_id: null,
				collection_id: id,
				authenticity_token: $('meta[name="csrf-token"]').attr(
					'content',
				),
			},
			type: 'POST',
		})
	} else {
		$.ajax({
			url: 'userpanel/set_collection_header',
			data: {
				image_id: checkbox.data().img,
				collection_id: id,
				authenticity_token: $('meta[name="csrf-token"]').attr(
					'content',
				),
			},
			type: 'POST',
		})
	}
}
function sanatizeUserInput(input) {
	return input.replace(/[^\p{L}]/gmu, '')
}
