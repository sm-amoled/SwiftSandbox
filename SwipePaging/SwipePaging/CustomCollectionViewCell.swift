//
//  CustomCollectionViewCell.swift
//  SwipePaging
//
//  Created by Park Sungmin on 2022/11/24.
//

import UIKit

protocol CustomCollectionViewCellDelegate {
    func enterDeletePageMode(indexPath: IndexPath)
}

class CustomCollectionViewCell: UICollectionViewCell {
    var delegate: CustomCollectionViewCellDelegate?
    var indexPathOfCell: IndexPath!
    
    let pageImage: UIView = {
        let view = UIView()
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setGestureRecognizer()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpLayout() {
        contentView.addSubview(pageImage)
        pageImage.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    func setGestureRecognizer() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(pressDeleteButton(_:)))

        longPressGesture.minimumPressDuration = 0.5
        longPressGesture.allowableMovement = 40

        contentView.addGestureRecognizer(longPressGesture)
    }
    
    func transformToLarge() {
        UIView.animate(withDuration: 0.2) {
            self.transform = CGAffineTransform(scaleX: 1.50, y: 1.50)
            self.layer.borderColor = UIColor.black.cgColor
            self.layer.borderWidth = 1.3
        }
    }
    
    func transformToStandard() {
        UIView.animate(withDuration: 0.2) {
            self.layer.borderWidth = 0
            self.transform = CGAffineTransform.identity
        }
    }
    
    override func prepareForReuse() {
        self.layer.borderWidth = 0
        self.transform = CGAffineTransform(scaleX: 1, y: 1)
    }
    
    @objc func pressDeleteButton(_ sender: UILongPressGestureRecognizer) {
        if sender.state == .began {
            delegate?.enterDeletePageMode(indexPath: indexPathOfCell)
        }
    }
}

protocol CustomAddCollectionViewCellDelegate {
    func tapAddPageButton()
}

class CustomAddCollectionViewCell: UICollectionViewCell {
    var delegate: CustomAddCollectionViewCellDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUpLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var button: UIButton = {
        let button = UIButton(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        button.setImage(UIImage(systemName: "plus.circle.fill"), for: .normal)
        
        button.addTarget(self, action: #selector(tapAddButton(_:)), for: .touchUpInside)
        return button
    }()
    
    func setUpLayout() {
        contentView.addSubview(button)
        button.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
    
    @objc func tapAddButton(_ sender: UIButton) {
        delegate?.tapAddPageButton()
    }
}
