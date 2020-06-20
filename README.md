# lalamove-challenge-iOS
iOS Challange for lalamove.
<br>https://github.com/LabLamb/lalamove-challenge-iOS/blob/master/challenge.md

## Target
Due to time boxing, the application layout is targeted for:

- iPhone XR
- iPhone X
- iPhone 11
- iPhone 11 Pro
- iPhone 11 Pro Max

... other devices might suffer from layout misplacement.

## Architecture
Follows VIPER architecture for ease of unit tests.

## Unimplemented improvements
These are some improvements that I would like to implement but did not due to out-of-scope / insufficient time.

### Better usage of cache
As of right now, cache is only used for when the network is returning an error, this brings up 2 issues:

1. Cache will not ease the latency issue for users, users have to wait for network error to return before using the cache.
2. Cache is not updated after displayed, there should be a mechanism to queue up and refresh cache after detecting network error.

### Limit model array size in the Master View
At any given time, the array should only contain N * fetch limit elements to preserve memory.

This is a trade off to processing power, but it also gives users a better chance to refresh the data from the server.

Alongside with the cache improvement mentioned above, this smoothens the UX.
