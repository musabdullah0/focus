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
    let lineColor: Color = Color.tangerine
    
    var body: some View {
        ZStack {
            Circle()
                .stroke(
                    lineColor.opacity(0.5),
                    lineWidth: lineWidth
                )
            Circle()
                .trim(from: 0.0, to: CGFloat(min(progress, 1.0)))
                .stroke(
                    lineColor,
                    style: StrokeStyle(
                        lineWidth: lineWidth,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.linear(duration: 0.1), value: progress)
            
            Text(timeText)
                .font(.system(.largeTitle, design: .rounded))
                .foregroundColor(Color.beige.opacity(0.8))
                .offset(y: -15)

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
