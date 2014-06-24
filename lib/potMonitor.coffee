# See http://tools.ietf.org/html/rfc2325#section-4 for object definitions
q = require 'q'

isValidDate = (miliseconds) ->
  return new Date(miliseconds) != 'Invalid Date'

potMonitorStatuses =
  off: 1
  brewing: 2
  holding: 3
  other: 4
  waiting: 5

potMonitorMetrics =
  espresso: 1
  'demi-tasse': 2
  cup: 3
  mug: 4
  bucket: 5

# Hide class attributes behind getters and setters in order to enforce
# read-only properties.
attributes =
  potLevel: 0
  potMetric: potMonitorMetrics.mug

class PotMonitor
  constructor: (potAdapter, options) ->
    throw "Must instantiate with a pot adapter" unless potAdapter

    attributes.potAdapter = potAdapter

    for key, val of options
      if attributes[key]?
        attributes[key] = val
      else
        throw "Undefined attribute set: #{key}"

  get: (attr) ->
    defer = q.defer()

    return attributes.potAdapter.getStatus() if attr == 'potOperStatus'
    return attributes.potAdapter.getTemperature() if attr == 'potTemperature'
    return attributes.potAdapter.getStartTime() if attr == 'potStartTime'
    return attributes.potAdapter.getLastStartTime() if attr == 'lastStartTime'

    defer.resolve(attributes[attr])
    defer.promise

  setPotStartTime: (time) ->
    defer = q.defer()

    @get('potOperStatus').then((status) ->
      unless status == potMonitorStatuses.waiting
        defer.reject("Pot is not in `waiting` status.")

      ms = time * 1000

      unless isValidDate(ms)
        defer.reject("Start time should be seconds since the Epoch.")

      attributes.potAdapter.schedule(time).then(
        -> defer.resolve(),
        (error) -> defer.reject(error)
      )
    )

    defer.promise

module.exports.PotMonitor = PotMonitor
module.exports.potMonitorStatuses = potMonitorStatuses
module.exports.potMonitorMetrics = potMonitorMetrics

