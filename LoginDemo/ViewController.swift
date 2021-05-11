//
//  ViewController.swift
//  LoginDemo
//
//  Created by Admin on 09/05/2021.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    let disposeBag = DisposeBag()
    
    var viewModel = LoginViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewModel()
    }
    
    private func bindViewModel() {
        bind(textField: usernameTextField, to: viewModel.username)
        bind(textField: passwordTextField, to: viewModel.password)
        
        viewModel.loginButtonEnabled
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap.asObservable()
            .bind(to: viewModel.loginButtonTapped)
            .disposed(by: disposeBag)
        
        viewModel.onShowAlert.bind { [weak self] username in
            guard let this = self else { return }
            this.showAlert(message: "Logged in as \(username)")
        }
        .disposed(by: disposeBag)
        
//        viewModel.onShowAlert.subscribe(
//            onNext: { [weak self] username in
//                guard let this = self else { return }
//                this.showAlert(message: "Logged in as \(username)")
//            }
//        ).disposed(by: disposeBag)
    }
    
    private func bind(textField: UITextField, to behaviorRelay: BehaviorRelay<String>) {
        behaviorRelay.asObservable()
            .bind(to: textField.rx.text.orEmpty)
            .disposed(by: disposeBag)
        textField.rx.text.orEmpty
            .bind(to: behaviorRelay)
            .disposed(by: disposeBag)
    }
}

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
