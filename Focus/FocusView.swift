//
//  ContentView.swift
//  Focus
//
//  Created by Musab Abdullah on 9/14/23.
//

import SwiftUI
import Cocoa
import AVFoundation


enum TimerType: String, CaseIterable {
    case pomodoro = "Pomodoro"
    case shortbreak = "Short Break"
    case longbreak = "Long Break"
}

/*
 there are 3 different session
 1. 25 min focus
 2.  5 min break
 3. 10 min break
 */
class PomodoroModel: ObservableObject {
    @Published var time = "25:00"
    @Published var state = "idle"
    @Published var buttonText = "start"
    private var audioPlayer: AVAudioPlayer?
    
    // 0=pomodoro, 1=short_break, 2=long_break
    @Published var timerType: TimerType = .pomodoro
    
    private var secondsLeft = 25*60
    private var timer: Timer?
    
    init() {
        self.time = "25:00"
        self.state = "idle"
        self.buttonText = "start"
        self.secondsLeft = 25*60
    }
    
    func updateTime() {
        self.time = self.timeText()
        AppDelegate.instance.statusBarItem.button?.title = self.timeText()
    }
    
    func start() {
        print("starting timer with \(self.secondsLeft) sec left")
        self.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { (Timer) in
            if self.secondsLeft > 0 {
                print("\(self.secondsLeft) sec left")
                self.secondsLeft -= 1
                self.updateTime()
            } else {
                self.playSound()
                Timer.invalidate()
            }
        }
        /*
         https://stackoverflow.com/questions/27997485/nstimer-not-firing-when-nsmenu-is-open-in-swift
         */
        RunLoop.main.add(self.timer!, forMode: .common)

        if self.timerType == .pomodoro {
            self.state = "focus"
        } else if self.timerType == .shortbreak {
            self.state = "break"
        } else if self.timerType == .longbreak {
            self.state = "chill"
        }
        
        self.buttonText = "pause"
    }
    
    func pause() {
        guard let timer = self.timer else {return}
        timer.invalidate()
        self.state = "idle"
        self.buttonText = "start"
    }
    
    func statusText() -> String {
        let messages = [
            "focus": "time to work 🤓",
            "idle": "lazy ahh boi 😡",
            "break": "chill time 😎",
            "chill": "touch some grass 🚶🏽‍♂️"
        ]
        if let status = messages[self.state] {
            return status
        }
        return "wyd 🤨"
    }
    
    func timeText() -> String {
        return String(format: "%d:%02d", secondsLeft / 60, secondsLeft % 60)
    }
    
    func setTimerType(type: TimerType) {
        if let timer = self.timer {
            timer.invalidate()
            self.state = "idle"
            self.buttonText = "start"
        }
        
        if type == .pomodoro {
            self.secondsLeft = 25*60
        } else if type == .shortbreak {
            self.secondsLeft = 5*60
        } else if type == .longbreak {
            self.secondsLeft = 10*60
        }
        self.updateTime()
    }
    
    func playSound() {
        guard let path = Bundle.main.path(forResource: "goofy", ofType:"mp3") else {
            return }
        let url = URL(fileURLWithPath: path)

        do {
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer?.play()
            
        } catch let error {
            print(error.localizedDescription)
        }
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
            Text(model.time)
                .font(.system(.largeTitle, design: .rounded))
                .fontWeight(.black)
            Text(model.statusText())
                .font(.system(.title3, design: .rounded))
            
            Button{
                print("clicked: \(model.buttonText)")
                
                if (model.state == "idle") {
                    model.start()
                } else {
                    model.pause()
                }
            } label: {
                Text(model.buttonText)
                    .font(.system(.title3, design: .rounded))
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
            
        }
        .padding()
        .frame(width: 300, height: 150)
        .background(Color.indigo)
    }
    
    
}
    

struct FocusView_Previews: PreviewProvider {
    static var previews: some View {
        FocusView()
    }
}
