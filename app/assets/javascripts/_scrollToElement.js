var scrollToElement = function(elem, padding, speed, easing) {
  var $window, elemOffset, mainElement, removeScrollingClass, wheight;
  elem = typeof elem !== 'undefined' ? elem : "html, body";
  padding = typeof padding !== 'undefined' ? padding : 0;
  speed = typeof speed !== 'undefined' ? speed : 400;
  easing = typeof easing !== 'undefined' ? easing : "swing";
  mainElement = $('html, body');
  $window = $(window);
  if ( $window.width() < 769 ) {
    padding = padding + 60;
  } else {
    padding = padding + 52;
  }
  removeScrollingClass = function() {
    return $('html').removeClass('scrolling');
  };
  if ($(elem).length && !$('html').hasClass('scrolling')) {
    elemOffset = $(elem).offset().top - $('body').offset().top;
    $('html').addClass('scrolling');
    return mainElement.animate({
      scrollTop: (elemOffset - padding) + "px"
    }, speed, easing, removeScrollingClass);
  } else if (elem === '#top' && !$('html').hasClass('scrolling')) {
    $('html').addClass('scrolling');
    return mainElement.animate({
      scrollTop: 0
    }, speed, easing, removeScrollingClass);
  } else if (elem === '#bottom' && !$('html').hasClass('scrolling')) {
    wheight = $window.height();
    $('html').addClass('scrolling');
    return mainElement.animate({
      scrollTop: wheight
    }, speed, easing, removeScrollingClass);
  } else if (elem === '#down' && !$('html').hasClass('scrolling')) {
    $('html').addClass('scrolling');
    return mainElement.animate({
      scrollTop: "" + ($window.scrollTop() + 300)
    }, speed, easing, removeScrollingClass);
  }
};

var scrollLink = function() {
  $('.scroll-to').on('click', function(e) {
    e.preventDefault();
    var $this = $(this),
        target = null,
        offset = '';
    if (!$this.data('target')) {
      target = $this.attr('href');
    } else {
      target = $this.data('target');
    }
    if ($this.data('offset')) {
      offset = offset + $this.data('offset');
    }
    scrollToElement(target, offset);
    $this.blur();
    return false;
  });
};

var jumpToSection = function() {
  if ($('#jumpToSection').length) {
    var sectionID = $('#jumpToSection').val(),
        $sectionElement = $('#' + sectionID);
    if($sectionElement.length) {
      scrollToElement($sectionElement);
    }
  }
};

$(window).load(function() {
  scrollLink();
  jumpToSection();
});
