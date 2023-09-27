//
//  ContentView.swift
//  Focus
//
//  Created by Musab Abdullah on 9/14/23.
//

import SwiftUI
import AppKit
import Cocoa

extension Color {
    public static var darkBG: Color {
        return Color(NSColor(red: 37/255, green: 36/255, blue: 34/255, alpha: 1.0))
    }
    
    public static var darkRed: Color {
        return Color(NSColor(red: 199/255, green: 0/255, blue: 57/255, alpha: 1.0))
    }
    
    public static var tangerine: Color {
        return Color(NSColor(red: 235/255, green: 94/255, blue: 40/255, alpha: 1.0))
    }
    
    public static var beige: Color {
        return Color(NSColor(red: 255/255, green: 245/255, blue: 224/255, alpha: 1.0))
    }
}
extension View {
    func border(_ color: Color, width: CGFloat, cornerRadius: CGFloat) -> some View {
        overlay(RoundedRectangle(cornerRadius: cornerRadius).stroke(color, lineWidth: width))
    }
}

struct FocusView: View {
    @StateObject var model = PomodoroModel()
    
    var body: some View {
        VStack {
            CustomSegmentedPicker(TimerType.allCases, selectedItem: $model.timerType, onClick: { type in
                print("clicked \(type)")
                model.setTimerType(type: type)
            }) { timerType in
                Text(timerType.rawValue)
                    .foregroundColor(model.timerType == timerType ? .darkBG : .beige)
                    .padding(.vertical, 10)
                    .padding(.horizontal, 15)
                    .font(.body)
            }

            ZStack {
                CircularProgressView(progress: model.progress, timeText: model.time)
                
                Button {
                    if (model.state == "idle") {
                        model.start()
                    } else {
                        model.pause()
                    }
                } label: {
                    Image(systemName: model.state == "idle" ? "play.circle" : "pause.circle")
                        .resizable()
                        .frame(width: 30, height: 30)
                        .foregroundColor(Color.beige.opacity(0.7))
                }
                .buttonStyle(.borderless)
                .offset(y: 23)
            }
            .padding()
            
        }
        .padding()
//        .frame(width: 350, height: 220)
        .background(Color.darkBG)
    }
    
    
}
    

struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView()
//            .frame(width: 300, height: 300)
    }
}
