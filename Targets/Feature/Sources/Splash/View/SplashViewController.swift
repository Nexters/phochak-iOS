//
//  SplashViewController.swift
//  Feature
//
//  Created by Ian on 2023/02/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

import Lottie
import RxCocoa
import RxSwift
import SnapKit
import Then

final class SplashViewController: BaseViewController<SplashReactor> {

  // MARK: Properties
  private let logoAnimationView: LottieAnimationView = .init(name: "PhoChak-LogoLoop")
  private let titleAnimationView: LottieAnimationView = .init(name: "PhoChak-Title")
  private let bodyAnimationView: LottieAnimationView = .init(name: "PhoChak-Body")

  // MARK: Initializer
  init(reactor: SplashReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func setupViews() {
    super.setupViews()

    logoAnimationView.do {
      $0.loopMode = .loop
      $0.isHidden = true
      view.addSubview($0)
    }

    titleAnimationView.do {
      $0.isHidden = true
      view.addSubview($0)
    }

    bodyAnimationView.do {
      $0.isHidden = true
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    bodyAnimationView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.size.equalTo(CGSize(width: 120, height: 15))
      $0.centerY.equalToSuperview().offset(-30)
    }

    titleAnimationView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.centerY.equalTo(bodyAnimationView.snp.top).offset(-27)
    }

    logoAnimationView.snp.makeConstraints {
      $0.centerX.equalToSuperview()
      $0.size.equalTo(CGSize(width: 55, height: 55))
      $0.bottom.equalTo(titleAnimationView.snp.top).offset(-31)
    }
  }

  override func bind(reactor: SplashReactor) {
    bindAction(reactor: reactor)
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
      self?.logoAnimationView.isHidden = false
      self?.titleAnimationView.isHidden = false
      self?.bodyAnimationView.isHidden = false

      self?.logoAnimationView.play()
      self?.titleAnimationView.play()
      self?.bodyAnimationView.play()
    })
  }
}

// MARK: - Private
private extension SplashViewController {
  func bindAction(reactor: SplashReactor) {
    rx.viewDidAppear
      .debounce(.milliseconds(3500), scheduler: MainScheduler.instance)
      .map { SplashReactor.Action.showNextScene }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}
