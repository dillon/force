Backbone = require 'backbone'
_ = require 'underscore'
{ ARTSY_URL, CURRENT_USER } = require('sharify').data
ArtworkCollection = require './artwork_collection.coffee'

module.exports = class CurrentUser extends Backbone.Model

  url: -> "#{ARTSY_URL}/api/v1/me"

  # Should only be run after the user has been fetched and has an id
  initializeDefaultArtworkCollection: (options) ->
    unless @get('artworkCollections')?.length > 0
      @set artworkCollections: [new ArtworkCollection(userId: @get('id'))]
    @defaultArtworkCollection().fetch(options) unless @defaultArtworkCollection.fetched

  defaultArtworkCollection: -> @get('artworkCollections')[0]

  # Add the access token to fetches and saves
  sync: (method, model, options = {}) ->
    options.data ?= {}
    options.data.access_token = @get 'accessToken'
    super

  # Saves the artwork to the user's saved-artwork collection. API creates colletion if user's first save.
  saveArtwork: (artworkId, options = {}) =>
    @defaultArtworkCollection().saveArtwork(artworkId, options)

  # Removes the artwork from the user's saved-artwork collection.
  removeArtwork: (artworkId, options = {}) =>
    @defaultArtworkCollection().unsaveArtwork(artworkId, options)

  # Convenience for getting the bootstrapped user or returning null.
  # This should only be used on the client.
  @orNull: ->
    if CURRENT_USER then new @(CURRENT_USER) else null

# Methods for the a user's Order
  fetchPendingOrder: (options) ->
    url = "#{@url()}/order/pending"
    new Backbone.Model().fetch _.extend({ url: url, data: { access_token: @get('accessToken') } }, options)

  updateOrder: (orderId, options) ->
    url = "#{@url()}/order/#{orderId}"
    new Backbone.Model(id: orderId).save({ access_token: @get('accessToken') }, _.extend({url: url}, options))

  submitOrder: (orderId, options) ->
    url = "#{@url()}/order/#{orderId}/submit"
    new Backbone.Model(id: orderId).save({ access_token: @get('accessToken') }, _.extend({url: url}, options))

  resumeOrder: (orderId, token, options) ->
    url = "#{@url()}/order/#{orderId}/resume"
    new Backbone.Model(id: orderId).save({ access_token: @get('accessToken'), token: token }, _.extend({url: url}, options))
