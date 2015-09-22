var initSlideshow, pauseSlideshow;

pauseSlideshow = function(slideshow) {
  var $window,
      toggleSlideshow;

  $window = $(window);
  toggleSlideshow = function() {
    var slideBottom, slideTop, wHeight, wTop;
    wHeight = $window.height();
    slideTop = slideshow.offset().top - wHeight;
    slideBottom = slideshow.offset().top + slideshow.height();
    wTop = $window.scrollTop();
    if (slideBottom <= wTop || wTop <= slideTop) {
      slideshow.data('royalSlider').stopAutoPlay();
    } else {
      slideshow.data('royalSlider').startAutoPlay();
    }
    $window.scroll(toggleSlideshow).resize(toggleSlideshow);
  };
};

initSlideshow = function() {
  var slideshowClass;
  slideshowClass = '.slideshow';
  if ($(slideshowClass).length) {
    $.each($(slideshowClass), function() {
      var $slideshow, options, updateSlideshow;
      $slideshow = $(this);
      updateSlideshow = false;
      options = {
        imageScaleMode: 'fill',
        imageAlignCenter: true,
        imageScalePadding: 0,
        controlNavigation: 'bullets',
        arrowsNav: true,
        arrowsNavAutoHide: true,
        arrowsNavHideOnTouch: true,
        slidesSpacing: 0,
        loop: true,
        slidesOrientation: 'horizontal',
        transitionType: 'move',
        transitionSpeed: 600,
        easeInOut: 'easeInOutSine',
        easeOut: 'easeOutSine',
        navigateByClick: false,
        sliderDrag: true,
        sliderTouch: true,
        keyboardNavEnabled: false,
        fadeinLoadedSlide: true,
        allowCSS3: true,
        addActiveClass: true,
        autoHeight: false,
        thumbs: {
          drag: true,
          touch: true,
          orientation: 'horizontal',
          arrows: true,
          spacing: 10,
          arrowsAutoHide: false,
          autoCenter: true,
          transitionSpeed: 600,
          fitInViewport: true,
          firstMargin: true,
          arrowLeft: null,
          arrowRight: null,
          appendSpan: true,
          paddingBottom: 0
        },
        fullscreen: {
          enabled: false,
          keyboardNav: true,
          buttonFS: true,
          nativeFS: false
        },
        autoPlay: {
          enabled: false,
          stopAtAction: true,
          pauseOnHover: true,
          delay: 5000
        },
        video: {
          autoHideArrows: true,
          autoHideControlNav: false,
          autoHideBlocks: false,
          youTubeCode: '<iframe src="//www.youtube.com/embed/%id%?rel=1&autoplay=1&showinfo=0" frameborder="no"></iframe>',
          vimeoCode: '<iframe src="//player.vimeo.com/video/%id%?byline=0&amp;portrait=0&amp;autoplay=1" frameborder="no" webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>'
        },
        block: {
          fadeEffect: true,
          moveEffect: 'bottom',
          moveOffset: 20,
          speed: 400,
          easing: 'easeOutSine',
          delay: 200
        }
      };
      if ($slideshow.hasClass('slideshow--autoheight')) {
        options.imageScaleMode = 'none';
        options.imageAlignCenter = false;
        options.autoHeight = true;
        updateSlideshow = true;
      }
      if ($slideshow.hasClass('slideshow--thumbnails')) {
        options.controlNavigation = 'thumbnails';
        updateSlideshow = true;
        if ($slideshow.hasClass('slideshow--thumbnails--vertical')) {
          options.thumbs.orientation = 'vertical';
        }
      }
      if ($slideshow.hasClass('slideshow--tabs')) {
        options.controlNavigation = 'tabs';
        updateSlideshow = true;
      }
      if ($slideshow.hasClass('slideshow--fade')) {
        options.transitionType = 'fade';
      }
      if ($slideshow.hasClass('slideshow--no-bullets')) {
        options.controlNavigation = 'none';
      }
      if ($slideshow.hasClass('slideshow--no-arrows')) {
        options.arrowsNav = false;
      }
      if ($slideshow.hasClass('slideshow--autoplay') && $slideshow.children().length >= 1) {
        options.autoPlay.enabled = true;
        options.autoPlay.stopAtAction = false;
        options.autoPlay.pauseOnHover = true;
      }
      if ($slideshow.children().length <= 1) {
        options.controlNavigation = 'none';
        options.arrowsNav = false;
        options.sliderDrag = false;
        options.sliderTouch = false;
        $slideshow.royalSlider(options);
      } else {
        $slideshow.royalSlider(options);
        pauseSlideshow($slideshow);
      }
      $(window).load(function() {
        $slideshow.data('royalSlider').updateSliderSize(true);
      });
    });
  }
};

$(document).ready(function() {
  initSlideshow();
});
