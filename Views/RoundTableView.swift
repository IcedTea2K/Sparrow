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
        let clock = Clock()
        VStack {
            StopWatch()
                .offset(x: 0, y: -120)
                .environmentObject(clock)
            Table()
                .environmentObject(clock)
            ToggleDiscussButton()
                .offset(x: 0, y: 100)
                .environmentObject(clock)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(hex: "#e9edc9"))
    }
}

struct Table: View {
    @State
    private var _people: [Person] = []
    private let randStart = CGFloat.random(in: 0 ... 2 * CGFloat.pi)
    
    private let _colors: [String] = [
        "#D1C6DF", "#B2A8D5", "#FADBC7", "#475164", "#FFA7A7",
        "#F8E5B3", "#9AD4C5", "#EEA9A2", "#A5ADBB", "#EBEFF2",
        "#F4C29E", "#BFB4C4", "#FFB08E", "#6AB1E3", "#F9CF8D",
        "#A8DEC9", "#E7B3A0", "#7E5C8F", "#FAD685", "#B3E1C2",
        "#D9CCEA", "#F7C67A", "#AEC8EF", "#F9E2D2", "#B9BBC2",
        "#D7C9E5", "#FFAB90", "#B3E1C2", "#E5D6ED", "#FAD9A9"
    ]
    
    @EnvironmentObject
    private var _clock: Clock
    
    var body: some View {
        let diameter: CGFloat = 250
        let radius: CGFloat = diameter / 2
        let space = 2 * CGFloat.pi / CGFloat(_people.count)
        
        ZStack {
            Circle()
                .fill(Color(hex: "#ccd5ae"))
                .frame(width: diameter, height: diameter)
                .onTapGesture {
                    let newPerson = Person(name: "rey", size: 30, color: _colors.randomElement())
                    _people.append(newPerson)
//                    if !_clock.isRunng() {
//                        _clock.startClock()
//                    } else {
//                        _clock.stopClock()
//                    }
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
    @EnvironmentObject var clock: Clock
    
    var body: some View {
        Text(clock.getCurrTime())
            .font(.largeTitle)
            .foregroundStyle(Color(hex: "#8f8b8b"))
    }
}

struct ToggleDiscussButton: View {
    @State private var _isDiscussing: Bool = false
    @EnvironmentObject private var _clock: Clock
    
    var body: some View {
        _isDiscussing ?
        _CustomButton(label: "Discussing...", action: _handleStopDiscussing,
                      textColor: "#ffffff", bgColor: "#D1BF90") :
        _CustomButton(label: "Start", action: _handleStartDiscussing,
                      textColor: "#ffffff", bgColor: "#B6A780")
    }
    
    private func _handleStopDiscussing() {
        if (!_clock.isRunning()) {
            return
        }
        
        _isDiscussing = false
        _clock.stopClock()
    }
    
    private func _handleStartDiscussing() {
        if (_clock.isRunning()) {
            return
        }
        
        _isDiscussing = true
        _clock.startClock()
    }
    
    private struct _CustomButton: View {
        var label: String
        var action: () -> Void
        var textColor: String // hex string
        var bgColor: String // hex string
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 13)
                    .fill(Color(hex: bgColor))
                    .frame(width: 150, height: 50)
                Text(label)
                    .foregroundStyle(Color(hex: textColor))
                
            }
            .onTapGesture {
                action()
            }
        }
    }
    
}

#Preview {
    RoundTableView()
}
