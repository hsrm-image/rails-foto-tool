import Masonry from 'masonry-layout';
import jQueryBridget from 'jquery-bridget';
import imagesLoaded from 'imagesloaded'

imagesLoaded.makeJQueryPlugin( $ );
jQueryBridget( 'masonry', Masonry, $ );

$(function(){
    var $grid = $('.cards-container').masonry({
        // options
        itemSelector: '.card',
        columnWidth: 250,
        gutter: 10,
    });
    
    $grid.imagesLoaded().progress( function() {
        $grid.masonry('layout');
    });
});


