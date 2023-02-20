//
//  PostRollingViewController.swift
//  Feature
//
//  Created by Ian on 2023/01/30.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

import RxCocoa
import RxSwift

protocol PostRollingDelegate: AnyObject {
  func scrollToItem(with videoPosts: [VideoPost], index: Int)
}

final class PostRollingViewController: BaseViewController<PostRollingReactor> {

  // MARK: Properties
  private let flowLayout: UICollectionViewFlowLayout = .init()
  private lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )
  private let exclameButtonTapSubject: PublishSubject<Int> = .init()
  private let likeButtonTapSubject: PublishSubject<Int> = .init()
  private let topGradientView: UIView = .init()
  weak var delegate: PostRollingDelegate?

  // MARK: Initializer
  init(reactor: PostRollingReactor) {
    super.init()

    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    super.viewDidLoad()

    navigationController?.interactivePopGestureRecognizer?.isEnabled = false
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    let gradient = CAGradientLayer().then {
      $0.frame = .init(x: 0, y: 0, width: view.frame.width, height: view.frame.height * 0.1)
      $0.colors = [
        UIColor.createColor(.monoGray, .w950, alpha: 0.3).cgColor,
        UIColor.createColor(.monoGray, .w950, alpha: 0.0).cgColor
      ]
      $0.locations = [0.0, 1.0]
    }
    topGradientView.layer.insertSublayer(gradient, at: 0)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()

    collectionView.scrollToItem(
      at: .init(item: reactor?.currentIndex ?? 0, section: 0),
      at: .centeredHorizontally,
      animated: false
    )
  }

  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)

    NotificationCenter.default.post(name: .muteAllPlayers, object: nibName)

    delegate?.scrollToItem(with: reactor?.currentState.videoPosts ?? [], index: reactor?.currentIndex ?? 0)
    navigationController?.interactivePopGestureRecognizer?.isEnabled = true
  }

  override func setupViews() {
    super.setupViews()

    flowLayout.do {
      $0.minimumLineSpacing = 0
      $0.sectionInset = .zero
      $0.scrollDirection = .horizontal
      $0.itemSize = .init(
        width: view.frame.width,
        height: view.frame.height
      )
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.contentInsetAdjustmentBehavior = .never
      $0.registerCell(cellType: DetailPostCell.self)
      $0.isPagingEnabled = true
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      view.addSubview($0)
    }

    collectionView.addSubview(topGradientView)
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.edges.equalToSuperview()
    }

    topGradientView.snp.makeConstraints {
      $0.top.equalTo(view.snp.top)
      $0.leading.trailing.equalToSuperview()
      $0.height.equalTo(view.frame.height * 0.15)
    }
  }

  override func bind(reactor: PostRollingReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension PostRollingViewController {
  func bindAction(reactor: PostRollingReactor) {
    Observable.just(())
      .map { PostRollingReactor.Action.load }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.willEndDragging
      .withUnretained(self)
      .map({ (owner, event) -> Int in
        let index = Int(event.targetContentOffset.pointee.x / owner.collectionView.frame.width)
        return index
      })
      .map { PostRollingReactor.Action.fetchItems(size: 3, currentIndex: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    exclameButtonTapSubject
      .map { PostRollingReactor.Action.exclameVideoPost(postID: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    likeButtonTapSubject
      .map { PostRollingReactor.Action.likeVideoPost(postID: $0) }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: PostRollingReactor) {
    reactor.state
      .map { $0.videoPosts }
      .bind(to: collectionView.rx.items(
        cellIdentifier: "\(DetailPostCell.self)",
        cellType: DetailPostCell.self)
      ) { [weak self] _, post, cell in
        cell.configure(reactor: .init(videoPost: post))
        if let exclameButtonTapSubject = self?.exclameButtonTapSubject {
          cell.exclameButtonTapSubject
            .subscribe(exclameButtonTapSubject)
            .disposed(by: cell.disposeBag)
        }

        if let likeButtonTapSubject = self?.likeButtonTapSubject {
          cell.likeButtonTapSubject
            .subscribe(likeButtonTapSubject)
            .disposed(by: cell.disposeBag)
        }
      }
      .disposed(by: disposeBag)
  }
}
