//
//  PTSTimer.swift
//  Tempo
//
//  Created by Peter Simpson on 2/11/15.
//  Copyright (c) 2015 Pete Simpson. All rights reserved.
//

import Foundation
import UIKit

protocol CountdownTimerDelegate {
    func countdownEnded() -> Void
}

class CountdownTimer {
    
    
    let timerLabel: UILabel
    var timing: Bool = false
    var startingDay : Int
    var startingHour : Int
    var startingMin : Int
    var startingSec : Int
    
    
    var dayLeft : Int
    var hourLeft : Int
    var secLeft: Int
    var minLeft: Int
    
    var endTime: Int?
    var timer: Timer?
    var delegate: CountdownTimerDelegate!
    
    init(timerLabel: UILabel,startingDay:Int,startingHour:Int, startingMin: Int, startingSec: Int) {
        
        self.timerLabel = timerLabel
        self.startingDay = startingDay
        self.startingHour = startingHour
        self.startingMin = startingMin
        self.startingSec = startingSec
        
        self.dayLeft = startingDay
        self.hourLeft = startingHour
        self.minLeft = startingMin
        self.secLeft = startingSec
        refreshTimerLabel()
    }
    
    func refreshTimerLabel() {
        
        let endtime2 = endTime
        let timer2 = timer
        let dayString = dayLeft < 10 ? "0\(dayLeft)" : "\(dayLeft)"
        
        let hourString = hourLeft < 10 ? "0\(hourLeft)" : "\(hourLeft)"
        
        let minString = minLeft < 10 ? "0\(minLeft)" : "\(minLeft)"
        
        let secString = secLeft < 10 ? "0\(secLeft)" : "\(secLeft)"
        timerLabel.text = "\(dayString) 일 \(hourString):\(minString):\(secString)"
    }
    
    func start() {
        if (!timing) {
            timing = true
            
            if hourLeft == 0 && minLeft == 0 && secLeft == 0{
                dayLeft -= 1
                hourLeft = 23
                minLeft = 59
                secLeft = 59
            }
            if hourLeft == startingHour{
                if minLeft == 0{
                    hourLeft = startingHour - 1
                    minLeft = 59
                    secLeft = 59
                }
                else{
                    minLeft -= 1
                }
                refreshTimerLabel()
                
            }
            
            if minLeft == startingMin {
                if secLeft == 0 {
                    minLeft = startingMin - 1
                    secLeft = 59
                } else {
                    secLeft -= 1
                }
                
                refreshTimerLabel()
            }
            
            endTime = Int(round(NSDate().timeIntervalSince1970)) + dayLeft*3600*24 + hourLeft*60*60 + minLeft*60 + secLeft
            timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: "updateTimer", userInfo: nil, repeats: true)
        }
    }
    
    func pause() {
        timing = false
        timer?.invalidate()
    }
    
    func reset() {
        pause()
        dayLeft = startingDay
        hourLeft = startingHour
        minLeft = startingMin
        secLeft = startingSec
        refreshTimerLabel()
    }
    
    // MARK: - Timer Logic
    dynamic func updateTimer() {
        var timeDiff = endTime! - Int(round(NSDate().timeIntervalSince1970))
        hourLeft = timeDiff / (3600*startingDay)
        timeDiff = timeDiff % (3600)
        minLeft = timeDiff / 60
        // timeDiff = timeDiff / 60
        secLeft = timeDiff % 60
        if dayLeft <= 0 && hourLeft <= 0 && minLeft <= 0 && secLeft <= 0 {
            
            reset()
            delegate.countdownEnded()
            
            return
        }
        refreshTimerLabel()
    }
}
