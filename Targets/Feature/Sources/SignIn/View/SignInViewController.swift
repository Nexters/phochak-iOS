//
//  LoginViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/01/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import AuthenticationServices
import DesignKit
import UIKit

import ReactorKit
import RxCocoa
import SnapKit
import Then

final class SignInViewController: BaseViewController<SignInReactor> {

  // MARK: Properties
  private let kakaoLoginButton: UIButton = .init()
  private let appleLoginButton: UIButton = .init()

  // MARK: Initializer
  init(reactor: SignInReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Methods
  override func bind(reactor: SignInReactor) {
    bindAction(reactor: reactor)

    appleLoginButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.signinWithApple()
      })
      .disposed(by: disposeBag)
  }

  override func setupViews() {
    super.setupViews()

    appleLoginButton.do {
      $0.backgroundColor = .createColor(.monoGray, .w50)
      $0.setImage(.createImage(.apple), for: .normal)
      $0.setTitle("애플로 로그인", for: .normal)
      $0.titleLabel?.font = .createFont(.CallOut, .w800)
      $0.setTitleColor(.createColor(.monoGray, .w900), for: .normal)
      $0.cornerRadius(radius: 10)
      $0.titleEdgeInsets = .init(top: 0, left: 12, bottom: 0, right: 0)
      view.addSubview($0)
    }

    kakaoLoginButton.do {
      $0.backgroundColor = .createColor(.yellow, .w400)
      $0.setImage(.createImage(.kakao), for: .normal)
      $0.setTitle("카카오 로그인", for: .normal)
      $0.titleLabel?.font = .createFont(.CallOut, .w800)
      $0.setTitleColor(.createColor(.monoGray, .w900), for: .normal)
      $0.cornerRadius(radius: 10)
      $0.titleEdgeInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    appleLoginButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(appleLoginButton.snp.width).multipliedBy(0.171)
      $0.bottom.equalToSuperview().inset(60)
    }

    kakaoLoginButton.snp.makeConstraints {
      $0.leading.trailing.height.equalTo(appleLoginButton)
      $0.bottom.equalTo(appleLoginButton.snp.top).offset(-15)
    }
  }
}

// MARK: - Apple Authentication Services Extension
extension SignInViewController: ASAuthorizationControllerPresentationContextProviding, ASAuthorizationControllerDelegate {
  func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
    view.window!
  }

  func authorizationController(
    controller: ASAuthorizationController,
    didCompleteWithAuthorization authorization: ASAuthorization
  ) {
    switch authorization.credential {
    case let appleIDCredential as ASAuthorizationAppleIDCredential:

      guard let identityToken = appleIDCredential.identityToken,
            let stringToken = String(data: identityToken, encoding: .utf8)
      else { return }

      reactor?.action.onNext(.receiveAppleSigninAuthCode(token: stringToken))

    default:
      break
    }
  }
}

// MARK: - Private Extenion
private extension SignInViewController {
  func bindAction(reactor: SignInReactor) {
    typealias Action = SignInReactor.Action

    kakaoLoginButton.rx.tap
      .asSignal()
      .map { Action.tapKakaoSignInButton }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func signinWithApple() {
    let appleIDProvider: ASAuthorizationAppleIDProvider = .init()
    let request = appleIDProvider.createRequest()
    request.requestedScopes = [.fullName, .email]

    let authController = ASAuthorizationController(authorizationRequests: [request])
    authController.delegate = self
    authController.presentationContextProvider = self
    authController.performRequests()
  }
}
