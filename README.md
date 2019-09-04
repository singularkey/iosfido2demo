# SingularKey
![SingularKey Logo](http://singularkey.com/wp-content/uploads/2018/09/SingularKeyLOGOS1.svg)

SingularKey is an authenticator that uses [FIDO2](https://fidoalliance.org) and Web Authentication API ([WebAuthn](https://www.w3.org/TR/webauthn/)). 

## Getting Started with Example 2
- Get your `rpid` (Relying Party Id), `origin` and `RP server URL` and `singularKeyAPIKey` from SingularKey dev portal.

## Prerequisites
It requies iOS version `9.0 or abve.`

## Installing
- Drag and drop `SingularKey.framework` bundle into your Xcode project (in Frameworks directory). Make sure you have **Copy items if needed** check off.
- Open `General` tab in your project settings and drag `SingularKey.framework` in Embedded Binaries section or do **+** and add.
- Open `Config.swift` file and set `baseURL`, `rpId` and `origin`
- All the API calls is made POST


## Register with name
1. In your register viewController
```
import SingularKey
...
```

2. Add following code in your `viewController's` register button action.
Ask user to input name (in text field). Send `name` to `/register/initiate` API

3. If the API call of step 2 is successful, get challenge from `initiateRegistrationResponse["Challenge"]` and call SingularKey's framework function to create credentials (using biometric or other available access Control methods)

```
let modality = SecAccessControlCreateFlags.biometryAny
// use rpid and origin from your Config
let credentials = CredentialsManager()
credentials.credentialsCreate(rpId: Config.rpId, origin: Config.origin, modality: modality, challenge: challenge) { (result, error) in
```

4. If there is no error on step 3, you will get JSON `result`.
get `result["createCredResponse"]` values and send them to `/register/complete` API


## Login with name
1. In your login viewController, add this code outside `viewDidLoad` function.
```
import SingularKey
...

let credManager = CredentialsManager()
```

2. Add following code in your `viewController's` login button action.
Send username to this API `/auth/initiate` with name as a parameter. You can find API end point details in `NetworkAPIUtils.swift` file.

3. In the successful callback of step 2 network call, get `challenge` and publicKeyId (which is one of the item in the array of `allowCredentials` key) and check in the internal stored credentials using helper function.


```
self.credManager.findInternalCredAndMatch(rpId: Config.rpId, origin: Config.origin, publicKeyId: publicKeyId, challenge: challenge, callback: { (result, errorMessage) in
// if any matching credentials found then we get result, otherwise error
```
4. The result of above callback is the JSON data that you need to send to `/auth/complete` API. If the response of this API call is success then you are authenticated.

## using credentialsCreate and credentialsGet
These functions are only useful if you want to handle FIDO API requst to your own proxy server. You will have to supply your own RPID, origin, challenge and modality option.
Modality is the authentication type. The available modality option will be available here: https://developer.apple.com/documentation/security/secaccesscontrolcreateflags


## Example Project 
You can find example project ( `iOS Example2`) that includes everything mentioned above. Please check it.

## FAQ
na

## Credits
na

## Licence
na
