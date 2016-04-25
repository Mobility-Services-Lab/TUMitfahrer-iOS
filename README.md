TUMitfahrer for iOS
===============

TUMitfahrer - a carpooling platform for students of Technical University of Munich. Organize and join campus rides and travel between the Main Campus, Garching Forschungszentrum, Freising and other destinations. Enjoy activity rides and go for example to Ikea, for hiking in Alps or to the lake with fellow students. 

If you are a driver - submit a ride offer and share costs of the trip with others. Don't worry if you don't have a car - the app enables you to post ride requests as a passenger. 

In this updated version enjoy a great user interface and discover even more functionality that was developed by a group of 9 students from Informatics at Technical University of Munich at the Chair of Wirtschaftsinformatik. The first version was created by students from TUM: Junge Akademie.

The project is open-source - everybody is welcome to join, collaborate and commit new features.

### Installation and Configuration of the project

1. git clone the repo
2. make sure that cocoapods version is 0.38 (tested)
3. Go to the directory tumitfahrer-ios and execute from command line `pod install`
4. Open `tumitfahrer.xcworkspace`
5. Comment out some methods that bring up errors in the file JSMessageSoundEffect.m
6. If there is a warning in the file ControllerUtilities.m, then page.descWidth can be commented out
7. if there is an error with a weak reference in the facebook pod, then go to Pods project settings, choose the Facebook project, go to build settings and, in the "Apple llvm 7.1 language obj-c" section, set the flag "Weak references in manual retain relase" to true.

### General Notes

In line 221 in the appdelegate there is the following line: kGGLInstanceIDAPNSServerTypeSandboxOption:@NO};
This is part of the GCM Device Registration, so where you set up notifications. This boolean value has to match the used provision profile. So if you use a DEVELOPMENT certificate u have to set it to YES, otherwise to NO. The point is everything will work fine in the app but GCM will throw an error in the webservice, so notifications wont arrive. 

Hint: You only use the development certificate when you install/run the app directly from xcode via "Run".

### What should be added

supportingfiles/tumitfahrer-Prefix.pch:
* line 33: Salt (random)
* line 34: ApiAddress

AppDelegate.m:
* line 371: HockeyApp identifier
* line 384: gcm tracking id

supportingfiles/tumitfahrer-info.plist:
* removed value for FacebookApp ID

zLibraries/GooglePlacesAutocomplete/SPGooglePlacesAutocompleteUtilities.h
* line 9: kGoogleAPIKey

Also, the file GoogleService-info.plist should be added to the project, it can be downloaded from the google account that will be used. 
