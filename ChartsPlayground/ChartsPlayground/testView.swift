
import SwiftUI


struct ContentView: View {
    let chartData = ChartDataModel.init(dataModel: sample)
    
    var body: some View {
        ScrollView {
            VStack {
                HStack(spacing: 20) {
                    PieChart(dataSource: chartData)
                    .frame(width: 150, height: 150, alignment: .center)
                    .padding()
                }
            }
        }
    }
}


struct PieChartCell: Shape {
    let startAngle: Angle
    let endAngle: Angle
    
    func path(in rect: CGRect) -> Path {
        // 중심점을 기준으로, 반지름만큼의 원을, startAngle -> endAngle로 시계방향으로 그리기
        let center = CGPoint.init(x: (rect.origin.x + rect.width)/2,
                                  y: (rect.origin.y + rect.height)/2)
        let radii = min(center.x, center.y)
        let path = Path { p in
            p.addArc(center: center,
                     radius: radii,
                     startAngle: startAngle,
                     endAngle: endAngle,
                     clockwise: true)
            p.addLine(to: center)
        }
        
        return path
    }
}

struct PieChart: View {
    @State private var selectedCell: UUID = UUID()
    
    let dataSource: ChartDataModel
    var body: some View {
        ZStack {
            ForEach(dataSource.chartCellModel) { solvedProblemOfLevel in
                PieChartCell(startAngle: self.dataSource.angle(for: solvedProblemOfLevel.numOfSolvedProblems),
                             endAngle: self.dataSource.startingAngle)
                    .foregroundColor(solvedProblemOfLevel.color)
            }
        }
    }
}


struct ChartCellModel: Identifiable {
    let id = UUID()
    let color: Color
    
    let numOfSolvedProblems: CGFloat
    let level: String
}

final class ChartDataModel: ObservableObject {
    var chartCellModel: [ChartCellModel]
    var startingAngle = Angle(degrees: 0)
    private var lastBarEndAngle = Angle(degrees: 0)
    
    
    init(dataModel: [ChartCellModel]) {
        chartCellModel = dataModel
    }
    
    var totalNumberOfSolvedProblems: CGFloat {
        chartCellModel.reduce(CGFloat(0)) { (result, data) -> CGFloat in
            result + data.numOfSolvedProblems
        }
    }
    
    func angle(for value: CGFloat) -> Angle {
        if startingAngle != lastBarEndAngle {
            startingAngle = lastBarEndAngle
        }
        lastBarEndAngle += Angle(degrees: Double(value / totalNumberOfSolvedProblems) * 360 )
        print(lastBarEndAngle.degrees)
        return lastBarEndAngle
    }
}

let sample = [ ChartCellModel(color: Color.red, numOfSolvedProblems: 11, level: "Javascript"),
               ChartCellModel(color: Color.yellow, numOfSolvedProblems: 10, level: "Swift"),
               ChartCellModel(color: Color.gray, numOfSolvedProblems: 24, level: "Python"),
               ChartCellModel(color: Color.blue, numOfSolvedProblems: 31, level: "Java"),
               ChartCellModel(color: Color.green, numOfSolvedProblems: 12, level: "PHP")]

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
