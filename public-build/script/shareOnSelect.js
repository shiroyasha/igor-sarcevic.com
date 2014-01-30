define(function (require, exports, module) {var shareOnSelect;

shareOnSelect = function(selector) {
  var handler, share;
  share = $(selector);
  share.hide();
  if (document.getSelection == null) {
    return;
  }
  handler = function() {
    var rect, selection, test;
    selection = document.getSelection();
    test = selection.type === 'None' || selection.rangeCount !== 1 || (selection.getRangeAt == null) || $(selection.anchorNode.parentElement).closest('[data-sharable]').length === 0 || selection.toString().length <= 10;
    if (test) {
      share.fadeOut(200);
      return;
    } else {
      share.hide();
    }
    if (selection.getRangeAt(0).getBoundingClientRect == null) {
      return;
    }
    rect = selection.getRangeAt(0).getBoundingClientRect();
    share.css('top', $(window).scrollTop() + rect.top - 60 + 'px');
    share.css('left', rect.left + (rect.width - 80) / 2 + 'px');
    return share.fadeIn();
  };
  return $(document).on('mouseup', _.throttle(handler, 100, {
    leading: false
  }));
};

return shareOnSelect;

});
