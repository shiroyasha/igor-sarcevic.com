

likeButton = (el) ->
  circle = el.find('.circle')
  
  time = null
  duration = 1500
  timer = null
  
  onEnter = ->
    if el.hasClass('complete') then return
  
    time = Date.now()
    el.addClass('grow')
    
    timer = setTimeout onComplete, duration
    
  onLeave = ->
    if el.hasClass('complete') then return
  
    if ( Date.now() - time ) > duration
      onComplete()
    else
      el.removeClass('grow')
      clearTimeout timer
      
  onComplete = ->
    if not el.hasClass('complete') and el.hasClass('grow')
      el.removeClass('grow')
      el.addClass('complete')

      $.post '/likes', update

  update = (data) ->
    el.find('.number .data').text(data.likes)
      
    
  $.get '/likes', update
  circle.on 'mouseenter', onEnter
  circle.on 'mouseleave', onLeave


return likeButton