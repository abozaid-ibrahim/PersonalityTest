# Personality Test

## Building And Running The Project (Requirements)
* Swift 5.0+
* Xcode 11.1+
* iOS 10.0+

### General Application Frameworks
RxSwift/RxCocoa: [Reactive Programming](https://github.com/ReactiveX/RxSwift)
RxSwift/RxCocoa: [Reactive Programming](https://github.com/ReactiveX/RxSwift)

# Getting Started
If this is your first time encountering swift/ios development, please follow [the instructions](https://developer.apple.com/support/xcode/) to setup Xcode and Swift on your Mac. And to setup cocoapods for dependency management, make use of [CocoaPods](https://guides.cocoapods.org/using/getting-started.html#getting-started)

## Setup Configs
* Open the project by double clicking the `PersonalityTest.xcworkspace` file
* Locate the `Configs` directory and delete `Development, Production and Staging` file.
* Re-Create the Config files (Staging, Development and Production) and place it in the Cofigs directory. See sample below

`Development.xcconfig`
```
#include "Pods/Target Support Files/Pods-PersonalityTest/Pods-PersonalityTest.debug (development).xcconfig"
#include "Pods/Target Support Files/Pods-PersonalityTest/Pods-PersonalityTest.release (development).xcconfig"

// App Settings
APP_NAME = Personality Test (Dev)
PRODUCT_BUNDLE_IDENTIFIER = com.abuzeid.PersonalityTest.dev

// PersonalityTest Root URL
PersonalityTest_ROOT_URL = https:/$()/api.PersonalityTest.com/services/rest/

// PersonalityTest API Key
PersonalityTest_API_KEY = PersonalityTest_api_key
```

`Production.xcconfig`
```
#include "Pods/Target Support Files/Pods-PersonalityTest/Pods-PersonalityTest.debug (production).xcconfig"
#include "Pods/Target Support Files/Pods-PersonalityTest/Pods-PersonalityTest.release (production).xcconfig"

// App Settings
APP_NAME = Personality Test (Dev)
PRODUCT_BUNDLE_IDENTIFIER = com.abuzeid.PersonalityTest.dev

// PersonalityTest Root URL
PersonalityTest_ROOT_URL = https:/$()/api.PersonalityTest.com/services/rest/

// PersonalityTest API Key
PersonalityTest_API_KEY = PersonalityTest_api_key
```

`Staging.xcconfig`
```
#include "Pods/Target Support Files/Pods-PersonalityTest/Pods-PersonalityTest.debug (staging).xcconfig"
#include "Pods/Target Support Files/Pods-PersonalityTest/Pods-PersonalityTest.release (staging).xcconfig"

// App Settings
APP_NAME = Personality Test (Dev)
PRODUCT_BUNDLE_IDENTIFIER = com.abuzeid.PersonalityTest.dev

// PersonalityTest Root URL
PersonalityTest_ROOT_URL = https:/$()/api.PersonalityTest.com/services/rest/

// PersonalityTest API Key
PersonalityTest_API_KEY = PersonalityTest_api_key
```

# In your terminal, go to the project root directory. Make sure you have cocoapods setup, then run:
pod install

# Build and or run application by doing:
* Select the build scheme which can be found right after the stop button on the top left of the IDE
* [Command(cmd)] + B - Build app
* [Command(cmd)] + R - Run app

## Architecture
This application uses the Model-View-ViewModel (refered to as MVVM) architecture. The main purpose of the MVVM is to move the data state from the View to the ViewModel.

### Model
In the MVVM design pattern, Model is the same as in MVC pattern. It represents simple data.

### View
View is represented by the UIView or UIViewController objects, accompanied with their .xib and .storyboard files, which should only display prepared data. 

### ViewModel
Only a simple, formatted string that comes from the ViewModel.

ViewModel hides all asynchronous networking code, data preparation code for visual presentation, and code listening for Model changes. All of these are hidden behind a well-defined API modeled to fit this particular View.

One of the benefits of using MVVM is testing.

## Structure

### Extensions
This is to group every component's extension / reusable functions


### Modules
- include seperate modules, Networking, caching...etc.

### Scenes
This is for group of app scene 

### Configs
This is for handling configs needed by the app

## Task

* Display categories of questions with title text
* Selecting a category opens list of questions
* you could either submit question by question or you could submit all of them once
* Testing 😞 

## Solution
* Setup config for project
* Provide a single entry for request handling and caching

## Improvements
* Unit test the view model
