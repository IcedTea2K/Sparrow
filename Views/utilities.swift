//
//  utilities.swift
//  Sparrow
//
//  Created by Minh Au on 2024-02-23.
//

import Foundation
import SwiftUI
import Combine

extension Color {
    init(hex: String) {
        let scanner = Scanner(string: String(hex.dropFirst()))
        var res: UInt64 = 0
        
        scanner.currentIndex = scanner.string.startIndex
        scanner.scanHexInt64(&res)
        
        let red = Double((res & 0xFF0000) >> 16) / 255.0
        let green = Double((res & 0x00FF00) >> 8) / 255.0
        let blue = Double(res & 0x0000FF) / 255.0
        
        self.init(red: red, green: green, blue: blue)
    }
}

struct PersonPreferenceKey: PreferenceKey {
    static var defaultValue: CGPoint = .zero
    static func reduce(value: inout CGPoint, nextValue: () -> CGPoint) {
        value = nextValue()
    }
}

class Clock: ObservableObject {
    @Published private var _currTimeStr: String = "00 : 00"
    private var _currTime: Date = .now
    private var _startTime: Date = .now
    
    private var _clock = Timer.publish(every: 1, on: .main, in: .common)
    private var _clockDestroyer: AnyCancellable? = nil
    private var _status = false
    
    public func startClock() {
        resetTime()
        
        _status = true
        _startTime = .now
        
        _clockDestroyer = _clock
            .autoconnect()
            .sink(receiveValue: { time in
                self._currTime = time
                self._currTimeStr = self._getDurationSinceStart()
            })
    }
    
    public func stopClock() {
        _status = false
        _clockDestroyer?.cancel()
        _clockDestroyer = nil
    }
    
    public func getCurrTime() -> String{
        return _currTimeStr
    }
    
    public func isRunning() -> Bool {
        return _status
    }
    
    private func resetTime() {
        _currTimeStr = "00 : 00"
    }
    
    private func _getDurationSinceStart() -> String {
        let duration = Int(_currTime.timeIntervalSince(_startTime))
        let min      = duration / 60
        let sec      = duration % 60
        return String(format: "%02d : %02d", min, sec)
    }
}
