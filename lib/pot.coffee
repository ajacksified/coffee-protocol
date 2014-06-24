# See http://tools.ietf.org/html/rfc2325#section-4 for object definitions

potTypes =
  'automatic-drip': 1
  'percolator': 2
  'french-press': 3
  'espresso': 4

# Hide class attributes behind getters and setters in order to enforce
# read-only properties.
attributes =
  potName: ''
  potCapacity: 0
  potType: potTypes['automatic-drip']
  potLocation: ''

class Pot
  constructor: (options) ->
    for key, val of options
      if attributes[key]?
        attributes[key] = val
      else
        throw "Undefined attribute set: #{key}"

  get: (attr) ->
    return attributes[attr]

  setPotLocation: (location) ->
    if location and typeof location == 'string'
      if location.length <= 255
        attributes.potLocation = location
      else
        throw "Location length must be at or below 255 characters. Location was " +
              "#{location.length} characters."
    else
      throw "Location must be a string. Passed in #{typeof location}."

    @



module.exports.Pot = Pot
module.exports.potTypes = potTypes

