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

1. Go to the `tomato` directory and execute the `npm install` command in the Terminal application

2. Run the mock server by executing `npx tomato` 

3. See the [list of contracts](#contracts) below and their purposes

4. Load a contract in a separate Terminal window (from the same location) as follows (where `###` is a contract name you'd like to use):

```
curl -v 'http://localhost:8090/init?__contract__script__=###'
```

5. Run the `live-event-app` target on any simulator

## Contracts

All contract files are stored in the `tomato/contracts` directory:

| Name | Implementation | Use case | 
|----- |--------- |---------- |
| `loadTest` | `load-test-1.ts` | Simulates receiving thousands of messages from multiple users | 

## License

Live Event App for iOS is released under the MIT license. [See LICENSE](https://github.com/pubnub/chat-components-ios/blob/master/LICENSE) for details.
