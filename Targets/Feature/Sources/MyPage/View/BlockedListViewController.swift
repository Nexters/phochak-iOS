//
//  BlockedListViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/06/12.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class BlockedListViewController: BaseViewController<BlockedListReactor> {

  // MARK: Properties
  private let tableView: UITableView = .init()

  // MARK: Initializer
  init(reactor: BlockedListReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()

    setupTitle()
  }

  override func setupViews() {
    super.setupViews()

    tableView.do {
      $0.bounces = false
      $0.rowHeight = view.frame.height * 0.059
      $0.separatorStyle = .none
      $0.backgroundColor = .clear
      $0.registerCell(cellType: BlockedListCell.self)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    tableView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind(reactor: BlockedListReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: Private
private extension BlockedListViewController {

  // MARK: Properties
  typealias Section = RxTableViewSectionedAnimatedDataSource<UserNameSection>
  typealias Action = BlockedListReactor.Action

  // MARK: Methods
  func setupTitle() {
    navigationItem.title = "차단한 유저"
  }

  func bindAction(reactor: BlockedListReactor) {
    rx.viewWillAppear
      .map { Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    tableView.rx.itemSelected
      .map { BlockedListReactor.Action.tapBlockedUser(indexPath: $0[1]) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: BlockedListReactor) {
    let dataSource: Section = .init(configureCell: { _, tableView, indexPath, name in
      let cell = tableView.dequeue(cellType: BlockedListCell.self, indexPath: indexPath)
      cell.configure(name: name)

      return cell
    })

    reactor.state
      .map { [UserNameSection(header: "", items: $0.blockedUsers.map { $0.nickname } )] }
      .distinctUntilChanged()
      .bind(to: tableView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }
}
