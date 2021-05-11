//
//  API.swift
//  LoginDemo
//
//  Created by Admin on 09/05/2021.
//

import Foundation
import RxSwift
import RxCocoa

typealias JSObject = [String: Any]
typealias JSArray = [JSObject]

let apiEndpoint = "https://demo3970516.mockable.io/"

class API {
    
    class func request(path: String, username: String) -> Observable<String> {
        guard let url = URL(string: apiEndpoint + path) else { return .empty() }

        return Observable<String>.create({ (observer) in
            URLSession.shared.rx.data(request: URLRequest(url: url))
                .catch({ (error) -> Observable<Data> in
                    observer.onError(error)
                    return .empty()
                })
                .map { data -> JSObject in
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? JSObject
                        return json ?? [:]
                    } catch {
                        return [:]
                    }
                }
                .observe(on: MainScheduler.instance)
                .subscribe(onNext: { _ in
                    observer.onNext(username)
                    observer.onCompleted()
                })
        })
    }
}
