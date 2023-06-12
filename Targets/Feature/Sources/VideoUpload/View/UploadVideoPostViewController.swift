//
//  UploadVideoPostViewController.swift
//  Feature
//
//  Created by 한상진 on 2023/01/26.
//  Copyright © 2023 PhoChak. All rights reserved.
//

import Core
import Domain
import DesignKit
import UIKit

import RxCocoa
import RxDataSources
import RxSwift
import SnapKit
import Then

final class UploadVideoPostViewController: BaseViewController<UploadVideoPostReactor> {

  // MARK: Properties
  private let imagePicker: UIImagePickerController = .init()
  private let closeButton: UIButton = .init()
  private let reselectionButton: UIButton = .init()
  private let categoryLabel: UILabel = .init()
  private let categoryButtons: PostCategoryButtonStackView = .init()
  private let categoryErrorLabel: UILabel = .init()
  private let hashTagLabel: UILabel = .init()
  private let hashTagTextField: PhoChakTextField = .init(fieldStyle: .text)
  private let hashTagErrorLabel: UILabel = .init()
  private let warningLabel: UILabel = .init()
  private let flowLayout: LeftAlignedCollectionViewFlowLayout = .init()
  private lazy var hashTagCollectionView: UICollectionView = .init(
    frame: .zero,
    collectionViewLayout: flowLayout
  )
  private let completionButton: CompletionButton = .init()
  private lazy var loadingAnimationView: PhoChakLoadingViewController = .init()
  private let fileManager: PhoChakFileManagerType
  private var videoFile: VideoFile?

  // MARK: Initializer
  init(reactor: UploadVideoPostReactor, fileManager: PhoChakFileManagerType) {
    self.fileManager = fileManager
    super.init()

    modalPresentationStyle = .fullScreen
    self.reactor = reactor
  }

  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  // MARK: Override
  override func viewDidLoad() {
    setupImagePicker()
    super.viewDidLoad()
  }

  override func bind(reactor: UploadVideoPostReactor) {
    bindAction(reactor: reactor)
    bindState(reactor: reactor)
    bindCollectionView(reactor: reactor)
    bindExtra()
  }

  override func setupViews() {
    super.setupViews()

    view.addSubview(categoryButtons)
    view.addSubview(hashTagTextField)
    view.addSubview(warningLabel)
    view.addSubview(completionButton)

    closeButton.do {
      $0.setImage(UIImage(literal: .close), for: .normal)
      view.addSubview($0)
    }

    reselectionButton.do {
      $0.setTitle("재선택", for: .normal)
      $0.titleLabel?.font = UIFont(size: .Caption, weight: .w600)
      $0.setTitleColor(.createColor(.blue, .w400), for: .normal)
      view.addSubview($0)
    }

    categoryLabel.do {
      $0.text = "카테고리"
      $0.font = UIFont(size: .Title3, weight: .w800)
      $0.textColor = .createColor(.monoGray, .w50)
      view.addSubview($0)
    }

    categoryErrorLabel.do {
      $0.text = "카테고리를 선택해주세요"
      $0.font = UIFont(size: .Body, weight: .w400)
      $0.textColor = .createColor(.red, .w400)
      view.addSubview($0)
    }

    hashTagLabel.do {
      $0.text = "해쉬태그"
      $0.font = UIFont(size: .Title3, weight: .w800)
      $0.textColor = .createColor(.monoGray, .w50)
      view.addSubview($0)
    }

    hashTagErrorLabel.do {
      $0.font = UIFont(size: .Body, weight: .w400)
      $0.textColor = .createColor(.red, .w400)
      view.addSubview($0)
    }

    flowLayout.do {
      $0.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
      $0.minimumLineSpacing = 10
      $0.minimumInteritemSpacing = 19
    }

    hashTagCollectionView.do {
      $0.bounces = false
      $0.backgroundColor = .clear
      $0.registerCell(cellType: UploadVideoPostCell.self)
      view.addSubview($0)
    }

    warningLabel.do {
      $0.textColor = .red
      $0.numberOfLines = 0
      $0.font = .systemFont(ofSize: 14)
      $0.text = "부적절하거나 불쾌감을 줄 수 있는 컨텐츠는 제재를 받을 수 있습니다.\n5회 이상 신고 누적시 더이상 포스트를 작성할 수 없습니다."
      view.addSubview($0)
    }
  }

  override func setupLayoutConstraints() {
    closeButton.snp.makeConstraints {
      $0.leading.equalToSuperview().offset(20)
      $0.top.equalTo(view.safeAreaLayoutGuide).offset(10)
    }

    reselectionButton.snp.makeConstraints {
      $0.centerY.equalTo(closeButton)
      $0.trailing.equalToSuperview().inset(35)
    }

    categoryLabel.snp.makeConstraints {
      $0.top.equalTo(closeButton.snp.bottom).offset(36)
      $0.leading.equalToSuperview().offset(30)
    }

    categoryButtons.snp.makeConstraints {
      $0.top.equalTo(categoryLabel.snp.bottom).offset(20)
      $0.height.equalTo(35)
      $0.leading.equalToSuperview().offset(20)
      $0.trailing.equalToSuperview().inset(155)
    }

    categoryErrorLabel.snp.makeConstraints {
      $0.centerY.equalTo(categoryLabel)
      $0.trailing.equalToSuperview().inset(20)
    }

    hashTagLabel.snp.makeConstraints {
      $0.top.equalTo(categoryButtons.snp.bottom).offset(60)
      $0.leading.equalToSuperview().offset(30)
    }

    hashTagTextField.snp.makeConstraints {
      $0.top.equalTo(hashTagLabel.snp.bottom).offset(20)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.height.equalTo(view.frame.height * 0.071)
    }

    hashTagErrorLabel.snp.makeConstraints {
      $0.centerY.equalTo(hashTagLabel)
      $0.trailing.equalToSuperview().inset(20)
    }

    completionButton.snp.makeConstraints {
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(view.safeAreaLayoutGuide).offset(-60)
      $0.height.equalTo(hashTagTextField)
    }

    warningLabel.snp.makeConstraints {
      $0.leading.equalTo(completionButton).offset(2)
      $0.trailing.equalTo(completionButton).inset(2)
      $0.bottom.equalTo(completionButton.snp.top).offset(-5)
    }

    hashTagCollectionView.snp.makeConstraints {
      $0.top.equalTo(hashTagTextField.snp.bottom).offset(30)
      $0.leading.trailing.equalToSuperview().inset(20)
      $0.bottom.equalTo(completionButton.snp.top).offset(-60)
    }
  }
}

// MARK: - Private
private extension UploadVideoPostViewController {

  // MARK: Properties
  typealias Section = RxCollectionViewSectionedAnimatedDataSource<HashTagSection>
  typealias Action = UploadVideoPostReactor.Action
  typealias State = UploadVideoPostReactor.State

  // MARK: Methods
  func setupImagePicker() {
    imagePicker.sourceType = .savedPhotosAlbum
    imagePicker.mediaTypes = ["public.movie"]
    imagePicker.allowsEditing = true
    imagePicker.videoMaximumDuration = 30
    imagePicker.videoQuality = .typeIFrame1280x720
    imagePicker.delegate = self
    imagePicker.presentationController?.delegate = self
    present(imagePicker, animated: true)
  }

  func selectCategory(_ category: PostCategory) -> UploadVideoPostReactor.Action {
    categoryButtons.selectCategory(category)
    return .tapCategoryButton(category: category.uppercasedString)
  }

  func bindAction(reactor: UploadVideoPostReactor) {
    closeButton.rx.tap
      .asSignal()
      .map { Action.tapCloseButton }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    categoryButtons.tourButtonTapSignal
      .withUnretained(self)
      .map { owner, _ in owner.selectCategory(.tour) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    categoryButtons.restaurantButtonTapSignal
      .withUnretained(self)
      .map { owner, _ in owner.selectCategory(.restaurant) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    categoryButtons.cafeButtonTapSignal
      .withUnretained(self)
      .map { owner, _ in owner.selectCategory(.cafe) }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    hashTagTextField.rx.controlEvent(.editingDidEndOnExit)
      .withLatestFrom(hashTagTextField.rx.text.orEmpty)
      .filter { !$0.isEmpty }
      .asSignal(onErrorSignalWith: .empty())
      .withUnretained(self)
      .map { owner, tagText in
        owner.hashTagTextField.rx.text.onNext("")
        owner.hashTagCollectionView.flashScrollIndicators()
        return Action.inputHashTag(tag: tagText)
      }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)

    completionButton.rx.tap
      .asSignal()
      .withUnretained(self)
      .map { owner, _ in
        Action.tapCompletionButton(videoFile: owner.videoFile ?? .init(fileName: "", fileType: ""))
      }
      .emit(to: reactor.action)
      .disposed(by: disposeBag)
  }

  func bindState(reactor: UploadVideoPostReactor) {
    reactor.state
      .map { $0.isEnableComplete }
      .distinctUntilChanged()
      .bind(to: completionButton.isTapEnableSubject)
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.hashTags.count <= 30 }
      .bind(with: self, onNext: { owner, state in
        owner.hashTagErrorLabel.isHidden = state
        if !state { owner.hashTagErrorLabel.text = "30개를 넘길 수 없습니다" }
      })
      .disposed(by: disposeBag)

    reactor.state
      .map { $0.isLoading }
      .distinctUntilChanged()
      .skip(1)
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, isLoading in
        isLoading ? owner.loadingAnimationView.play(on: owner) : owner.loadingAnimationView.stop()
      })
      .disposed(by: disposeBag)
    
    reactor.state
      .map { $0.isError }
      .distinctUntilChanged()
      .filter { $0 }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.presentAlert(
          type: .networkError,
          okAction: { [weak self] in
            self?.reactor?.action.onNext(.tapAlertAcceptButton)
          })
      })
      .disposed(by: disposeBag)
  }

  func bindCollectionView(reactor: UploadVideoPostReactor) {
    let dataSource: Section = .init(configureCell: { _, collectionView, indexPath, tagText in
      let cell = collectionView.dequeue(cellType: UploadVideoPostCell.self, indexPath: indexPath)
      cell.configure(tagText: tagText)

      cell.deletionButtonTapObservable
        .map { _ in Action.tapHashTagDeletionButton(tag: tagText) }
        .bind(to: reactor.action)
        .disposed(by: cell.disposeBag)

      return cell
    })

    reactor.state
      .map { [HashTagSection(header: "", items: $0.hashTags)] }
      .distinctUntilChanged()
      .bind(to: hashTagCollectionView.rx.items(dataSource: dataSource))
      .disposed(by: disposeBag)
  }

  func bindExtra() {
    view.addTapGesture().rx.event
      .filter { $0.state == .recognized }
      .asSignal(onErrorSignalWith: .empty())
      .emit(with: self, onNext: { owner, _ in
        owner.view.endEditing(true)
      })
      .disposed(by: disposeBag)

    categoryButtons.isTappedSignal
      .emit(to: categoryErrorLabel.rx.isHidden)
      .disposed(by: disposeBag)

    hashTagTextField.rx.text.orEmpty
      .map(changeValidHashTag)
      .bind(to: hashTagTextField.rx.text)
      .disposed(by: disposeBag)

    reselectionButton.rx.tap
      .asSignal()
      .emit(with: self, onNext: { owner, _ in
        owner.present(owner.imagePicker, animated: true)
      })
      .disposed(by: disposeBag)
  }

  func changeValidHashTag(_ text: String) -> String {
    guard let lastText = text.last else { return text }

    if lastText == " " || text.count > 20 {
      return String(text.dropLast())
    }

    if String(lastText).range(
      of: "^[ㄱ-ㅎㅏ-ㅣ가-힣a-zA-Z0-9\\_]$",
      options: .regularExpression
    ) == nil {
      hashTagErrorLabel.text = "특수문자는 _ 만 쓸 수 있어요"
      hashTagErrorLabel.isHidden = false
      return String(text.dropLast())
    }

    return text
  }
}

// MARK: - Extension
extension UploadVideoPostViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

  // MARK: Methods
  public func imagePickerController(
    _ picker: UIImagePickerController,
    didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]
  ) {
    picker.dismiss(animated: true)

    guard let videoURL = info[UIImagePickerController.InfoKey.mediaURL] as? URL,
          let videoData = try? Data(contentsOf: videoURL),
          let videoName = videoURL.absoluteString.split(separator: "/").map({ String($0) }).last,
          let videoType = videoName.split(separator: ".").map ({ String($0) }).last
    else { return }

    videoFile = .init(
      fileName: videoName,
      fileType: videoType
    )

    fileManager.saveVideo(name: videoName,data: videoData)
  }

  public func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
    picker.dismiss(animated: true) { self.dismiss(animated: true) }
  }
}

extension UploadVideoPostViewController: UIAdaptivePresentationControllerDelegate {

  // MARK: Methods
  func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
    dismiss(animated: true)
  }
}
