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
	console.log(clicked)
	console.log($(e.target).prop('checked'))
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
		}).done(() => {
			toastr.success('Removed from Collection(s)')
		})
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
		}).done(() => {
			toastr.success('Added to Collection(s)')
		})
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
	console.log(input.next())
	if (input.next().prop('class') != 'doneButton') {
		$('.doneButton').remove()
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
	console.log(id)
	let img_info = {
		title: $('.attr_edit_title').val(),
		description: $('.attr_edit_description').val(),
		camera_maker: $('.attr_edit_exif_camera_maker').val(),
		camera_model: $('.attr_edit_exif_camera_model').val(),
		lens_model: $('.attr_edit_exif_lens_model').val(),
		focal_length: $('.attr_edit_exif_focal_length').val(),
		aperture: $('.attr_edit_exif_aperture').val(),
		exposure: $('.attr_edit_exif_exposure').val(),
		iso: $('.attr_edit_exif_iso').val(),
		gps_latitude: $('.attr_edit_exif_gps_latitude').val(),
		gps_longitude: $('.attr_edit_exif_gps_longitude').val(),
	}
	$.ajax({
		url: '/images/' + id,
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
			toastr.success('Updated ' + img_info.title)
		})
	})
}
