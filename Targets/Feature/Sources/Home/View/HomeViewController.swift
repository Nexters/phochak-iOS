//
//  HomeViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/16.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import UIKit

import ReactorKit
import RxCocoa
import RxSwift
import SnapKit
import Then

final class HomeViewController: BaseViewController<HomeReactor> {

  // MARK: Properties
  private let titleLabel: UILabel = .init()
  private let searchBarButton: UIBarButtonItem = .init()
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )
  private var currentIndex: Int = 1
  private var previousIndex: Int = 1
  private let exclameVideoPostSubject: PublishSubject<Int> = .init()
  private let likeVideoPostSubject: PublishSubject<Int> = .init()

  // MARK: Initializer
  init(reactor: HomeReactor) {
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

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    DispatchQueue.main.async { [weak self] in
      self?.collectionView.scrollToItem(
        at: .init(item: 1, section: 0),
        at: .centeredHorizontally,
        animated: false
      )
    }
  }

  override func setupViews() {
    super.setupViews()

    titleLabel.do {
      $0.textColor = .white
      $0.font = .systemFont(ofSize: 32, weight: .bold)
      $0.text = "Phochak"
      navigationItem.leftBarButtonItem = .init(customView: $0)
    }

    searchBarButton.do {
      $0.image = .createImage(.search)
      navigationItem.rightBarButtonItem = $0
    }

    flowLayout.do {
      $0.itemSize = .init(width: view.frame.width * 0.7, height: view.frame.height * 0.54)
      $0.scrollDirection = .horizontal
      $0.minimumLineSpacing = 30
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      $0.decelerationRate = .fast
      $0.registerCell(cellType: VideoPostCell.self)
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.bottom.equalTo(view.safeAreaLayoutGuide)
      $0.leading.trailing.equalToSuperview()
    }
  }

  override func bind(reactor: HomeReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)

    collectionView.rx.didScroll
      .asSignal()
      .emit(to: transformBinder)
      .disposed(by: disposeBag)

    collectionView.rx.willEndDragging
      .asSignal()
      .map { $1 }
      .emit(to: pagingBinder)
      .disposed(by: disposeBag)
  }
}

// MARK: - Private
private extension HomeViewController {

  // MARK: Methods
  func bindAction(reactor: HomeReactor) {
    collectionView.rx.didEndDragging.map { _ in }
      .asObservable()
      .startWith(())
      .map { _ in HomeReactor.Action.fetchItems(count: 6) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.itemSelected
      .map { HomeReactor.Action.tapVideoCell(index: $0.item) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    searchBarButton.rx.tap
      .map { HomeReactor.Action.tapSearchButton }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    exclameVideoPostSubject
      .map { HomeReactor.Action.exclameVideoPost(postID: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    likeVideoPostSubject
      .map { HomeReactor.Action.likeVideoPost(postID: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: HomeReactor) {
    reactor.state
      .map { $0.videoPosts }
      .distinctUntilChanged()
      .bind(to: collectionView.rx.items(
        cellIdentifier: "\(VideoPostCell.self)",
        cellType: VideoPostCell.self)
      ) { [weak self] _, post, cell in
        cell.configure(post)

        if let likeVideoPostSubject = self?.likeVideoPostSubject {
          cell.heartButtonTap
            .subscribe(likeVideoPostSubject)
            .disposed(by: cell.disposeBag)
        }

        if let exclameVideoPostSubject = self?.exclameVideoPostSubject {
          cell.exclameButtonTap
            .subscribe(exclameVideoPostSubject)
            .disposed(by: cell.disposeBag)
        }
      }
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .subscribe()
      .disposed(by: disposeBag)
  }

  // MARK: Properties
  var pagingBinder: Binder<UnsafeMutablePointer<CGPoint>> {
    return .init(self) { owner, contentOffset in
      guard let layout = owner.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        return
      }

      let cellWidth = layout.itemSize.width + layout.minimumLineSpacing

      var offset = contentOffset.pointee
      let index = round((offset.x + owner.collectionView.contentInset.left) / cellWidth)

      if index > CGFloat(owner.currentIndex) {
        owner.currentIndex += 1
      } else if index < CGFloat(owner.currentIndex), owner.currentIndex != 0 {
        owner.currentIndex -= 1
      }

      offset = .init(
        x: CGFloat(owner.currentIndex) * cellWidth - owner.collectionView.contentInset.left - 10,
        y: 0
      )

      contentOffset.pointee = offset
    }
  }

  var transformBinder: Binder<Void> {
    return .init(self) { owner, _ in
      guard let layout = owner.collectionView.collectionViewLayout as? UICollectionViewFlowLayout else {
        return
      }

      let cellWidthIncludeSpacing = layout.itemSize.width + layout.minimumLineSpacing
      let offsetX = owner.collectionView.contentOffset.x
      let index = round((offsetX + owner.collectionView.contentInset.left) / cellWidthIncludeSpacing)
      let indexPath = IndexPath(item: Int(index), section: 0)

      if let cell = owner.collectionView.cellForItem(at: indexPath) {
        UIView.animate(withDuration: 0.25) {
          var transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
          transform = transform.translatedBy(x: 0, y: -20)
          cell.transform = transform
        }
      }

      if Int(index) != owner.previousIndex {
        let cell = owner.collectionView.cellForItem(at: .init(item: Int(owner.previousIndex), section: 0))
        UIView.animate(withDuration: 0.25) {
          let transform: CGAffineTransform = .identity
          cell?.transform = transform
        }
        owner.previousIndex = indexPath.item
      }
    }
  }
}
