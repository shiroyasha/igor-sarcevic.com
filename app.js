require('newrelic');

var express = require('express');
var app = express();

var oneDay = 30*24*60*60*1000;

app.use( express.compress() );

app.use( express.static(__dirname + '/public-build-min', { maxAge: oneDay }) );

var port = Number( process.env.PORT || 3000 );
app.listen( port, function() {
	console.log( 'listening on post: ' + port );
});




var likes = 45;


app.get('/likes', function(req, res) {
	res.send(200, {likes: likes});
});

app.post('/likes', function(req, res) {
	likes++;
	res.send(200, {likes:likes});
});
