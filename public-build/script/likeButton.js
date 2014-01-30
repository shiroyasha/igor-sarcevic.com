define(function (require, exports, module) {var likeButton;

likeButton = function(el) {
  var circle, duration, onComplete, onEnter, onLeave, time, timer, update;
  circle = el.find('.circle');
  time = null;
  duration = 1500;
  timer = null;
  onEnter = function() {
    if (el.hasClass('complete')) {
      return;
    }
    time = Date.now();
    el.addClass('grow');
    return timer = setTimeout(onComplete, duration);
  };
  onLeave = function() {
    if (el.hasClass('complete')) {
      return;
    }
    if ((Date.now() - time) > duration) {
      return onComplete();
    } else {
      el.removeClass('grow');
      return clearTimeout(timer);
    }
  };
  onComplete = function() {
    if (!el.hasClass('complete') && el.hasClass('grow')) {
      el.removeClass('grow');
      el.addClass('complete');
      return $.post('/likes', update);
    }
  };
  update = function(data) {
    return el.find('.number .data').text(data.likes);
  };
  $.get('/likes', update);
  circle.on('mouseenter', onEnter);
  return circle.on('mouseleave', onLeave);
};

return likeButton;

});
