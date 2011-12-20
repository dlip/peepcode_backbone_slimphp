<html>
<head>
<title>Backbone Test</title>

<link rel="stylesheet" type="text/css" href="style/screen.css">
<link rel="stylesheet" type="text/css" href="style/fancypants.css">

<script src="js/underscore.js"></script>
<script src="js/jquery-1.7.1.min.js"></script>
<script src="js/backbone.js"></script>
<script src="js/Tunes.js"></script>

<script type="text/template" id="album-template">
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
