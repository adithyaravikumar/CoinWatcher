# CoinWatcher App:
This app does the following:
* It has a home screen which displays the current price of Bitcoin which is refreshed every 60 seconds in EUR
* It has a detail table which displays historic data for the previous 14 days in EUR
* Tapping on a cell in the table launches a details screen which has the price of Bitcoin on that date in EUR, USD and GBP
* The app also features a Today Extension which has the Current Bitcoin price and is refreshed every 10 seconds in EUR

## How do I run this?
* Unzip the CoinWatcher zip file.
* Open CoinWatcher.xcworkspace
* To run the app, select the `CoinWatcher` scheme, then, build and run.
* To run the today extension, select the `CoinWatcherTodayExtension` scheme, then, build and run.
* To run the SDK framework, select the `CoinWatcherSDK` scheme, then, build and run.
* If you need to run the tests for any of the targets, please navigate to the test inspector, select the appropriate scheme and run the tests from there.

Note: I wrote this on XCode 10.2 so the best bet is to use XCode 10.2 or higher (earlier versions of XCode 10 may work but I haven't tested this).

## The Architecture:

### SDK layer
I created a framework called `CoinWatcherSDK` which contains the networking logic and model definitions. By doing this, we can reuse the coin retrieval logic in both the app and the today extension. The SDK Layer has a `CoinWatcher` class that conforms to the `CoinWatching` protocol. This does most of the heavy lifting for this app. It is responsible for periodically refreshing the current price of Bitcoin and also to fetch the current and historic prices on demand. The coin watcher is injected with an implementation of the `CoinWatcherDependencies` protocol. The protocol defines everything the coin watcher needs in order to function. The default implementation of `CoinWatcherDependencies` can be found in `CoinWatcherDependencies.swift`. However, this has been mocked out in the tests. The `NetworkCoordinator` class which conforms to `NetworkCoordinating` is responsible for making the API requests from the SDK. We have models for the current coin price and historic price and can be found under the `Models` directory.

### App layer
I initially wanted to implement complete VIPER modules for each screen. However, I realized that since we already have a storyboard I didn't need a router and also didn't need a presenter since the logic is fairly straightforward. Each screen has a view controller and an interactor. Each of these conform to appropriate protocols that make it easy for bidirectional communication between these components. The interactor speaks to the SDK Layer which is responsible for fetching the coin data. The view layer consumes the data the interactor provides and updates the UI.

### Today extension
The Today extension uses the `CoinWatcherSDK` similar to the app. We have a view controller and an interactor similar to the app. Interactor is responsible for talking to the SDK and fetching the data. The view controller gets the data from the interactor and updates the UI.

### Tests
If any of my tests break, then, the app will also break. The tests cover the business logic, edge cases and the application setup. All of these are vital for this app to work as expected.
