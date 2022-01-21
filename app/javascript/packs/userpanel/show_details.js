var typingTimer //timer identifier
var doneTypingInterval = 2000 //time in ms
var id = $('#img_id').data().imgId
$('.deleteButton').on('click', () => {
	$.ajax({url: 'images/' + id, type: 'DELETE'}).done(() => {
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
			},
			type: 'POST',
		}).done(() => {
			toastr.success('Added to Collection(s)')
		})
	}
})

$('[class^=attr_edit_]').on('keyup', () => {
	clearTimeout(typingTimer)
	typingTimer = setTimeout(updateImage, doneTypingInterval)
})
$('[class^=attr_edit_]').on('keydown', function () {
	clearTimeout(typingTimer)
})

function updateImage() {
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
		},
	}).done(() => {
		$.ajax('userpanel/show_images.js').done(() => {
			$.ajax('userpanel/show_details.js?img=' + id)
			toastr.success('Updated ' + img_info.title)
		})
	})
}
