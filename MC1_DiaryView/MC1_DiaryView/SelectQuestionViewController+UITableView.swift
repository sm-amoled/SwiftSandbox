//
//  SelectQuestionViewController+UITableView.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/21.
//

import Foundation
import UIKit

protocol SelectQuestionDelegate {
    func tapQuestionCell(rowNo: Int)
}

extension SelectQuestionViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedQuestionList[indexPath.row] = true
        tableView.cellForRow(at: indexPath)!.backgroundColor = selectedQuestionList[indexPath.row] ? .blue : .white
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        selectedQuestionList[indexPath.row] = false
        tableView.cellForRow(at: indexPath)!.backgroundColor = selectedQuestionList[indexPath.row] ? .blue : .white
    }
}

extension SelectQuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questionList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: QuestionTableViewCell = questionTableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell else {
            return UITableViewCell()
        }

        cell.delegate = self

        cell.questionButton.setTitle(questionList[indexPath.row].question, for: .normal)
        cell.questionButton.titleLabel?.textAlignment = .center
        cell.rowNo = indexPath.row
        
        return cell
    }
}

extension SelectQuestionViewController: SelectQuestionDelegate {
    func tapQuestionCell(rowNo: Int) {
        selectedQuestionList[rowNo].toggle()
    }
}
