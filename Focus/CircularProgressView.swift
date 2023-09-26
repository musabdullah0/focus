//
//  CircularProgressView.swift
//  Focus
//
//  Created by Musab Abdullah on 9/24/23.
//

import SwiftUI

struct CircularProgressView: View {
    var progress: Float
    var timeText: String
    let lineWidth = CGFloat(8)
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
//                    Color.pink.opacity(0.5),
                    Color.darkRed.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
//                    Color.pink,
                    Color.darkRed,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 1.0), value: progress)
            
            Text(timeText)
                .font(.system(.title, design: .rounded))

        }
        .frame(width: 120, height: 120)
        
    }
}

struct CircularProgressView_Previews: PreviewProvider {
    static var previews: some View {
        CircularProgressView(progress: 0.25, timeText: "25:00")
            .frame(width: 200, height: 200)
    }
}
