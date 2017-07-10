
/*
 
 The MIT License (MIT)
 Copyright (c) 2017 Dalton Hinterscher
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"),
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense,
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR
 ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH
 THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 
 */

public class KeyboardSpy {
    
    private static var _defaultSpy: KeyboardSpy?
    private static var defaultSpy: KeyboardSpy {
        if _defaultSpy == nil {
            _defaultSpy = KeyboardSpy()
        }
        return _defaultSpy!
    }
    
    private var spies: [KeyboardSpyAgent] = []
    
    private init() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidShow(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidShow,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidHide(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidHide,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChangeFrame(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardDidChangeFrame(notification:)),
                                               name: NSNotification.Name.UIKeyboardDidChangeFrame,
                                               object: nil)
    }
    
    private dynamic func keyboardWillShow(notification: Notification) {
        processKeyboardEvent(.willShow, notification: notification)
    }
    
    private dynamic func keyboardDidShow(notification: Notification) {
        processKeyboardEvent(.didShow, notification: notification)
    }
    
    private dynamic func keyboardWillHide(notification: Notification) {
        processKeyboardEvent(.willHide, notification: notification)
    }
    
    private dynamic func keyboardDidHide(notification: Notification) {
        processKeyboardEvent(.didHide, notification: notification)
    }
    
    private dynamic func keyboardWillChangeFrame(notification: Notification) {
        processKeyboardEvent(.willChangeFrame, notification: notification)
    }
    
    private dynamic func keyboardDidChangeFrame(notification: Notification) {
        processKeyboardEvent(.didChangeFrame, notification: notification)
    }
    
    private func processKeyboardEvent(_ event: KeyboardSpyEvent, notification: Notification) {
        let keyboardInfo = KeyboardSpyInfo(notification: notification)
        
        for spy in spies {
            if spy.keyboardEventsToSpyOn.contains(event) {
                spy.keyboardSpyEventProcessed(event: event, keyboardInfo: keyboardInfo)
            }
        }
    }
    
    private func agentIsAlreadySpying(_ agent: KeyboardSpyAgent) -> Bool {
        for spy in spies {
            if spy.description == agent.description {
                return true
            }
        }
        
        return false
    }
    
    private func indexOfAgent(_ agent: KeyboardSpyAgent) -> Int? {
        for (i, spy) in spies.enumerated() {
            if agent.description == spy.description {
                return i
            }
        }
        return nil
    }
    
    public class func spy(on agent: KeyboardSpyAgent) {
        if !defaultSpy.agentIsAlreadySpying(agent) {
            defaultSpy.spies.append(agent)
        }
    }
    
    public class func unspy(on agent: KeyboardSpyAgent) {
        if let index = defaultSpy.indexOfAgent(agent) {
            defaultSpy.spies.remove(at: index)
        }
    }
}
