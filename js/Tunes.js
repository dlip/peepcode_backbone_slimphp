$(function() {
  window.Album = Backbone.Model.extend();
  window.AlbumView = Backbone.View.extend({
    tagName: 'li',
    className: 'album',
    initialize: function() {
      _.bindAll(this, 'render');
      this.model.bind('change', this.render);
      return this.template = _.template($('#album-template').html());
    },
    render: function() {
      var renderedContent;
      renderedContent = this.template(this.model.toJSON());
      $(this.el).html(renderedContent);
      return this;
    }
  });
  window.Albums = Backbone.Collection.extend({
    model: Album,
    url: '/albums'
  });
  window.Playlist = Albums.extend({
    isFirstAlbum: function() {
      return index === 0;
    },
    isLastAlbum: function() {
      return index === this.models.length - 1;
    }
  });
  window.library = new Albums();
  window.LibraryAlbumView = AlbumView.extend({
    events: {
      'click .queue.add': 'select'
    },
    select: function() {
      this.collection.trigger('select', this.model);
      return console.log('Triggered select', this.model);
    }
  });
  window.LibraryView = Backbone.View.extend({
    tagName: 'section',
    className: 'library',
    initialize: function() {
      _.bindAll(this, 'render');
      this.template = _.template($('#library-template').html());
      return this.collection.bind('reset', this.render);
    },
    render: function() {
      var $albums, collection;
      $albums = null;
      collection = this.collection;
      $(this.el).html(this.template());
      $albums = this.$('.albums');
      collection.each(function(album) {
        var view;
        view = new LibraryAlbumView({
          model: album,
          collection: collection
        });
        return $albums.append(view.render().el);
      });
      return this;
    }
  });
  window.Player = Backbone.Model.extend({
    defaults: {
      'currentAlbumIndex': 0,
      'currentTrackIndex': 0,
      'state': 'stop'
    },
    initialize: function() {
      return this.playlist = new Playlist();
    },
    play: function() {
      return this.set({
        'state': 'play'
      });
    },
    pause: function() {
      return this.set({
        'state': 'pause'
      });
    },
    isPlaying: function() {
      return this.get('state' === 'play');
    },
    isPlaying: function() {
      return !this.isPlaying();
    },
    currentAlbum: function() {
      return this.playlist.at(this.get('currentAlbumIndex'));
    },
    currentTrackUrl: function() {
      var album;
      album = this.currentAlbum();
      return album.trackUrlAtIndex(this.get('currentTrackIndex'));
    },
    nextTrack: function() {
      var currentAlbumIndex, currentTrackIndex;
      currentTrackIndex = this.get('currentTrackIndex');
      currentAlbumIndex = this.get('currentAlbumIndex');
      if (this.currentAlbum().isLastTrack(currentTrackIndex)) {
        if (this.playlist.isLastAlbum(currentAlbumIndex)) {
          this.set({
            'currentAlbumIndex': 0
          });
          this.set({
            'currentTrackIndex': 0
          });
        } else {
          this.set({
            'currentAlbumIndex': currentAlbumIndex + 1
          });
          this.set({
            'currentTrackIndex': 0
          });
        }
      } else {

      }
      this.set({
        'currentTrackIndex': currentTrackIndex + 1
      });
      return this.logCurrentAlbumAndTrack();
    },
    prevTrack: function() {
      var currentAlbumIndex, currentTrackIndex, lastModelIndex, lastTrackIndex;
      currentTrackIndex = this.get('currentTrackIndex');
      currentAlbumIndex = this.get('currentAlbumIndex');
      lastModelIndex = 0;
      if (this.currentAlbum().isFirstTrack(currentTrackIndex)) {
        if (this.playlist.isFirstAlbum(currentAlbumIndex)) {
          lastModelIndex = this.playlist.models.length - 1;
          this.set({
            'currentAlbumIndex': lastModelIndex
          });
        } else {
          this.set({
            'currentAlbumIndex': currentAlbumIndex - 1
          });
        }
        lastTrackIndex = (this.currentAlbum().get('tracks')).length - 1;
        this.set({
          'currentTrackIndex': lastTrackIndex
        });
      } else {
        this.set({
          'currentTrackIndex': currentTrackIndex - 1
        });
      }
      return this.logCurrentAlbumAndTrack();
    },
    logCurrentAlbumAndTrack: function() {
      return console.log("Player " + this.get('currentAlbumIndex') + ':' + this.get('currentTrackIndex'), this);
    }
  });
  window.library = new Albums();
  window.BackboneTunes = Backbone.Router.extend({
    routes: {
      '': 'home',
      'blank': 'blank'
    },
    initialize: function() {
      return this.libraryView = new LibraryView({
        collection: window.library
      });
    },
    home: function() {
      var $container;
      $container = $('#container');
      $container.empty();
      return $container.append(this.libraryView.render().el);
    },
    blank: function() {
      $('#container').empty();
      return $('#container').text('blank');
    }
  });
  window.App = new BackboneTunes();
  return Backbone.history.start({
    pushState: true
  });
});