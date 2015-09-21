mobileMenuToggle = () ->
  $('.mobile-menu-toggle').click ->
    $('body').toggleClass("mobileNav-open")

mobileToggleChildren = () ->
  toggleLink = $('.mobile-menu .toggle-children')
  toggleLink.click ->
    e.preventDefault()
    $link = $(this)
    targetId = $link.attr('href')
    $link.toggleClass('showing-children')
    $(targetId).toggleClass('show-children')
    false

$ ->
  mobileMenuToggle()
  mobileToggleChildren()
