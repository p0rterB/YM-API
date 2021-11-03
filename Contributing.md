# How to contribute

[Russian Contribute](https://github.com/p0rterB/YM-API/blob/main/Contributing_RU.md)

Contributing to this project has no differents than contributing to other open-source projects on GitHub, but there are several key points about which worth knowing and remembering.

The main types of contributions:
- adding new fields to existing classes;
- functional description of already existing fields and classes marked *TODO*;
- adding new classes;
- avoiding optional fields in entities by writing your own implementations of model decoders;
- implementing a new method to the client (method signature and method of the API request itself);
- implementing examples of use to the [Project](Project) folder;
- adding new tests both for API requests and the logic of operation of all API entities;
- implementing api functions: track play state (start, finish) for Alice's shots;
- implementing CarPlay support.

## Pull Requests

PRs should be done in the *development* branch. PR hasn't any specific design template. If this closes some issue, then you should refer to it with a key the word "close". For example, "close # 123".

## Tests

At the moment, the integration tests cover the part of the code responsible for the regular behavior of the module (Sending a request - checking the response, checking the parsing of entities). Therefore, what is required now is tests for erroneous input data for API requests, tests for receiving non-standard responses from the API for requests (if any).

To deploy the test infrastructure, you must specify in [TestConstants.swift](https://github.com/p0rterB/YM-API/blob/main/Project/YM-Tests/TestConstants.swift) account data: **uid** and **token** for all API requests, **xToken** needs only for retrieving user avatar in app context, except for login (mail) and password. To request an account login, you also need to specify **login** and **pass** to login to your account.
```swift
public static let login: String = "YOUR_LOGIN_OR_EMAIL"
public static let pass: String = "YOUR_PASS"

public static let xToken: String = "YOUR_XTOKEN"//after success pasword auth you can paste x_token here
public static let token: String = "YOUR_TOKEN"//after login you can paste got token here
public static let uid: Int = 12345678//your account uid
```
**Important! When you're adding tests to the repository, don't add *TestConstants.swift* or remove your test account details from the file**

Tests are available at [Project/YM-Tests](Project/YM-Tests).
