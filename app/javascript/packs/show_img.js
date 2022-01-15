import Dropzone from 'dropzone'

var drop = undefined
var input = document.querySelector('input[type=file]')
if (!drop) {
	drop = new Dropzone('#upload', {
		paramName: 'image[image_file]',
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
		console.log('blob: ', blob)
		if (error) return
		console.log('direct-upload:success')
		//just requesting the correct partial gets it to display
		// beacuse of ruby routing
		$.ajax('userpanels/show_images.js')
	})
})
