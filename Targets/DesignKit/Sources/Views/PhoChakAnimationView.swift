//
//  PhoChakAnimationView.swift
//  DesignKit
//
//  Created by 한상진 on 2023/02/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import Lottie
import SnapKit
import Then

public final class PhoChakAnimationView: UIViewController {

  // MARK: Properties
  private let loadingIndicator: LottieAnimationView = .init(name: "PhoChak-LogoLoop")

  // MARK: Initializer
  public init() {
    super.init(nibName: nil, bundle: nil)

    setupModalStyle()
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  public override func viewDidLoad() {
    super.viewDidLoad()

    setupView()
    setupLayoutConstraints()
  }

  // MARK: Methods
  public func play(on parentViewController: UIViewController) {
    parentViewController.present(self, animated: true)
    loadingIndicator.play()
  }

  public func stop() {
    dismiss(animated: true)
  }
}

// MARK: - Private
private extension PhoChakAnimationView {

  // MARK: Methods
  func setupModalStyle() {
    modalPresentationStyle = .overCurrentContext
    modalTransitionStyle = .crossDissolve
  }

  func setupView() {
    view.backgroundColor = .createColor(.monoGray, .w950, alpha: 0.3)

    loadingIndicator.do {
      $0.contentMode = .scaleAspectFit
      $0.loopMode = .loop
      view.addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    loadingIndicator.snp.makeConstraints {
      $0.size.equalTo(view.frame.width * 0.141)
      $0.center.equalToSuperview()
    }
  }
}
