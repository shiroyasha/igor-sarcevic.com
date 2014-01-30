shareOnSelect = (selector) ->
  share = $(selector)
  share.hide()
  
  if not document.getSelection? then return
  
  handler = ->
    selection = document.getSelection()

    test = selection.type == 'None' ||
           selection.rangeCount != 1 ||
           not selection.getRangeAt? ||
           #selection.anchorNode.parentElement != selection.focusNode.parentElement ||
           $(selection.anchorNode.parentElement).closest('[data-sharable]').length == 0 ||
           selection.toString().length <= 10
    
    if test
      share.fadeOut(200)
      return
    else
      share.hide()
      
    if not selection.getRangeAt(0).getBoundingClientRect? then return
  
    rect = selection.getRangeAt(0).getBoundingClientRect()
  

    share.css('top', $(window).scrollTop() + rect.top - 60 + 'px')
    share.css('left', rect.left + (rect.width - 80)/2 + 'px')
  
    share.fadeIn()


  $(document).on 'mouseup', _.throttle( handler, 100, {leading: false} )

return shareOnSelect