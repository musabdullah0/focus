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
    public static var bgBlue: Color {
        return Color(NSColor(red: 20/255, green: 30/255, blue: 70/255, alpha: 1.0))
    }
    
    public static var darkRed: Color {
        return Color(NSColor(red: 199/255, green: 0/255, blue: 57/255, alpha: 1.0))
    }
    
    public static var lightRed: Color {
        return Color(NSColor(red: 255/255, green: 105/255, blue: 105/255, alpha: 1.0))
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
            Picker("", selection: $model.timerType) {
                ForEach(TimerType.allCases, id: \.self) { option in
                    Text(option.rawValue)
                }
            }
            .pickerStyle(SegmentedPickerStyle())
            .onChange(of: model.timerType, perform: { (value) in
                print("changed to \(value)")
                model.setTimerType(type: value)
            })

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
                        .foregroundColor(Color.beige)
                }
                .buttonStyle(.borderless)
                .offset(y: 35)
            }

            
            
//            Button(model.buttonText) {
//                if (model.state == "idle") {
//                    model.start()
//                } else {
//                    model.pause()
//                }
//            }
            
            
            
        }
        .padding()
        .frame(width: 300, height: 300)
        .background(Color.bgBlue)
    }
    
    
}

struct FilledButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration
            .label
            .foregroundColor(configuration.isPressed ? .gray : Color.bgBlue)
            .padding(.vertical, 10)
            .padding(.horizontal, 20)
            .background(Color.beige)
            .cornerRadius(10)
    }
}
    

struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView()
            .frame(width: 300, height: 300)
    }
}
