var typingTimer //timer identifier
var doneTypingInterval = 2000 //time in ms
var id = $('*[data-collection-id]').data().collectionId
$('.deleteButton').on('click', () => {
	$.ajax({url: 'collections/' + id, type: 'DELETE'}).done(() => {
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

$('[class^=attr_edit_]').on('keyup', () => {
	clearTimeout(typingTimer)
	typingTimer = setTimeout(updateCollection, doneTypingInterval)
})
$('[class^=attr_edit_]').on('keydown', function () {
	clearTimeout(typingTimer)
})

function updateCollection() {
	console.log($('meta[name="csrf-token"]').data())
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
