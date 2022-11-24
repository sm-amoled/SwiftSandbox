//
//  FirstView.swift
//  SwiftUItoUIKit
//
//  Created by Park Sungmin on 2022/11/18.
//

import SwiftUI

struct FirstView: View {
    var body: some View {
        VStack{
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
                .font(.system(.title))
            Text("This is SwiftUI View")
                .font(.system(.body))
        }
    }
}

struct FirstView_Previews: PreviewProvider {
    static var previews: some View {
        FirstView()
    }
}
