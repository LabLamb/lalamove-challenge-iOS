# lalamove-challenge-iOS
iOS Challange for lalamove.

## Unimplemented improvements
These are some improvements that I would like to implement but did not due to out-of-scope / insufficient time.

### Better usage of cache
Cache should be a replacement / placeholer when the network resource has yet to be retrieved. This means we should load and display the cache before the network call.

As of right now, the cache is only used for when the network is returning and error, latency issue is not resolved.

### Limit model array size in the Master View
At any given time, the array should only contain N * fetch limit elements to preserve memory.

This is a trade off to processing power, but it also gives users better chance to refresh the data from server.

Alongside with the cache improvement mentioned above, this smoothens the UX.
