//
//  SerachViewController.swift
//  PhoChak
//
//  Created by 여정수 on 2023/05/25.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import DesignKit
import Domain
import UIKit

import RxSwift

final class SearchViewController: BaseViewController<SearchReactor> {

  // MARK: Properties
  private let searchBar: UISearchBar = .init()
  private lazy var collectionView: UICollectionView = .init(frame: .zero, collectionViewLayout: createLayout())
  private var categoryOptionHeaderView: CategoryOptionHeaderView?
  private lazy var emptySearchResultView: EmptySearchResultView = .init()
  private lazy var dataSource: UICollectionViewDiffableDataSource<Int, VideoPost> = createDataSource()

  // MARK: Initializer
  init(reactor: SearchReactor) {
    super.init()
    var snapshot = dataSource.snapshot()
    snapshot.appendSections([0])
    dataSource.apply(snapshot)
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)

    if let query = reactor?.dependency.query, !query.isEmpty {
      searchBar.text = query
    } else {
      searchBar.becomeFirstResponder()
    }
  }

  override func setupViews() {
    super.setupViews()
    view.addSubview(emptySearchResultView)

    searchBar.do {
      $0.placeholder = "어떤 주제를 찾아볼까요"
      $0.barTintColor = .createColor(.monoGray, .w800)
      view.addSubview($0)
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.showsHorizontalScrollIndicator = false
      $0.showsVerticalScrollIndicator = false
      $0.dataSource = dataSource
      $0.keyboardDismissMode = .onDrag
      $0.registerCell(cellType: SearchResultVideoPostCell.self)
      $0.registerCell(cellType: DefaultCell.self)
      $0.registerHeader(viewType: CategoryOptionHeaderView.self)
      view.addSubview($0)
    }

    navigationItem.titleView = searchBar
  }

  override func setupLayoutConstraints() {
    collectionView.snp.makeConstraints {
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(15)
      $0.leading.trailing.bottom.equalToSuperview()
    }

    emptySearchResultView.snp.makeConstraints {
      $0.leading.trailing.bottom.equalTo(collectionView)
      $0.top.equalTo(collectionView).offset(45)
    }
  }

  override func bind(reactor: SearchReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
  }
}

// MARK: - Private
private extension SearchViewController {
  typealias Action = SearchReactor.Action

  func bindAction(reactor: SearchReactor) {
    rx.viewDidLoad
//      .filter { [weak self] in !(self?.reactor?.dependency.query.isEmpty ?? true) }
      .map { Action.viewDidLoad }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    searchBar.rx.searchButtonClicked
      .map { [weak self] in Action.search(query: self?.searchBar.text ?? "") }
      .bind(to: reactor.action)
      .disposed(by: disposeBag)

    collectionView.rx.itemSelected
      .subscribe(with: self, onNext: { owner, indexPath in
        owner.reactor?.action.onNext(.tapVideoPost(indexPath.item))
      })
      .disposed(by: disposeBag)

    collectionView.rx.didScroll
      .skip(1)
      .filter { [weak self] in !(self?.reactor?.currentState.isLoading ?? true) }
      .subscribe(with: self, onNext: { owner, _ in
        let offsetY = owner.collectionView.contentOffset.y
        let contentHeight = owner.collectionView.contentSize.height
        let height = owner.collectionView.frame.height

        guard contentHeight != 0 else {
          return
        }

        if offsetY > (contentHeight - height) && !(owner.reactor?.isPaging ?? true) {
          owner.reactor?.action.onNext(.fetchMoreItems(currentQuery: owner.searchBar.text))
        }
      })
      .disposed(by: disposeBag)
  }

  func bindState(reactor: SearchReactor) {
    reactor.state
      .map { $0.videoPosts }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, videoPosts in
        owner.applySnapshot(videoPosts)
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .asSignal(onErrorSignalWith: .empty())
      .emit(onNext: { isLoading in
        if isLoading {
          ActivityIndicatorView.show()
        } else {
          ActivityIndicatorView.hide()
        }
      })
      .disposed(by: disposeBag)
  }

  func applySnapshot(_ videoPosts: [VideoPost]) {
    emptySearchResultView.isHidden = !videoPosts.isEmpty
    if videoPosts.isEmpty {
      view.bringSubviewToFront(emptySearchResultView)
    } else {
      view.bringSubviewToFront(collectionView)
    }

    if searchBar.isFirstResponder {
      searchBar.resignFirstResponder()
    }

    var snapshot = NSDiffableDataSourceSnapshot<Int, VideoPost>()
    snapshot.appendSections([0])
    snapshot.appendItems(videoPosts)
    dataSource.apply(snapshot)
  }

  func createDataSource() -> UICollectionViewDiffableDataSource<Int, VideoPost> {
    let dataSource = UICollectionViewDiffableDataSource<Int, VideoPost>(collectionView: collectionView) { collectionView, indexPath, videoPost in
      let cell = collectionView.dequeue(cellType: SearchResultVideoPostCell.self, indexPath: indexPath)
      cell.configure(videoPost)
      return cell
    }

    dataSource.supplementaryViewProvider = { [weak self] collectionView, kind, indexPath in
      guard kind == UICollectionView.elementKindSectionHeader, let self else {
        return nil
      }

      let headerView = collectionView.dequeueHeader(viewType: CategoryOptionHeaderView.self, indexPath: indexPath)
      self.categoryOptionHeaderView = headerView
      headerView.categoryButtonTapSignal
        .emit(with: self, onNext: { owner, category in
          owner.reactor?.action.onNext(.tapCategoryButton(category, query: owner.searchBar.text))
        })
        .disposed(by: self.disposeBag)
      return headerView
    }

    return dataSource
  }

  func createLayout() -> UICollectionViewCompositionalLayout {
    let leftLargePostItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.67), heightDimension: .fractionalHeight(1.0)))
    leftLargePostItem.contentInsets = .init(top: 0, leading: 10, bottom: 7, trailing: 3.5)

    let defaultItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1/2)))
    defaultItem.contentInsets = .init(top: 0, leading: 3.5, bottom: 7, trailing: 3.5)

    let verticalDefaultItemGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1.0)),
      subitems: [defaultItem, defaultItem]
    )

    let largePostInLeftGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0)),
      subitems: [leftLargePostItem, verticalDefaultItemGroup]
    )
    largePostInLeftGroup.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 2.5)

    let tripleDefaultItem = NSCollectionLayoutItem(
      layoutSize: .init(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalWidth(0.54))
    )
    tripleDefaultItem.contentInsets = .init(top: 0, leading: 3.0, bottom: 0, trailing: 3.0)

    let tripleDefaultItemGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6)),
      subitem: tripleDefaultItem, count: 3
    )
    tripleDefaultItemGroup.contentInsets = .init(top: 0, leading: 8.5, bottom: -25, trailing: 3.5)
    tripleDefaultItemGroup.edgeSpacing = .init(leading: nil, top: nil, trailing: nil, bottom: .fixed(-15))

    let tripleGroup = NSCollectionLayoutGroup.horizontal(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(0.6)),
      subitem: tripleDefaultItem, count: 3
    )
    tripleGroup.contentInsets = .init(top: 0, leading: 8.5, bottom: 0, trailing: 3.5)

    let totalGroup = NSCollectionLayoutGroup.vertical(
      layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(2.20)),
      subitems: [largePostInLeftGroup, tripleDefaultItemGroup, tripleGroup]
    )

    let headerItem = NSCollectionLayoutBoundarySupplementaryItem(
      layoutSize: .init(widthDimension: .fractionalWidth(0.67), heightDimension: .estimated(45)),
      elementKind: UICollectionView.elementKindSectionHeader,
      alignment: .topLeading
    )
    headerItem.contentInsets = .init(top: 0, leading: 10, bottom: 0, trailing: 10)

    let section = NSCollectionLayoutSection(group: totalGroup)
    section.boundarySupplementaryItems = [headerItem]
    return UICollectionViewCompositionalLayout(section: section)
  }
}
