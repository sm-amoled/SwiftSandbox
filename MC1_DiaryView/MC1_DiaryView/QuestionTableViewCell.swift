//
//  QuestionTableViewCell.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/20.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionButton: UIButton!
    
//    var indexNo: Int
    
    
    @IBAction func tapQuestionButton(_ sender: Any) {
        isSelected = isSelected ? false : true
        setStyle()
    }
    
    func setStyle() {
        if isSelected {
            questionButton.backgroundColor = .gray
        } else {
            questionButton.backgroundColor = .white
        }
    }
}
