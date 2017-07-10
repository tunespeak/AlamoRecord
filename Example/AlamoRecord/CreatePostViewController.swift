//
//  CreatePostViewController.swift
//  AlamoRecord
//
//  Created by Dalton Hinterscher on 7/9/17.
//  Copyright © 2017 CocoaPods. All rights reserved.
//

import KeyboardSpy
import NotificationBannerSwift
import UIKit

protocol CreatePostViewControllerDelegate: class {
    func onPostCreated(post: Post)
}

class CreatePostViewController: UIViewController {

    private weak var delegate: CreatePostViewControllerDelegate?
    private var model: CreatePostModel = CreatePostModel()
    private var createView: CreatePostView {
        return view as! CreatePostView
    }
    
    init(delegate: CreatePostViewControllerDelegate) {
        super.init(nibName: nil, bundle: nil)
        edgesForExtendedLayout = UIRectEdge()
        self.delegate = delegate
        view = CreatePostView()
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "SAVE", style: .plain, target: self, action: #selector(onSaveButtonPressed))
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        KeyboardSpy.spy(on: createView)
        createView.titleTextField.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        KeyboardSpy.unspy(on: createView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private dynamic func onSaveButtonPressed() {
        
        let title: String = createView.titleTextField.text ?? ""
        let body: String = createView.bodyTextView.text ?? ""
        if title.isEmpty || body.isEmpty {
            let banner = StatusBarNotificationBanner(title: "Both fields must be filled out to create a post.",
                                                     style: .danger)
            banner.show()
        }
        
        model.createPost(title: title, body: body, success: { (post) in
            let banner = StatusBarNotificationBanner(title: "Post created.",
                                                     style: .success)
            banner.show()
            self.navigationController?.popViewController(animated: true)
            self.delegate?.onPostCreated(post: post)
        }) { (error) in
            let banner = StatusBarNotificationBanner(title: "Failed to create post.",
                                                     style: .danger)
            banner.show()
            print(error)
        }
    }

}
