//var id = $('#img_id').data().imgId
// Deletebutton - Deletes the image
$('.deleteButton').on('click', () => {
	$.ajax({
		url: 'images/' + $('#img_id').data().imgId,
		type: 'DELETE',
		data: {
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
	}).done(() => {
		$.ajax({url: 'userpanel/show_images.js', type: 'GET'})
	})
})

$('.collectionList input[type="checkbox"]').on('click', e => {
	var clicked = $(e.target)
	if (!clicked.prop('checked')) {
		$.ajax({
			url: 'userpanel/part_collection_image',
			data: {
				image_id: clicked.data().img,
				collection_id: clicked.data().collection,
				authenticity_token: $('meta[name="csrf-token"]').attr(
					'content',
				),
			},
			type: 'POST',
		}).done(() => {})
	} else {
		$.ajax({
			url: 'userpanel/join_collection_image',
			data: {
				image_id: clicked.data().img,
				collection_id: clicked.data().collection,
				authenticity_token: $('meta[name="csrf-token"]').attr(
					'content',
				),
			},
			type: 'POST',
		}).done(() => {})
	}
})
//manually start proccess if not run jet
$('.proccessButton').on('click', e => {
	$.ajax({
		url: 'userpanel/startProccess',
		data: {
			image_id: $(e.target).data().img,
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
		type: 'POST',
	})
})
//spawn & remove done button
$('[class^=attr_edit_]').on('keyup', e => {
	var input = $(e.target)
	if (input.next().prop('class') != 'doneButton') {
		$('.doneButton').remove()
		$('.editContainer').removeClass('fixHeight')
		if (input.prop('nodeName') != 'textarea'.toUpperCase())
			input.parent().addClass('fixHeight')
		input.after('<span class="doneButton">✓</span>')
	}
})
//start update
$('body').on('click', '.doneButton', () => {
	$('.doneButton').remove()
	updateImage()
})
//update image
function updateImage() {
	var id = $('#img_id').data().imgId
	let img_info = {
		title: sanatizeUserInput($('.attr_edit_title').val()),
		description: sanatizeUserInput($('.attr_edit_description').val()),
	}
	$.ajax({
		url: 'images/' + id,
		type: 'PUT',
		data: {
			image: {
				title: img_info.title,
				description: img_info.description,
			},
			authenticity_token: $('meta[name="csrf-token"]').attr('content'),
		},
	}).done(() => {
		$.ajax('userpanel/show_images.js').done(() => {
			$.ajax('userpanel/show_details.js?img=' + id)
		})
	})
}
function sanatizeUserInput(input) {
	return input.replace(/[^\p{L}. 0-9_,-]/giu, '')
}
