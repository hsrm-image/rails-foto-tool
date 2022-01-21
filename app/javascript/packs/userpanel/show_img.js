import Dropzone from 'dropzone'

var drop = undefined
var input = document.querySelector('input[type=file]')
if (!drop) {
	drop = new Dropzone('#upload', {
		paramName: 'image[image_file]',
		parallelUploads: 1,
	})
}

drop.on('addedfile', file => {
	const url = input.dataset.directUploadUrl
	const token = input.dataset.directUploadToken
	const attachmentName = input.dataset.directUploadAttachmentName
	const upload = new window.ActiveStorage.DirectUpload(
		file,
		url,
		token,
		attachmentName,
	)
	upload.create((error, blob) => {
		if (error) return
		//just requesting the correct partial gets it to display
		// beacuse of ruby routing
		$.ajax('userpanel/show_images.js')
	})
})

drop.on('error', file => {
	drop.removeFile(file)
	console.log(file)
	toastr.warning('Error while uploading:' + file.name)
})

drop.on('success', file => {
	drop.removeFile(file)
	$.ajax('userpanel/show_images.js')
})
