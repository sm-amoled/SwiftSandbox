//
//  CustomUICollectionViewFlowLayout.swift
//  SwipePaging
//
//  Created by Park Sungmin on 2022/11/24.
//  https://stackoverflow.com/questions/50231998/uicollectionview-scrolltoitem-to-center-cell-does-not-work-on-horizontal-collec

import UIKit

class CustomUICollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        minimumLineSpacing = 16
        minimumInteritemSpacing = 16
        itemSize = CGSize(width: 32, height: 32)
    }
    
    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        var offsetAdjustment = CGFloat.greatestFiniteMagnitude
        
        let horizontalOffset = proposedContentOffset.x + collectionView!.contentInset.left
        
        let targetRect = CGRect(x: proposedContentOffset.x,
                                y: 0,
                                width: collectionView!.bounds.size.width,
                                height: collectionView!.bounds.size.height)
        
        let layoutAttributesArray = collectionView!.collectionViewLayout.layoutAttributesForElements(in: targetRect)
        
        layoutAttributesArray?.forEach({ (layoutAttributes) in
            let itemOffset = layoutAttributes.frame.origin.x
            
            if fabsf(Float(itemOffset - horizontalOffset)) < fabsf(Float(offsetAdjustment)) {
                offsetAdjustment = itemOffset - horizontalOffset
            }
        })
        
        return CGPoint(x: proposedContentOffset.x + offsetAdjustment, y: proposedContentOffset.y)
    }
}
