//
//  QuestionTableViewCell.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/20.
//

import UIKit

class QuestionTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionButton: UIButton!
    
    var delegate: SelectQuestionDelegate?
    var rowNo: Int?
    
    
    @IBAction func tapQuestionButton(_ sender: Any) {
        if let rowNo = rowNo {
            delegate?.tapQuestionCell(rowNo: rowNo)
        }
        
        isSelected = isSelected ? false : true
        setStyle()
    }
    
    func setStyle() {
        if isSelected {
            questionButton.backgroundColor = .systemBlue
        } else {
            questionButton.backgroundColor = .white
        }
    }
}
