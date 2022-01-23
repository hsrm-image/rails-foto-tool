import jQueryBridget from 'jquery-bridget'
import imagesLoaded from 'imagesloaded' // https://imagesloaded.desandro.com/
import InfiniteScroll from 'infinite-scroll' // https://infinite-scroll.com/

imagesLoaded.makeJQueryPlugin($)
jQueryBridget('infiniteScroll', InfiniteScroll, $)

$(function () {
	let $grid = $('.grid')

	$grid.imagesLoaded().progress(function () {})

	InfiniteScroll.imagesLoaded = imagesLoaded

	if ($('nav.pagination a[rel=next]').length > 0) {
		console.log(active)
		$grid.infiniteScroll({
			// Infinite Scroll options...
			append: '.grid-element',
			//path: '/images?page={{#}}',
			path: 'nav.pagination a[rel=next]', // selector for the NEXT link (to page 2)
			prefill: true,
			hideNav: '.pagination',
			history: false, // TODO?
			status: '.page-load-status',
		})
	} else {
		$('.infinite-scroll-last').show()
		$('.infinite-scroll-request').hide()
	}
})
