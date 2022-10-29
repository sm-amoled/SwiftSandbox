//
//  ViewController.swift
//  PracticeCollectionView
//
//  Created by Park Sungmin on 2022/10/19.
//

import UIKit
import SnapKit

class ViewController: UIViewController {
    
    let sidePadding: CGFloat = 16
    
    let headerView: UIView = {
        let view = UIView()
        view.backgroundColor = .systemGray5
        return view
    }()
    
    let logoView: UILabel = {
        let view = UILabel()
        view.text = "오르락 로고"
        view.font = UIFont.systemFont(ofSize: 22, weight: .bold)
        return view
    }()
    
    let toolbarView: UIToolbar = {
        let view = UIToolbar()
        view.backgroundColor = .systemGray5
        
        var items: [UIBarButtonItem] = []
        
        let myPageButton = UIBarButtonItem(image: UIImage(systemName: "person.crop.rectangle"), style: .plain, target: self, action: nil)
        let addVideoButton = UIBarButtonItem(image: UIImage(systemName: "camera.fill"), style: .plain, target: self, action: nil)
        
        let flexibleSpace = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        
        addVideoButton.showsMenuAsPrimaryAction = true
        addVideoButton.menu = UIMenu(options: .displayInline, children: [])
        addVideoButton.addAction(UIAction { [weak infoButton] (action) in
            addVideoButton?.menu = infoButton?.menu?.replacingChildren([])
        }, for: .menuActionTriggered)
        
        items.append(myPageButton)
        items.append(flexibleSpace)
        items.append(addVideoButton)
        
        items.forEach { (item) in
            item.tintColor = .systemBlue
        }
        
        view.setItems(items, animated: true)
        
        return view
    }()
    
    let collectionView: UICollectionView = {
        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: layout)
        view.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "collectionViewCardCell")
        view.backgroundColor = UIColor.clear
        
        view.register(CollectionViewCardCell.classForCoder(), forCellWithReuseIdentifier: "collectionViewCardCell")
        
        view.showsVerticalScrollIndicator = false
        
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = .systemGray5
        
        setLayout()
        setUICollectionView()
    }
    
    func setLayout() {
        self.view.addSubview(headerView)
        headerView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.top.equalTo(view.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        headerView.addSubview(logoView)
        logoView.snp.makeConstraints { make in
            make.bottom.equalTo(headerView.snp.bottom).offset(-18)
            make.leading.equalTo(headerView.snp.leading).offset(24)
        }
        
        self.view.addSubview(toolbarView)
        toolbarView.snp.makeConstraints { make in
            make.height.equalTo(45)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing)
        }
        
        self.view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.bottom.equalTo(toolbarView.snp.top)
            make.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).inset(sidePadding)
            make.trailing.equalTo(view.safeAreaLayoutGuide.snp.trailing).inset(sidePadding)
        }
    }
    
    func setUICollectionView() {
        collectionView.dataSource = self
        collectionView.delegate = self
    }
}

extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "collectionViewCardCell", for: indexPath) as! CollectionViewCardCell
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.bounds.width - 2 * sidePadding
        let height = width / 1.33
        
        return CGSize(width: Double(width), height: Double(height))
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 16
    }
}

class CollectionViewCardCell: UICollectionViewCell {
    
    let cardView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        return view
    }()
    
    let dateLabel: UILabel = {
        let view = UILabel()
        view.text = "YYYY년 MM월 DD일"
        view.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        return view
    }()
    
    let gymLabel: UILabel = {
        let view = UILabel()
        view.text = "클라이밍장 정보"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    let thumbnailCollectionView: UICollectionView = {
        let flow = UICollectionViewFlowLayout()
        flow.minimumInteritemSpacing = 1
        flow.minimumLineSpacing = 1
        
        var view = UICollectionView(frame: CGRect.zero, collectionViewLayout: flow)
        view.backgroundColor = UIColor.white
        view.register(ThumbnailCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "thumbnailCollectionViewCell")
        
        return view
    }()
    
    let countPFLabel: UILabel = {
        let view = UILabel()
        view.text = "N번의 성공, N번의 실패"
        view.font = UIFont.systemFont(ofSize: 12)
        return view
    }()
    
    let countTotalVideoLabel: UILabel = {
        let view = UILabel()
        view.text = "N개의 비디오"
        view.font = UIFont.systemFont(ofSize: 12)
        view.textColor = .gray
        return view
    }()
    
    
    let detailButton: UIButton = {
        let button = UIButton()
        button.setTitle("더 보기", for: .normal)
        button.setTitleColor(.black, for: .normal)
        //        button.backgroundColor = .gray
        return button
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setCollectionView()
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setCollectionView()
        setLayout()
    }
    
    
    func setLayout() {
        
        contentView.addSubview(cardView)
        cardView.snp.makeConstraints { make in
            make.edges.equalTo(contentView)
        }
        
        cardView.addSubview(thumbnailCollectionView)
        thumbnailCollectionView.snp.makeConstraints { make in
            make.leading.equalTo(cardView.snp.leading)
            make.trailing.equalTo(cardView.snp.trailing)
            make.centerY.equalTo(cardView.snp.centerY)
            make.height.equalTo(((UIScreen.main.bounds.width - 32) / 5 * 2))
        }
        
        cardView.addSubview(gymLabel)
        gymLabel.snp.makeConstraints { make in
            make.bottom.equalTo(thumbnailCollectionView.snp.top).offset(-8)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.bottom.equalTo(gymLabel.snp.top).offset(-4)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(countPFLabel)
        countPFLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnailCollectionView.snp.bottom).offset(8)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(countTotalVideoLabel)
        countTotalVideoLabel.snp.makeConstraints { make in
            make.top.equalTo(countPFLabel.snp.bottom).offset(4)
            make.leading.equalTo(cardView.snp.leading).offset(20)
        }
        
        cardView.addSubview(detailButton)
        detailButton.snp.makeConstraints { make in
            make.top.equalTo(thumbnailCollectionView.snp.bottom).offset(16)
            make.trailing.equalTo(cardView.snp.trailing).offset(-20)
            
        }
    }
    
    func setCollectionView() {
        thumbnailCollectionView.delegate = self
        thumbnailCollectionView.dataSource = self
    }
}

extension CollectionViewCardCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "thumbnailCollectionViewCell", for: indexPath) as! ThumbnailCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = contentView.bounds.width / 5 - 1
        let height = width
        
        return CGSize(width: Double(width), height: Double(height))
    }
}

class ThumbnailCollectionViewCell: UICollectionViewCell {
    let thumbnailView: UIImageView = {
        let view = UIImageView()
        return view
    }()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setLayout()
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setLayout()
    }
    
    
    func setLayout() {
        contentView.addSubview(thumbnailView)
        thumbnailView.backgroundColor = .systemGray
        
        thumbnailView.snp.makeConstraints { make in
            make.edges.equalTo(contentView.safeAreaLayoutGuide)
        }
    }
}

extension ViewController: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        return UIContextMenuConfiguration(
            identifier: nil,
            previewProvider: nil,
            actionProvider: { _ in
                let children: [UIMenuElement] = []
                return UIMenu(title: "", children: children)
            })
    }
    
    func makeRemoveRatingAction() -> UIAction {
      // 1
      var removeRatingAttributes = UIMenuElement.Attributes.destructive
      
      // 2
      // 3
      let deleteImage = UIImage(systemName: "delete.left")
      
      // 4
      return UIAction(
        title: "Remove rating",
        image: deleteImage,
        identifier: nil,
        attributes: removeRatingAttributes) { _ in
          print("hello")
        }
    }

}

