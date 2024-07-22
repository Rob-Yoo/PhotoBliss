//
//  BaseViewController.swift
//  PhotoBliss
//
//  Created by Jinyoung Yoo on 7/22/24.
//

import UIKit

class BaseViewController<ContentView: UIView>: UIViewController {

    let contentView: ContentView
    
    init(contentView: ContentView = ContentView()) {
        self.contentView = contentView
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        self.view = contentView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .systemBackground
        self.configureNavigationBar()
        self.addUserAction()
        self.bindViewModel()
    }
    
    //MARK: - Overriding Methods
    func addUserAction() {}
    func bindViewModel() {}

    func addKeyboardDismissAction() {
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        self.contentView.addGestureRecognizer(gestureRecognizer)
    }
    
    @objc private func dismissKeyboard() {
        self.contentView.endEditing(true)
    }

    @objc func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}

//MARK: - Configure NavigationBar
extension BaseViewController {
    private func configureNavigationBar() {
        self.configureNavBarTitle()
        
        if let nc = self.navigationController, nc.viewControllers.count > 1 {
            self.configureNavBarLeftBarButtonItem()
        }
    }

    
    private func configureNavBarTitle() {
        guard let navBarInfo = self.contentView as? RootViewProtocol else {
            print("RootViewProtocol을 채택하지 않은 ContentView가 들어왔습니다..!")
            return
        }
            
        self.navigationItem.title = navBarInfo.navigationTitle
    }
    
    private func configureNavBarLeftBarButtonItem() {
        let backButton = UIBarButtonItem(image: .leftArrow, style: .plain, target: self, action: #selector(backButtonTapped))

        self.navigationItem.leftBarButtonItem = backButton
        self.navigationItem.leftBarButtonItem?.tintColor = .black
    }
}
