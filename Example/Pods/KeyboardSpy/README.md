![KeyboardSpy](https://raw.githubusercontent.com/Daltron/KeyboardSpy/master/KeyboardSpy/Assets/keyboard_spy.png)

[![Version](https://img.shields.io/cocoapods/v/Spartan.svg?style=flat)](http://cocoapods.org/pods/KeyboardSpy)
<a href="https://developer.apple.com/swift"><img src="https://img.shields.io/badge/swift-4.0-4BC51D.svg?style=flat" alt="Language: Swift" /></a>
[![Platform](https://img.shields.io/cocoapods/p/KeyboardSpy.svg?style=flat)](http://cocoapods.org/pods/KeyboardSpy)
[![License](https://img.shields.io/cocoapods/l/KeyboardSpy.svg?style=flat)](http://cocoapods.org/pods/KeyboardSpy)

### Written in Swift 4

KeyboardSpy is a super lightweight and easy to use wrapper that makes observing keyboard notifications in iOS a breeze.

## Requirements

 - iOS 8.0+
 - xCode 9.0+

## Installation

### CocoaPods

To integrate KeyboardSpy into your xCode project using CocoaPods, specify it in your `Podfile`:

```ruby
pod 'KeyboardSpy'
```

Then, run the following command:

```bash
$ pod install
```

## Usage

KeyboardSpy uses a protocol based approach to observe keyboard notifications:

```swift
public protocol KeyboardSpyAgent {
    var keyboardEventsToSpyOn: [KeyboardSpyEvent] { get }
    func keyboardSpyEventProcessed(event:KeyboardSpyEvent, keyboardInfo: KeyboardSpyInfo)
}
```

To add a spy, simply:

```swift
KeyboardSpy.spy(on: self)
```

To remove a spy, simply:

```swift
KeyboardSpy.unspy(on: self)
```

There are six different events you can spy on:

```swift
public enum KeyboardSpyEvent {
    case willShow
    case didShow
    case willHide
    case didHide
    case willChangeFrame
    case didChangeFrame
}
```

You will get the following object for each event you spy on:

```swift
public class KeyboardSpyInfo: NSObject {
    public private(set) var beginFrame: CGRect!
    public private(set) var endFrame: CGRect!
    public private(set) var animationCurve: UIViewAnimationCurve!
    public private(set) var animationDuration: Double!
    public private(set) var isLocal: Bool!
    public var keyboardHeight: CGFloat
}
```

### Example:

```swift
import KeyboardSpy

class KeyboardSpyViewController: UIViewController {
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardSpy.spy(on: keyboardSpyView) // This can be placed anywhere
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardSpy.unspy(on: keyboardSpyView) // This can be placed anywhere
    }
    
}

extension KeyboardSpyViewController: KeyboardSpyAgent {
    
    internal var keyboardEventsToSpyOn: [KeyboardSpyEvent] {
    	return [.willShow, .willHide]
    }
    
    internal func keyboardSpyEventProcessed(event: KeyboardSpyEvent, keyboardInfo: KeyboardSpyInfo) {
        if event == .willShow {
        	// Do something like moving a view above the keyboard
        } else if event == .willHide {
        	// Do something like moving a view back to its original position
        }   
    }

}
```

## Author

Dalton Hinterscher, daltonhint4@gmail.com

## License

KeyboardSpy is available under the MIT license. See the LICENSE file for more info.
