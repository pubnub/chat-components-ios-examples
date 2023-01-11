# Live Event App

The purpose of this application is to simulate possible use cases that require iOS Chat Components to wokr under heavy load.

## Prerequisites

| Name | Requirement |
| :--- | :------ |
| [Xcode](https://developer.apple.com/xcode/resources/) | >= 13.0 |
| [npm](https://www.npmjs.com/) | >= 19.1.0 |

## Usage

1. Install the `npm` package manager. For instance, you can do it using [Homebrew](https://brew.sh/):

```
brew install npm
```

1. In the Terminal application, go to the `tomato` directory and execute `npm install`

2. Run the mock server by executing `npx tomato` in the `tomato` directory

3. See the [contracts list](https://github.com/pubnub/chat-specifications/tree/master/Contracts) with their names and purposes

4. Download them locally and load the given contract in a separate Terminal window. The `###` placeholder is a contract name you'd like to use:

```
curl -v 'http://localhost:8090/init?__contract__script__=###'
```

5. Run the `live-event-app` target on any simulator

## License

Live Event App for iOS is released under the MIT license. [See LICENSE](https://github.com/pubnub/chat-components-ios/blob/master/LICENSE) for details.
