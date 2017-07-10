//
//  CreatePostView.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import KeyboardSpy
import UIKit

class CreatePostView: UIView, KeyboardSpyAgent {

    var keyboardEventsToSpyOn: [KeyboardSpyEvent] = [.willShow, .willHide]
    private(set) var titleTextField: UITextField!
    private(set) var bodyTextView: UITextView!
    
    init() {
        super.init(frame: .zero)
        backgroundColor = .white
        
        titleTextField = UITextField()
        titleTextField.placeholder = "Title"
        addSubview(titleTextField)
        
        bodyTextView = UITextView()
        bodyTextView.layer.cornerRadius = 5.0
        bodyTextView.layer.borderWidth = 1.0
        bodyTextView.layer.borderColor = UIColor.lightGray.cgColor
        addSubview(bodyTextView)
        
        titleTextField.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
            make.height.equalTo(40)
        }
        
        bodyTextView.snp.makeConstraints { (make) in
            make.top.equalTo(titleTextField.snp.bottom).offset(10)
            make.left.equalTo(titleTextField)
            make.right.equalTo(titleTextField)
            make.bottom.equalTo(-10)
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    internal func keyboardSpyEventProcessed(event: KeyboardSpyEvent, keyboardInfo: KeyboardSpyInfo) {
        
        let offset: CGFloat = (event == .willShow) ? -keyboardInfo.keyboardHeight - 10 : -10
        UIView.animate(withDuration: keyboardInfo.animationDuration) { 
            self.bodyTextView.snp.updateConstraints { (make) in
                make.bottom.equalTo(offset)
            }
            self.bodyTextView.superview?.layoutIfNeeded()
        }
    }

}
