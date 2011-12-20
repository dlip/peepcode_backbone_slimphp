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

  window.LibraryAlbumView = AlbumView.extend()

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

  $ ->
    window.App = new BackboneTunes()
    Backbone.history.start
      pushState:true

