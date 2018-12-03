//
//  AgogoModel.swift
//  Agogo Simulator
//
//  Created by Bernardo Duarte on 20/11/18.
//  Copyright © 2018 Bernardo Duarte. All rights reserved.
//

import UIKit
import AVFoundation

struct Agogo {
    var bells: [Bell]

    struct Bell {
        let type: BellType
        let polygon: Polygon
        var audioURL: URL?
        var audioPlayer: AVAudioPlayer?

        var audioFile: String {
            switch type {
            case .lower: return "a1"
            case .low: return "a2"
            case .high: return "a3"
            case .higher: return "a4"
            }
        }

        enum BellType {
            case lower
            case low
            case high
            case higher
        }

        struct Polygon {
            let points: [CGPoint]

            var bezierPath: UIBezierPath {
                guard points.count > 1 else { return UIBezierPath() }
                let p = UIBezierPath()
                let firstPoint = points[0]
                p.move(to: firstPoint)
                points.forEach { p.addLine(to: $0) }
                p.close()
                return p
            }
        }
    }
}
