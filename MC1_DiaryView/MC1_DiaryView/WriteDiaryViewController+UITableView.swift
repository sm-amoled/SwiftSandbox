//
//  WriteDiaryViewController+UITableView.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/22.
//

import Foundation
import UIKit

extension WriteDiaryViewController: UITableViewDelegate {
    
}

extension WriteDiaryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: QuestionLabelCell = questionLabelTableView.dequeueReusableCell(withIdentifier: "QuestionLabelCell", for: indexPath) as? QuestionLabelCell else {
            return UITableViewCell()
        }
        
        cell.questionLabel.text = questionList[indexPath.row].question
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(cellHeight)
    }
}
