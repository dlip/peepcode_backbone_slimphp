<html>
<head>
<title>Backbone Test</title>

<link rel="stylesheet" type="text/css" href="style/screen.css">
<link rel="stylesheet" type="text/css" href="style/fancypants.css">

<script src="js/vendor/modernizr-1.6.min.js"></script>
<script src="js/vendor/jquery-1.5.1.min.js"></script>
<script src="js/vendor/underscore.js"></script>
<script src="js/vendor/backbone.js"></script>

<script src="js/Tunes.js"></script>

<script type="text/template" id="album-template">
  <button class="queue add"><img src="/images/add.png" /></button>
  <button class="queue remove"><img src="/images/remove.png" /></button>
  <span class="album-title"><%= title %></span>
  <span class="artist-name"><%= artist %></span>
  <ol class="tracks">
    <% _.each(tracks, function(track) { %>
      <li><%= track.title %></li>
    <% }); %>
  </ol>
</script>

<script type="text/template" id="library-template">
  <h1>Music Library</h1>
  <ul class="albums"></ul>
</script>
</head>

<script type="application/javascript">
  $(function() {
    window.library.fetch();
  });
</script>

<body>
<div id="container"></div>
</body>
</html>
