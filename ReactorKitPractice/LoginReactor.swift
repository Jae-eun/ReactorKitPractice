//
//  LoginReactor.swift
//  ReactorKitPractice
//
//  Created by 이재은 on 21/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import Foundation
import ReactorKit
import RxSwift

class LoginReactor: Reactor {
    
    enum Action {
        case login
        case id(String)
        case pw(String)
    }
    
    enum Mutation {
        case validateLogin
        case validate(Bool)
        case setID(id: String)
        case setPW(pw: String)
    }
    
    struct State {
        var id: String?
        var pw: String?
        var isEnableButton: Bool
        var completeText: String
    }
    
    let initialState: State
    
    init() {
        self.initialState = State(id: nil,
                                  pw: nil,
                                  isEnableButton: false,
                                  completeText: "(로그인 전)")
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .id(let idString):
            return Observable.concat([
                Observable.just(Mutation.setID(id: idString)),
                Observable.just(Mutation.validate(self.validate(id: idString, pw: currentState.pw)))
                ])
        case .pw(let pwString):
            return
                Observable.concat([
                    Observable.just(Mutation.setPW(pw: pwString)),
                    Observable.just(Mutation.validate(self.validate(id: currentState.id, pw: pwString)))
                    ])
        case .login:
            return Observable.just(Mutation.validateLogin)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        switch mutation {
        case .setID(let id):
            newState.id = id
        case .setPW(let pw):
            newState.pw = pw
        case .validate(let valid):
            newState.isEnableButton = valid
        case .validateLogin:
            if state.isEnableButton {
                newState.completeText = "성공"
            } else {
                newState.completeText = "실패"
            }
        }
        return newState
    }
    
    private func validate(id: String?, pw: String?) -> Bool {
        guard let id = id, let pw = pw else { return false }
        return id.count > 5 && pw.count > 7
    }
}
