//var id = $('*[data-collection-id]').data().collectionId
$('.deleteButton').on('click', () => {
	$.ajax({
		url: 'collections/' + $('*[data-collection-id]').data().collectionId,
		type: 'DELETE',
		data: {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
	}).done(() => {
		toastr.success('Collection deleted')
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
	console.log(input.next())
	if (input.next().prop('class') != 'doneButton') {
		$('.doneButton').remove()
		input.after('<span class="doneButton">✓</span>')
	}
})
//start update
$('body').on('click', '.doneButton', () => {
	$('.doneButton').remove()
	updateCollection()
})

function updateCollection() {
	var id = $('*[data-collection-id]').data().collectionId
	let collection_info = {
		name: $('.attr_edit_name').val(),
	}
	$.ajax({
		url: '/collections/' + id,
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
			toastr.success('Updated ' + collection_info.name)
		})
	})
}

function updateHeaderImage(checkbox) {
	var id = $('*[data-collection-id]').data().collectionId
	if (!checkbox.prop('checked')) {
		console.log('removing')
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
		}).done(() => {
			toastr.success('Header Image unset!')
			$.ajax({url: 'userpanel/show_collections'}).done(() => {
				$.ajax({
					url:
						'userpanel/show_collection_details?collection_id=' + id,
				})
			})
		})
	} else {
		console.log('adding')
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
		}).done(() => {
			toastr.success('Header Image set!')
			$.ajax({url: 'userpanel/show_collections'}).done(() => {
				$.ajax({
					url:
						'userpanel/show_collection_details?collection_id=' + id,
				})
			})
		})
	}
}
