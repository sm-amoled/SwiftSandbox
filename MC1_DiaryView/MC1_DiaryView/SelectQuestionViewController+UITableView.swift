//
//  SelectQuestionViewController+UITableView.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/21.
//

import Foundation
import UIKit

extension SelectQuestionViewController: UITableViewDelegate {
    

}

extension SelectQuestionViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return QuestionModel.dummyQuestion.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell: QuestionTableViewCell = questionTableView.dequeueReusableCell(withIdentifier: "QuestionTableViewCell", for: indexPath) as? QuestionTableViewCell else {
            return UITableViewCell()
        }
        
//        cell.indexNo = indexPath.row
        cell.questionButton.setTitle(QuestionModel.dummyQuestion[indexPath.row].question, for: .normal)
    
        return cell
    }
}
