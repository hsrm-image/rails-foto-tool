import Masonry from 'masonry-layout'; //https://masonry.desandro.com
import jQueryBridget from 'jquery-bridget';
import imagesLoaded from 'imagesloaded' // https://imagesloaded.desandro.com/
import InfiniteScroll from 'infinite-scroll' // https://infinite-scroll.com/

imagesLoaded.makeJQueryPlugin( $ );
jQueryBridget( 'masonry', Masonry, $ );
jQueryBridget( 'infiniteScroll', InfiniteScroll, $ );

$(function(){
    var $grid = $('#cards-container').masonry({
        // options
        itemSelector: '.card',
        columnWidth: 250,
        gutter: 10,
        horizontalOrder: true
    });
    
    $grid.imagesLoaded().progress( function() {
        $grid.masonry('layout');
    });
    
    let msnry = $grid.data('masonry');
    InfiniteScroll.imagesLoaded = imagesLoaded;
    $grid.infiniteScroll({ 
        // Infinite Scroll options...
        append: '.card',
        outlayer: msnry,
        //path: '/images?page={{#}}',
        path: "nav.pagination a[rel=next]", // selector for the NEXT link (to page 2)
        prefill: true,
        hideNav: '.pagination',
        history: false, // TODO?
        status: '.page-load-status'
    });
});


