//
//  QuestionModel.swift
//  MC1_DiaryView
//
//  Created by Park Sungmin on 2022/09/21.
//

import Foundation

struct QuestionModel {
    var question: String
    var emotion: Int // Enum 타입으로 변경?
}

extension QuestionModel {
    static let dummyQuestion: [QuestionModel] = [
        QuestionModel(question: "오늘의 기분을 몇 점으로 표현할 수 있을까요?", emotion: 0),
        QuestionModel(question: "왜 기분이 좋았어요?", emotion: 0),
        QuestionModel(question: "왜 그런 기분이 들었나요?", emotion: 0),
        QuestionModel(question: "왜 기분이 좋았어요?", emotion: 0),
        QuestionModel(question: "왜 기분이 좋았어요?", emotion: 0),
    ]
}
