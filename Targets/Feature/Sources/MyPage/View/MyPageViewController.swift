//
//  MyPageViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

import RxCocoa
import RxSwift

final class MyPageViewController: BaseViewController<MyPageReactor> {

  // MARK: Properties
  private let settingBarButton: UIBarButtonItem = .init()
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )

  // MARK: Initializer
  init(reactor: MyPageReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func setupViews() {
    super.setupViews()

    flowLayout.do {
      $0.sectionInset = .init(top: 0, left: 20, bottom: 0, right: 20)
      $0.minimumInteritemSpacing = 7
      $0.minimumLineSpacing = 7
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.showsHorizontalScrollIndicator = false
      $0.showsVerticalScrollIndicator = false
      $0.registerCell(cellType: MyPageProfileCell.self)
      $0.registerCell(cellType: MyPagePostCell.self)
      $0.registerCell(cellType: DefaultCell.self)
      $0.registerHeader(viewType: PostsSectionHeaderView.self)
      $0.registerHeader(viewType: DefaultHeaderView.self)
      $0.delegate = self
      $0.dataSource = self
      view.addSubview($0)
    }

    settingBarButton.do {
      $0.image = .createImage(.setting)
      navigationItem.rightBarButtonItem = $0
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind(reactor: MyPageReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

extension MyPageViewController: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let section = MyPageReactor.Section(rawValue: indexPath.section) else {
      return .zero
    }

    switch section {
    case .profile:
      return .init(
        width: collectionView.frame.width - 60,
        height: view.frame.height * 0.124
      )

    case .posts:
      return .init(
        width: (collectionView.frame.width - 54) / 3,
        height: view.frame.height * 0.23
      )
    }
  }

  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    referenceSizeForHeaderInSection section: Int
  ) -> CGSize {
    guard let section = MyPageReactor.Section(rawValue: section) else {
      return .zero
    }

    switch section {
    case .profile:
      return .zero
    case .posts:
      return CGSize(
        width: collectionView.frame.width - 40,
        height: view.frame.height * 0.08
      )
    }
  }

  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    reactor?.action.onNext(.fetchItems(size: 3))
  }
}

extension MyPageViewController: UICollectionViewDataSource {
  func collectionView(
    _ collectionView: UICollectionView,
    numberOfItemsInSection section: Int
  ) -> Int {
    guard let section = MyPageReactor.Section(rawValue: section) else {
      return 0
    }

    switch section {
    case .profile:
      return reactor?.currentState.user == nil ? 0 : 1
    case .posts:
      guard let currentFilter = reactor?.currentState.postFilter else {
        return 0
      }

      if currentFilter == .uploaded {
        return reactor?.currentState.uploadedPosts.count ?? 0
      } else {
        return reactor?.currentState.likedPosts.count ?? 0
      }
    }
  }

  func numberOfSections(in collectionView: UICollectionView) -> Int {
    MyPageReactor.Section.allCases.count
  }

  func collectionView(
    _ collectionView: UICollectionView,
    cellForItemAt indexPath: IndexPath
  ) -> UICollectionViewCell {
    guard let section = MyPageReactor.Section(rawValue: indexPath.section) else {
      return .init()
    }

    let cell: UICollectionViewCell
    switch section {
    case .profile:
      guard let user = reactor?.currentState.user else {
        return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
      }

      let profileCell = collectionView.dequeue(cellType: MyPageProfileCell.self, indexPath: indexPath)
      profileCell.delegate = self
      profileCell.configure(nickname: user.nickname)
      cell = profileCell

    case .posts:
      guard let postFilter = reactor?.currentState.postFilter else {
        return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
      }

      let postCell = collectionView.dequeue(cellType: MyPagePostCell.self, indexPath: indexPath)
      postCell.delegate = self

      if postFilter == .uploaded {
        guard let post = reactor?.currentState.uploadedPosts[safe: indexPath.item] else {
          return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
        }

        postCell.configure(videoPost: post)
      } else {
        guard let post = reactor?.currentState.likedPosts[safe: indexPath.item] else {
          return collectionView.dequeue(cellType: DefaultCell.self, indexPath: indexPath)
        }

        postCell.configure(videoPost: post, hideOption: true)
      }
      cell = postCell
    }

    return cell
  }

  func collectionView(
    _ collectionView: UICollectionView,
    viewForSupplementaryElementOfKind kind: String,
    at indexPath: IndexPath
  ) -> UICollectionReusableView {
    guard kind == UICollectionView.elementKindSectionHeader else {
      return DefaultHeaderView()
    }

    if indexPath.section == MyPageReactor.Section.posts.rawValue {
      let headerView = collectionView.dequeueHeader(viewType: PostsSectionHeaderView.self, indexPath: indexPath)
      headerView.delegate = self
      return headerView
    } else {
      return collectionView.dequeueHeader(viewType: DefaultHeaderView.self, indexPath: indexPath)
    }
  }
}

// MARK: - MyPagePostCellDelegate
extension MyPageViewController: MyPagePostCellDelegate {
  func tapPost(videoPost: VideoPost) {
    reactor?.action.onNext(.videoPostCellTap(videoPost: videoPost))
  }
}

// MARK: - MyPageProfileCellDelegate
extension MyPageViewController: MyPageProfileCellDelegate {
  func tapEditProfileButton() {
    reactor?.action.onNext(.editProfileButtonTap)
  }
}

// MARK: - PostsSectionHeaderDelegate
extension MyPageViewController: PostsSectionHeaderDelegate {
  func updateFilter(postFilter: PostsFilterOption) {
    reactor?.action.onNext(.updatePostsListFilter(postFilter: postFilter))
  }
}

// MARK: Private
private extension MyPageViewController {
  func bindAction(reactor: MyPageReactor) {
    rx.viewWillAppear
      .map { MyPageReactor.Action.viewWillAppear }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: MyPageReactor) {
    Observable.combineLatest(
      reactor.state.map { $0.user },
      reactor.state.map { $0.uploadedPosts }) { _, _ in }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        if owner.reactor?.currentState.user != nil {
          owner.collectionView.reloadData()
        }
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.postFilter }
      .subscribe()
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.likedPosts }
      .subscribe()
      .disposed(by: disposeBag)
  }
}
