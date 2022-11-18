//
//  ContentView.swift
//  ChartsPlayground
//
//  Created by Park Sungmin on 2022/11/18.
//

import SwiftUI
import Charts

struct Question: Identifiable {
    
    let weekday: String
    let count: Int
    
    var id: String { weekday }
}

let myQuestions: [Question] = [
    .init(weekday: "SUN", count: 123),
    .init(weekday: "MON", count: 234),
    .init(weekday: "TUE", count: 345),
    .init(weekday: "WED", count: 456),
    .init(weekday: "THU", count: 247),
    .init(weekday: "FRI", count: 543),
    .init(weekday: "SAT", count: 163),
]

let yourQuestions: [Question] = [
    .init(weekday: "SUN", count: 432),
    .init(weekday: "MON", count: 466),
    .init(weekday: "TUE", count: 732),
    .init(weekday: "WED", count: 126),
    .init(weekday: "THU", count: 442),
    .init(weekday: "FRI", count: 247),
    .init(weekday: "SAT", count: 111),
]

struct QuestionCount: Identifiable {
    var id: String {
        name
    }
    
    let name: String
    let questions: [Question]
}

let questionSeries: [QuestionCount] = [
    .init(name: "I", questions: myQuestions),
    .init(name: "You", questions: yourQuestions)
]

struct ContentView: View {
    @State var person: Bool = true
    
    var data: [Question] {
        if person {
            return myQuestions
        } else {
            return yourQuestions
        }
    }
    
    var body: some View {
//        VStack{
//            Picker("who's question?", selection: $person.animation(.easeInOut)) {
//                Text("Me").tag(true)
//                Text("You").tag(false)
//            }
//            .pickerStyle(.segmented)
//
//            Chart {
//                ForEach(data) { q in
//                    BarMark(x: .value("level", q.weekday),
//                            y: .value("count", q.count))
//                }
//            }
//            Spacer()
//        }
        
        VStack {
            Chart(questionSeries) { series in
                ForEach(series.questions) { question in
                    BarMark(x: .value("name", question.weekday),
                            y: .value("count", question.count))
                    .foregroundStyle(by: .value("name", series.name))
//                    .symbol(by: .value("name", series.name))
                    
//                    PointMark(x: .value("name", question.weekday),
//                            y: .value("count", question.count))
//                    .foregroundStyle(by: .value("name", series.name))
//                    .symbol(by: .value("name", series.name))
                }
            }
            .frame(height: 300)
            .chartYScale(domain: 0...1000)
            .chartForegroundStyleScale([
                "I": .orange,
                "You": .yellow,
            ])
            Spacer()
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
