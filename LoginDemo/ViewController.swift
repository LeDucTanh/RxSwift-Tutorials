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
    
    var viewModel: LoginViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViewModel()
        setupObservable()
    }
    
    private func setupViewModel() {
        viewModel = LoginViewModel(input: (username: usernameTextField.rx.text.orEmpty, pw: passwordTextField.rx.text.orEmpty, loginTap: loginButton.rx.tap.asObservable()))
        
        viewModel.loginObservable
            .bind { [weak self] username in
                guard let this = self else { return }
                this.showAlert(message: "Logged in as \(username)")
            }
            .disposed(by: disposeBag)
    }
    
    private func setupObservable() {
        viewModel.loginEnabled.bind { [weak self] valid in
            guard let this = self else { return }
            this.loginButton.isEnabled = valid
        }.disposed(by: disposeBag)
    }
}

extension UIViewController {
    func showAlert(message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
