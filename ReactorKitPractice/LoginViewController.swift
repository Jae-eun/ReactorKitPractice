//
//  LoginViewController.swift
//  ReactorKitPractice
//
//  Created by 이재은 on 21/08/2019.
//  Copyright © 2019 jaeeun. All rights reserved.
//

import UIKit
import ReactorKit
import RxSwift
import RxCocoa

final class LoginViewController: UIViewController, StoryboardView {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var stateLabel: UILabel!
    
    var disposeBag: DisposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func bind(reactor: LoginReactor) {
        idTextField.rx.text
            .orEmpty
            .map{ LoginReactor.Action.id($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        passwordTextField.rx.text
            .orEmpty
            .map{ LoginReactor.Action.pw($0) }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        loginButton.rx.tap
            .map{ LoginReactor.Action.login }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.isEnableButton }
            .bind(to: loginButton.rx.isEnabled)
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.completeText }
            .bind(to: stateLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
}
