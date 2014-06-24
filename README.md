Coffee-Protocol
===============

An implementation of [RFC 2325](http://tools.ietf.org/html/rfc2325) to help
with the implementation of an [HTCPCP](http://tools.ietf.org/html/rfc2324)
compliant server.

Installation
------------

Use `npm install coffee-protocol`, or clone the repository into your preferred
location.

Usage
-----

Objects are defined in accordance with [section 4](http://tools.ietf.org/html/rfc2325#section-4)
of the RFC and can be used as follows:

```javascript
var coffeeProtocol = require('./index'),
    q = require('q');

var pot = new coffeeProtocol.Pot({
  potName: 'Office French Press',
  potType: coffeeProtocol.potTypes['french-press'],
  potCapacity: 2,
  potLocation: 'The kitchen'
});

var PotAdapter = coffeeProtocol.PotAdapter.extend({
  getTemperature: function(){
    var defer = q.defer();
    // Communicate to your coffee pot.
    defer.resolve(100);
    return defer.promise;
  },
  getStatus: function(){
    var defer = q.defer();
    // Communicate to your coffee pot.
    defer.resolve(coffeeProtocol.potMonitorStatuses.waiting);
    return defer.promise;
  },
  getStartTime: function(){
    var defer = q.defer();
    // Communicate to your coffee pot.
    defer.resolve(Date.now());
    return defer.promise;
  },
});

var potAdapter = new PotAdapter();

var potMonitor = new coffeeProtocol.PotMonitor(potAdapter, {
  potLevel: 0,
  potMetric: coffeeProtocol.potMonitorMetrics.mug
});

var date = new Date();
var startTime = new Date(date.getTime() + (30 * 60 * 1000));

pot.setPotLocation('The desk of Jack Lawson');
potMonitor.setPotStartTime(startTime.getTime() / 1000);

// potMonitor `get`s are promises in case we have to do an async request
// to get coffee pot status through potAdapter.
potMonitor.get('potStartTime').then(function(time){
  console.log(
    pot.get('potName') + " will start at time " + potMonitor.get('potStartTime') +
    " at location " + pot.get('potLocation')
  )
}, function(){
  console.log(arguments);
});
```

