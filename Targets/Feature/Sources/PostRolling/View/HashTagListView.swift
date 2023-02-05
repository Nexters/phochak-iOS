//
//  HashTagListView.swift
//  Feature
//
//  Created by Ian on 2023/02/04.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Domain
import UIKit

import RxCocoa
import RxDataSources
import RxSwift

final class HashTagListView: UIView {
  typealias Section = RxCollectionViewSectionedAnimatedDataSource<HashTagSection>

  // MARK: Properties
  private let headerView: UIView = .init()
  private let nicknameLabel: UILabel = .init()
  private let exclameButton: UIButton = .init()
  private let likeButton: UIButton = .init()
  private let flowLayout: LeftAlignedCollectionViewFlowLayout = .init()
  lazy var collectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )
  lazy var dataSource: Section = .init(configureCell: { _, collectionView, indexPath, tagTitle in
    let cell = collectionView.dequeue(cellType: HashTagCell.self, indexPath: indexPath)
    cell.configure(tagTitle: tagTitle)
    return cell
  })
  private var videoPost: VideoPost?
  private let videoPostSubject: PublishSubject<VideoPost> = .init()
  private let disposeBag: DisposeBag = .init()

  override init(frame: CGRect) {
    super.init(frame: frame)

    setupViews()
    setupLayoutConstraints()

    videoPostSubject
      .map { videoPost -> [HashTagSection] in
        return [HashTagSection(header: "", items: videoPost.hashTags ?? [])]
      }
      .bind(to: collectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Methods
  func configure(videoPost: VideoPost) {
    self.videoPost = videoPost
    self.nicknameLabel.text = "포착러"
    videoPostSubject.onNext(videoPost)
  }
}

extension HashTagListView {
  var exclameButtonTap: Observable<Int> {
    exclameButton.rx.tap
      .map { [weak self] _ in self?.videoPost?.postID ?? 0 }
  }

  var likeButtonTap: Observable<Int> {
    likeButton.rx.tap
      .map { [weak self] _ in self?.videoPost?.postID ?? 0 }
  }
}

// MARK: - Private
private extension HashTagListView {
  func setupViews() {
    headerView.do {
      $0.backgroundColor = .clear
      addSubview($0)
    }

    nicknameLabel.do {
      $0.font = .createFont(.HeadLine, .w800)
      $0.textColor = .createColor(.monoGray, .w200)
      headerView.addSubview($0)
    }

    exclameButton.do {
      $0.setImage(.createImage(.exclameOff), for: .normal)
      headerView.addSubview($0)
    }

    likeButton.do {
      $0.setImage(.createImage(.heartOff), for: .normal)
      headerView.addSubview($0)
    }

    flowLayout.do {
      $0.minimumInteritemSpacing = 25
      $0.minimumLineSpacing = 33
      $0.sectionInset = .init(top: 0, left: 25, bottom: 0, right: 30)
      $0.scrollDirection = .vertical
    }

    collectionView.do {
      $0.backgroundColor = .clear
      $0.contentInsetAdjustmentBehavior = .never
      $0.registerCell(cellType: HashTagCell.self)
      $0.isPagingEnabled = false
      $0.showsVerticalScrollIndicator = false
      $0.showsHorizontalScrollIndicator = false
      $0.delegate = self
      addSubview($0)
    }
  }

  func setupLayoutConstraints() {
    headerView.snp.makeConstraints {
      $0.top.leading.trailing.equalToSuperview()
      $0.height.equalTo(50)
    }

    nicknameLabel.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(25)
      $0.centerY.equalToSuperview()
    }

    likeButton.snp.makeConstraints {
      $0.trailing.equalToSuperview().offset(-23.75)
      $0.centerY.equalToSuperview()
    }

    exclameButton.snp.makeConstraints {
      $0.trailing.equalTo(likeButton.snp.leading).offset(-18.75)
      $0.centerY.equalToSuperview()
    }

    collectionView.snp.makeConstraints {
      $0.top.equalTo(headerView.snp.bottom)
      $0.leading.trailing.bottom.equalToSuperview()
    }
  }
}

// MARK: - UICollectionViewDelegateFlowLayout
extension HashTagListView: UICollectionViewDelegateFlowLayout {
  func collectionView(
    _ collectionView: UICollectionView,
    layout collectionViewLayout: UICollectionViewLayout,
    sizeForItemAt indexPath: IndexPath
  ) -> CGSize {
    guard let hashTag = videoPost?.hashTags?[safe: indexPath.item] else {
      return .zero
    }

    let hashTagSize = ("#" + hashTag).size(withAttributes: [
      .font: UIFont.createFont(.Caption, .w400)
    ])

    return hashTagSize
  }
}
