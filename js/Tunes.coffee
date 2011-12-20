$ ->
  window.Album = Backbone.Model.extend()

  window.AlbumView = Backbone.View.extend
    tagName: 'li'
    className: 'album'
    initialize: ->
      _.bindAll this, 'render'
      this.model.bind 'change', this.render
      this.template = _.template($('#album-template').html())
    render: ->
      renderedContent = this.template this.model.toJSON()
      $(this.el).html renderedContent
      this
  
  window.Albums = Backbone.Collection.extend
    model: Album
    url: '/albums'

  window.Playlist = Albums.extend
    isFirstAlbum: ->
      index is 0

    isLastAlbum: ->
      index is this.models.length - 1

  window.library = new Albums()

  window.LibraryAlbumView = AlbumView.extend
    events:
      'click .queue.add': 'select'

    select: ->
      this.collection.trigger('select', this.model)
      console.log('Triggered select', this.model)

  window.LibraryView = Backbone.View.extend
    tagName: 'section'
    className: 'library'
    initialize: ->
      _.bindAll this, 'render'
      this.template = _.template($('#library-template').html())
      this.collection.bind('reset', this.render)

    render: ->
      $albums = null
      collection = this.collection
      $(this.el).html(this.template())
      $albums = this.$('.albums')
      collection.each (album) ->
        view = new LibraryAlbumView
          model: album
          collection: collection

        $albums.append(view.render().el)
      this

  window.Player = Backbone.Model.extend
    defaults:
      'currentAlbumIndex': 0
      'currentTrackIndex': 0
      'state': 'stop'

    initialize: ->
      this.playlist = new Playlist()

    play: ->
      this.set 'state': 'play'

    pause: ->
      this.set 'state': 'pause'

    isPlaying: ->
      this.get 'state' is 'play'

    isPlaying: ->
      !this.isPlaying()

    currentAlbum: ->
      this.playlist.at(this.get 'currentAlbumIndex')

    currentTrackUrl: ->
      album = this.currentAlbum()
      album.trackUrlAtIndex(this.get 'currentTrackIndex')

    nextTrack: ->
      currentTrackIndex = this.get 'currentTrackIndex'
      currentAlbumIndex = this.get 'currentAlbumIndex'

      if (this.currentAlbum().isLastTrack currentTrackIndex)
        if (this.playlist.isLastAlbum currentAlbumIndex )
          this.set {'currentAlbumIndex': 0}
          this.set {'currentTrackIndex': 0}
        else
          this.set {'currentAlbumIndex': currentAlbumIndex + 1}
          this.set {'currentTrackIndex': 0}
      else
      this.set {'currentTrackIndex': currentTrackIndex + 1}

      this.logCurrentAlbumAndTrack()

    prevTrack: ->
        currentTrackIndex = this.get 'currentTrackIndex'
        currentAlbumIndex = this.get 'currentAlbumIndex'
        lastModelIndex = 0
        if this.currentAlbum().isFirstTrack currentTrackIndex
            if this.playlist.isFirstAlbum currentAlbumIndex
                lastModelIndex = this.playlist.models.length - 1
                this.set {'currentAlbumIndex': lastModelIndex}
            else
              this.set {'currentAlbumIndex': currentAlbumIndex - 1}
            #In either case, go to last track on album
            lastTrackIndex = (this.currentAlbum().get 'tracks').length - 1
            this.set {'currentTrackIndex': lastTrackIndex}
        else
            this.set {'currentTrackIndex': currentTrackIndex - 1}
        this.logCurrentAlbumAndTrack()

    logCurrentAlbumAndTrack: ->
        console.log("Player " + this.get('currentAlbumIndex') + ':' + this.get('currentTrackIndex'), this)

  window.library = new Albums()

  window.BackboneTunes = Backbone.Router.extend
    routes:
      '': 'home'
      'blank': 'blank'

    initialize: ->
      this.libraryView = new LibraryView
        collection: window.library

    home: ->
      $container = $ '#container'
      $container.empty()
      $container.append(this.libraryView.render().el)

    blank: ->
      $('#container').empty()
      $('#container').text('blank')

  window.App = new BackboneTunes()
  Backbone.history.start
    pushState:true

