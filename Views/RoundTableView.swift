//
//  RoundTableView.swift
//
//
//  Created by Minh Au on 2024-02-22.
//

import Foundation
import SwiftUI
import Combine

struct RoundTableView: View {
    var body: some View {
        let stopWatch = StopWatch()
//        let _ = stopWatch.startClock()
        VStack {
                stopWatch
                    .offset(x: 0, y: -150)
            Table()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#e9edc9"))
    }
}

struct Table: View {
    @State
    private var _people: [Person] = []
    
    private let colors: [String] = [
        "#D1C6DF", "#B2A8D5", "#FADBC7", "#475164", "#FFA7A7",
        "#F8E5B3", "#9AD4C5", "#EEA9A2", "#A5ADBB", "#EBEFF2",
        "#F4C29E", "#BFB4C4", "#FFB08E", "#6AB1E3", "#F9CF8D",
        "#A8DEC9", "#E7B3A0", "#7E5C8F", "#FAD685", "#B3E1C2",
        "#D9CCEA", "#F7C67A", "#AEC8EF", "#F9E2D2", "#B9BBC2",
        "#D7C9E5", "#FFAB90", "#B3E1C2", "#E5D6ED", "#FAD9A9"
    ]
    
    var body: some View {
        let diameter: CGFloat = 250
        let radius: CGFloat = diameter / 2
        let space = 2 * CGFloat.pi / CGFloat(_people.count)
        let randStart = CGFloat.random(in: 0 ... 2 * CGFloat.pi)
        
        ZStack {
            Circle()
                .fill(Color(hex: "#ccd5ae"))
                .frame(width: diameter, height: diameter)
                .onTapGesture {
                    let newPerson = Person(name: "rey", size: 30, color: colors.randomElement())
                    _people.append(newPerson)
                }
            
            ForEach(Array(_people.enumerated()), id: \.offset) { i, person in
                let offSet = radius + person.size / 2
                let angle  = randStart + space * CGFloat(i)
                let xCoord = offSet * cos(angle)
                let yCoord = offSet * sin(angle)
                ZStack {
                    person
                        .offset(x: xCoord, y: yCoord)
                        .overlay(
                            GeometryReader { geom in
                                Color
                                    .clear
                                    .preference(key: PersonPreferenceKey.self, value: geom.frame(in: .global).origin)
                            }
                                .offset(x: xCoord, y: yCoord)
                        )
                }
                .onPreferenceChange(PersonPreferenceKey.self) { point in
                    person.setCoord(coord: point)
                }
                
            }
        }
    }
    
}

struct Person: View {
    @State
    private var _coord: CGPoint?
    var name: String
    var size: CGFloat // circle radius for now
    var color: String? // hex string
        
    init(name: String, size: CGFloat, color: String? = nil) {
        self.name = name
        self.size = size
        self.color = color
    }
    
    var body: some View {
        Circle()
            .fill(Color(hex: color!))
            .frame(width: size, height: size)
    }
    
    func setCoord(coord: CGPoint) {
        self._coord = coord
    }
    
    func getCoordinates() -> CGPoint {
        return _coord ?? .zero
    }
}

struct StopWatch: View {
    @State private var _currTimeStr: String = "00 : 00"
    @State private var _currTime: Date = Date.now
    private var _timer: Publishers.Autoconnect<Timer.TimerPublisher>? = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    private let _dateFormater: DateFormatter = DateFormatter()
    @State private var _status = false
    @State private var _startTime: Date = .now
    
    init() {
        _dateFormater.dateFormat = "mm : ss"
    }
    
    var body: some View {
        if _timer != nil {
            Text(_currTimeStr)
                .font(.largeTitle)
                .onReceive(_timer!, perform: { newTime in
                    _currTime = newTime
//                    _currTimeStr = _dateFormater.string(from: _currTime)
                    let duration = Int(_currTime.timeIntervalSince(_startTime))
                    let sec = duration % 60
                    let min = duration / 60
                    _currTimeStr = String(format: "%02d : %02d", min, sec)
                })
        } else {
            Text(_currTimeStr)
                .font(.largeTitle)
        }
            
    }
    
    func startClock() {
        _status = true
        _startTime = _currTime
    }
    
    func stopClock() {
        _status = false
    }
    
    func calculateDuration(time: Date) {
        
    }
    
    func isRunning() -> Bool {
        return _status
    }
}

#Preview {
    RoundTableView()
}
