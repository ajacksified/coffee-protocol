q = require 'q'

class PotAdapter
  @extend: (opts) ->
    obj = (->)

    for key, val of PotAdapter.prototype
      if opts[key]
        obj.prototype[key] = opts[key]
      else
        obj.prototype[key] = val

    obj

  getTemperature: ->
    defer = q.defer()
    defer.reject("`getTemperature` was not implemented in PotAdapter.")
    defer.promise

  getStatus: ->
    defer = q.defer()
    defer.reject("`getStatus` was not implemented in PotAdapter.")
    defer.promise

  getStartTime: ->
    defer = q.defer()
    defer.reject("`getStartTime` was not implemented in PotAdapter.")
    defer.promise

  getLastStartTime: ->
    defer = q.defer()
    defer.reject("`getLastStartTime` was not implemented in PotAdapter.")
    defer.promise

  schedule: (time) ->
    @startTime = time

    defer = q.defer()
    defer.reject( "`schedule` was not implemented in PotAdapter.")
    defer.promise

module.exports.PotAdapter = PotAdapter

