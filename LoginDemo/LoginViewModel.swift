//
//  ViewModel.swift
//  LoginDemo
//
//  Created by Admin on 09/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

struct Validation {
    static let minimumUserNameLength = 6
    static let minimumPasswordLength = 6
}

final class LoginViewModel {
    var username = BehaviorRelay<String>(value: "")
    var password = BehaviorRelay<String>(value: "")
    let onShowAlert = PublishSubject<String>()
    let loginButtonTapped = PublishSubject<Void>()
    private let disposeBag = DisposeBag()
    
    var loginButtonEnabled: Observable<Bool> {
        return Observable.combineLatest(usernameValid, passwordValid) { $0 && $1 }
    }
    
    private var usernameValid: Observable<Bool> {
        return username.asObservable().map { $0.count > Validation.minimumUserNameLength }
    }
    
    private var passwordValid: Observable<Bool> {
        return password.asObservable().map { $0.count > Validation.minimumPasswordLength }
    }
    
    init() {
        loginButtonTapped.subscribe(
            onNext: { [weak self] in
                guard let this = self else { return }
                API.request(path: "login", username: this.username.value).subscribe(
                    onNext: { name in
                        this.onShowAlert.onNext(name)
                    }
                ).disposed(by: this.disposeBag)
            }
        ).disposed(by: disposeBag)
        
        username.accept("LeDucTanh")
    }
}
