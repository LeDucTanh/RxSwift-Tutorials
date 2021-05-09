//
//  ViewModel.swift
//  LoginDemo
//
//  Created by Admin on 09/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

class User {
    var name: String = ""
    var password = ""

    init(name: String, password: String) {
        self.name = name
        self.password = password
    }
}

struct Validation {
    static let minimumUserNameLength = 6
    static let minimumPasswordLength = 6
}

final class LoginViewModel {
    typealias LoginViewModelParams = (username: ControlProperty<String>, pw: ControlProperty<String>, loginTap: Observable<Void>)
    
    let loginEnabled: Observable<Bool>
    let loginObservable: Observable<String>
    
    init(input: LoginViewModelParams) {
        let validatedUsername: Observable<Bool> = input.username
            .map { $0.count > Validation.minimumUserNameLength }
        
        let validatedPassword: Observable<Bool> = input.pw
            .map { $0.count > Validation.minimumUserNameLength }
        
        loginEnabled = Observable.combineLatest(validatedUsername, validatedPassword) { $0 && $1 }
        
        let userAndPassword = Observable.combineLatest(input.username, input.pw) { ($0, $1) }

        loginObservable = input.loginTap
            .withLatestFrom(userAndPassword)
            .flatMapLatest { (username, _) in
            return API.request(path: "login", username: username)
        }
    }
}
