//
//  TermsWebViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/06/23.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import WebKit

final class TermsWebViewController: BaseViewController<TermsWebViewReactor> {

  // MARK: Properties
  private let webView: WKWebView = .init()
  private let navBackBarButton: UIBarButtonItem = .init(image: UIImage(literal: .back))
  private let termsURLString: String = "https://proud-crocus-ae3.notion.site/PhoChak-e9217346d7ee4658a64a7f976f2c4412"

  // MARK: Initializer
  init(reactor: TermsWebViewReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()

    guard let url = URL(string: termsURLString) else {
      return
    }
    webView.load(.init(url: url))
  }

  override func setupViews() {
    super.setupViews()

    view.backgroundColor = .white
    navigationItem.leftBarButtonItem = navBackBarButton

    webView.do {
      $0.allowsBackForwardNavigationGestures = true
      $0.backgroundColor = .white
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    super.setupLayoutConstraints()

    webView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }

  override func bind(reactor: TermsWebViewReactor) {
    super.bind(reactor: reactor)

    navBackBarButton.rx.tap
      .map { TermsWebViewReactor.Action.tapBackButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }
}
