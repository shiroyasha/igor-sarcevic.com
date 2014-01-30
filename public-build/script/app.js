define(function (require, exports, module) {var likeButton, shareOnSelect;

likeButton = require('likeButton');

shareOnSelect = require('shareOnSelect');

$(function() {
  likeButton($('.likes'));
  return shareOnSelect('#share');
});

});
