# lalamove-challenge-iOS
iOS Challange for lalamove.
<br>https://github.com/LabLamb/lalamove-challenge-iOS/blob/master/challenge.md

## Features
### Business requirements
- Retrieves a list of delivery on launch
- Display delivery details on selecting an item on the list
- Allow users to toggle favorite/un-favorite in the delivery details
- Delivery's favorite is presistance per user session
- Delivery fee is calculated with `deliveryFee + surcharge`
- Error prompt if fails to retrieve data from server **AND** no cache is available

### Technical requirements
- Delivery cached in `FileManager`'s `applicationDirectory` as encoded with `JSONEncoder`
- Infinite scrolling `UIViewController`
- VIPER architecture
- Unit Test on `DeliveryMaster` and `DeliveryDetails` screens
- UI Test on common use cases


## Unimplemented improvements
These are some improvements that I would like to implement but did not due to out-of-scope / insufficient time.

### Device targets
Due to time boxing, the application layout is targeted for:

- iPhone XR
- iPhone X
- iPhone 11
- iPhone 11 Pro
- iPhone 11 Pro Max

... other devices might suffer from layout misplacement.

### Better usage of cache
As of right now, cache is only used for when the network is returning an error, this brings up 2 issues:

1. Cache will not ease the latency issue for users, users have to wait for network error to return before using the cache.
2. Cache is not re-fetched and updated after displayed, there should be a mechanism to queue up and refresh cache after detecting network error.

### Limit model array size in the Master View
At any given time, the array should only contain N * fetch limit elements to preserve memory.

This is a trade off to processing power, but it also gives users a better chance to refresh the data from the server.

Alongside with the cache improvement mentioned above, this smoothens the UX.

### Unit test
I have only written unit tests for the two VIPER classes, more could be done on the `DeliveryStateHandler` and `DeliveryLocalStorageHandler` etc.

### UI Test
Currently uses real connection to test, it will be much better if the testing could be done with various mock json data in a mock environment. This will enable:

- Running UI Test on a offline CI pipeline
- Neglect timeout issue with the pipeline
