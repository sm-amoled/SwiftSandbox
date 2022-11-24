//
//  CollectionViewZoomCell.swift
//  SwipePaging
//
//  Created by Park Sungmin on 2022/11/24.
//  https://medium.com/@sh.soheytizadeh/zoom-uicollectionview-centered-cell-swift-5-e63cad9bcd49

import UIKit

import SnapKit

class CollectionViewZoomCellViewController: UIViewController {
    //    var colors = ["#FA4F79", "#FC676B", "#FF6844", "#FA975C", "#FDA84B", "#FDA84B", "#EDC32B", "#EDD70E", "#C3CB16", "#A2C41F", "#8BCD1F", "#8BCD1F", "#25C43F", "#30CF7A", "#4AE6AC", "#3BEABC", "#25DCBC", "#25CDBE", "#4AE2DF", "#30D2DC", "#02A7BE", "#30B4D4", "#2DBAEE", "#54B4FE", "#97BEFF", "#90A2FE", "#C3BCFC", "#DBC5FE", "#CD82FA", "#E885F9", "#FF42F8", "#FA5ADA", "#FF97DA", "#FB89C1", "#FBA5C3"]
    var colors = ["#FA4F79", "#FC676B", "#FF6844"]
    
    var pages: [String] = []
    
    var centerCell: CustomCollectionViewCell?
    
    let generator = UISelectionFeedbackGenerator()
    
    let pageView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }()
    
    let collectionView: UICollectionView = {
        //        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
        let layout = CustomUICollectionViewFlowLayout()
        let collection = UICollectionView(frame: CGRect(x: 0, y: 0, width: 0, height: 0), collectionViewLayout: layout)
        collection.backgroundColor = .white
        collection.showsHorizontalScrollIndicator = false
        collection.register(CustomCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cell")
        collection.register(CustomAddCollectionViewCell.classForCoder(), forCellWithReuseIdentifier: "cellAdd")
        
        return collection
    }()
    
    lazy var deleteView: UIView = {
        let view = UIView()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(cancelDeleteMode))
        view.addGestureRecognizer(gestureRecognizer)
        
        return view
    }()
    
    lazy var deleteButton: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 40, height: 40))
        
        button.setImage(UIImage(systemName: "minus.circle.fill"), for: .normal)
        button.addTarget(self, action: #selector(deletePage(_:)), for: .touchUpInside)
        button.tintColor = .systemRed
        
        return button
    }()
    
    lazy var deleteImage: UIView = {
        let view = UIView(frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        view.layer.cornerRadius = view.bounds.width / 2
        view.backgroundColor = .white
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpCollectionView()
        setUpLayout()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let layoutMargins: CGFloat = self.collectionView.layoutMargins.left
        let sideInset = self.view.frame.width / 2 - layoutMargins
        self.collectionView.contentInset = UIEdgeInsets(top: 0, left: sideInset, bottom: 0, right: sideInset)
        
//        scrollViewDidScroll(collectionView)
        scrollToElement(of: IndexPath(row: 0, section: 0))
    }
    
    func cellSelected() {
        guard centerCell is CustomCollectionViewCell else {
            return
        }
        
        if pageView.backgroundColor != centerCell?.backgroundColor {
            generator.selectionChanged()
            pageView.backgroundColor = centerCell?.backgroundColor
        }
    }
    
    func showDeleteView(for indexPath: IndexPath) {
        view.addSubview(deleteView)
        deleteView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        deleteView.addSubview(deleteButton)
        deleteButton.snp.makeConstraints {
            $0.centerX.equalTo(deleteView.snp.centerX)
            $0.bottom.equalTo(collectionView.snp.top).offset(-20)
        }
        
        deleteImage.backgroundColor = (self.collectionView.cellForItem(at: indexPath)! as! CustomCollectionViewCell).backgroundColor
        deleteView.addSubview(deleteImage)
        deleteImage.snp.makeConstraints {
            $0.center.equalTo(self.collectionView.cellForItem(at: indexPath)!.snp.center)
            $0.width.height.equalTo(self.collectionView.cellForItem(at: indexPath)!.frame.width)
        }
    }
    
    @objc func cancelDeleteMode() {
        deleteView.removeFromSuperview()
        deleteButton.removeFromSuperview()
    }
    
    @objc func deletePage(_ sender: UIButton) {
        guard let targetPage = centerCell else { return }
                
        if colors.count > 1 {
            colors.remove(at: targetPage.indexPathOfCell.row)
        }
        
        collectionView.reloadData()
        
        let nextPath = IndexPath(row: (targetPage.indexPathOfCell.row - 1 >= 0) ? targetPage.indexPathOfCell.row - 1 : 1,
                                 section: targetPage.indexPathOfCell.section)
        
        scrollToElement(of: nextPath)
        scrollViewDidScroll(collectionView)
        cancelDeleteMode()
    }
}

extension CollectionViewZoomCellViewController {
    func setUpLayout() {
        view.addSubview(pageView)
        pageView.snp.makeConstraints {
            $0.horizontalEdges.top.equalToSuperview()
            $0.bottom.equalToSuperview().inset(100)
        }
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.top.equalTo(pageView.snp.bottom)
            $0.height.equalTo(60)
        }
    }
    
    func setUpCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    func scrollToRight() {
        collectionView.setContentOffset(CGPoint(x: collectionView.contentSize.width - collectionView.bounds.size.width + collectionView.contentInset.right, y: 0), animated: true)
    }
    
    
    private func scrollToElement(of indexPath: IndexPath) {
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
    }
}

extension CollectionViewZoomCellViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        guard scrollView is UICollectionView else { return }
        
        let centerPoint = CGPoint(x: self.collectionView.frame.size.width / 2 + scrollView.contentOffset.x,
                                  y: self.collectionView.frame.size.height / 2 + scrollView.contentOffset.y)
        
        if let indexPath = collectionView.indexPathForItem(at: centerPoint) {
            if indexPath.row == colors.count {

            } else {
                self.centerCell = self.collectionView.cellForItem(at: indexPath) as? CustomCollectionViewCell
                centerCell?.transformToLarge()
                cellSelected()
                
                let beforeIndexPath = IndexPath(row: indexPath.row - 1, section: indexPath.section)
                let afterIndexPath = IndexPath(row: indexPath.row + 1, section: indexPath.section)
                
                if let beforeCell = (self.collectionView.cellForItem(at: beforeIndexPath) as? CustomCollectionViewCell) {
                    beforeCell.transformToStandard()
                }
                if let afterCell = (self.collectionView.cellForItem(at: afterIndexPath) as? CustomCollectionViewCell) {
                    afterCell.transformToStandard()
                }
            }
        }
    }
}

extension CollectionViewZoomCellViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.colors.count + 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == self.colors.count {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellAdd", for: indexPath) as! CustomAddCollectionViewCell
            cell.delegate = self
            return cell
        }
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CustomCollectionViewCell
        cell.delegate = self
        cell.indexPathOfCell = indexPath
        cell.layer.cornerRadius = cell.frame.height / 2
        cell.backgroundColor = UIColor(self.colors[indexPath.row])
        
        return cell
    }
}

extension CollectionViewZoomCellViewController: CustomAddCollectionViewCellDelegate {
    func tapAddPageButton() {
        colors.append("#CCCCCC")
        collectionView.reloadData()
        scrollToRight()
    }
}

extension CollectionViewZoomCellViewController: CustomCollectionViewCellDelegate {
    func enterDeletePageMode(indexPath: IndexPath) {
        scrollToElement(of: indexPath)
        showDeleteView(for: indexPath)
        
        UIView.animate(withDuration: 0.2) {
            self.deleteImage.transform = CGAffineTransform(scaleX: 1.8, y: 1.8)
        }
    }
}
