//
//  CMTime.swift
//  PodcastApp
//
//  Created by Mohammad Farhoudi on 09/03/2018.
//  Copyright © 2018 Mohammad Farhoudi. All rights reserved.
//

import AVKit

extension CMTime {
    
    func toProgressTime() -> String {
    
        if CMTimeGetSeconds(self).isNaN {
            return "--:--"

        }
    
    let trackingTimeSeconds = Int(CMTimeGetSeconds(self))
    let trackingSeconds = trackingTimeSeconds % 60
    let trackingMinutes =  trackingTimeSeconds / 60
    let trackingHours =  trackingTimeSeconds / 3600
    let startTime = String(format: "%02d:%02d:%02d", trackingHours, trackingMinutes, trackingSeconds)
    return startTime
    
    }
    
}
