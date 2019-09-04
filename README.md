# Singular Key iOS FIDO2 Demo

This project demonstrates the registration and use of a FIDO2 credential in an iOS App. It uses Singular Key's FIDO2 native API and Singular Key's FIDO2 Cloud Service. FIDO2 Credentials are phishing resistant, attested public key based credentials for strong authentication of users.
The demo supports iOS authenticator using biometrics (faceId,touchId) and device passcode

This demonstration requires Demo RP (Relying Party) Server (https://github.com/singularkey/webauthndemo) which communicates to Singular Key's FIDO2 Cloud Service. Please contact support (`support@singularkey.com`) for your `free Api Key`.

------------

### Dependencies
* iOS Device 9.0 or above with FaceId/TouchId/Passcode enabled
* Singular Key iOS Framework
* RP Server (https://github.com/singularkey/webauthndemo) - e.g. https://api.yourcompany.com
* Singular Key API Key

### Install
```sh
git clone https://github.com/singularkey/iosfido2demo.git
```

### Configure

##### RP Server  (https://github.com/singularkey/webauthndemo)

* View Readme.md for https://github.com/singularkey/webauthndemo to install and configure the RP Server
*  The iOS FIDO2 App needs to communicate with the RP Server on `https://`, so you will either need to front the Node RP     Server with a reverse Proxy like Nginx and install the certificate in Nginx or just enable https on the Node Service itself.  In order to enable https on the Node Service, edit `server/config.json
```js
"https":{
    "enabled":false,
    "keyFilePath":"PATH_TO_SSL_KEY_FILE",
    "certFilePath":"PATH_TO_SSL_CERT_FILE"
  }
```

##### Associate your website with your iOS App  - Update `apple-app-site-association` file
* To use the FIDO2 API in your iOS App, you will need to associate your iOS app with your website. The iOS App uses the `RPID` (you'll configure in the next section) to construct a URL to fetch the apple-app-site-association file from your RP Server.  The url is `https://<RPID>/.well-known/apple-app-site-association`
We have provided you with the file in the RP Server `webapp/.well-known/apple-app-site-association`

* Update the /webapp/.well-known/apple-app-site-association file in the RP Server project by adding your bundler identifier in the `apps` list
```
{
   "webcredentials": {
       "apps": ["com.singularkey.iOSFido2Demo"]
    }
}
```

##### iOS FIDO2 App (This Repository)
* Edit `Config.swift`
```Js
static let baseURL = "ADD_YOUR_RP_SERVER_URL_HERE" //e.g., https://api.singularkey.com
static let rpId = "ADD_YOUR_RPID_HERE"           //e.g., api.singularkey.com  RPID is a valid domain string that identifies the WebAuthn Relying Party on whose behalf a given registration or authentication ceremony is being performed. A public key credential can only be used for authentication with the same entity (as identified by RP ID) it was registered with.
static let origin =  "ios:bundle-id:com.singularkey.iOSFido2Demo" //"ios:bundle-di:<yourBundleId>"
```
* Install Singular Key Framework
    * Singular Key Framework comes packaged with this demo . But in case you need to re-install it, here are the instructions:
        - Drag and drop `SingularKey.framework` bundle into your Xcode project (in Frameworks directory). Make sure you have **Copy items if needed** check off.
        - Open `General` tab in your project settings and drag `SingularKey.framework` in Embedded Binaries section or do **+** and add.

##### Singular Key FIDO2 Settings  (https://devportal.singularkey.com)
* There are two main settings for the FIDO2 Section in your client app in the Singular Key Admin Portal. Log into the Admin portal using the credentials provided to you.
    * `Supported Origin Domain Name`: In case of iOS, the format for origin is  ios:bundle-id:<YOUR_BUNDLE_IDENTIFIER> (e.g. ios:bundle-id:com.singularkey.iOSFido2Demo). When attempting to register a new FIDO2 credential or login using an existing FIDO2 credential using the iOS Demo app, if you see a client mismatch error in the RP Server logs, it means the origin defined in the iOS app and the one configured in the portal are not the same
    * `Rp Id`: Enable this and update the value with the RPID used in the iOS Fido2 App. (in the section above)

Click on `Save` towards the bottom of the Fido2 settings form to persist your changes.

### Run
Build your IOS App and install it on an iOS device. Below is a demonstration of the functionality:

<img src="https://singularkey.s3-us-west-2.amazonaws.com/iOSFido2Demo.gif" width="50%" height="50%" />

### Architecture
`iOS FIDO2 Demo App` --> `RP Server (Default Port 3001)` API --> `Singular Key's FIDO Cloud Service`

### Key Files
 * `SignUpViewController.swift`  : Check out https://webauthn.singularkey.com/ for FIDO2 Sequence Diagrams.
    * FIDO2 Registration Steps:
        *  1. `SignUpViewModel.registerInitiate()` : Relying Party (RP) Server API call which is proxied to Singular Key FIDO Service to initiate the FIDO2 registration process to retrieve a randomly generated challenge and other RP and User information
        *  2. `self.credManager.credentialsCreate()` : iOS Singular Key FIDO2 Attestation API call to create a biometrics secured public key based strong `FIDO2 credential`and sign the response (`public key`, challenge and other information)
        *  3. SignUpViewModel.registerComplete()` : The signed response is sent to the RP Server API which is proxied to Singular Key FIDO Service to complete the FIDO2 registration process
    
* `LoginViewController.swift`  : Check out https://webauthn.singularkey.com/ for FIDO2 Sequence Diagrams.
    * FIDO2 Authentication Steps:
        *   `LoginViewModel.authInitiate()` : RP Server API call which is proxied to Singular Key FIDO Service to initiate the FIDO2 Authentication process to retrieve a randomly generated challenge and other information
        *   `self.credManager.credentialsGet()` : iOS Singular Key FIDO2 Assertion API call to create a signed response (challenge and other information) with the previously created FIDO2 Credential.
        *   `LoginViewModel.authComplete()` : The signed response is sent to the RP Server API  which is proxied to Singular Key FIDO Service to complete the FIDO2 Authentication process

 * `NetworkAPIUtils.swift` - RP API Interface
    * POST /register/initiate
    * POST /register/complete
    * POST /auth/initiate
    * POST /auth/complete

------------
# Support
Have questions? Please contact Support (`support@singularkey.com`) or sign up at http://singularkey.com/singular-key-web-authn-fido-developer-program-api/

# License
Apache 2.0
