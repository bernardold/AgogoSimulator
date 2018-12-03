//
//  AgogoViewController.swift
//  Agogo Simulator
//
//  Created by Bernardo Duarte on 06/10/18.
//  Copyright © 2018 Bernardo Duarte. All rights reserved.
//

import UIKit
import AVFoundation

class AgogoViewController: UIViewController {
    var agogo: Agogo!

    @IBOutlet private var agogoView: UIView!
    @IBOutlet private var agogoImageView: UIImageView!

    override var prefersStatusBarHidden: Bool {
        return false
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)



        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(imageTapped))
        agogoImageView.isUserInteractionEnabled = true
        agogoImageView.addGestureRecognizer(gestureRecognizer)
    }

    // MARK: - Event Handling

    @objc func imageTapped(tapGestureRecognizer: UITapGestureRecognizer) {
        let pointTouched = tapGestureRecognizer.location(in: agogoView)
        handleTap(at: pointTouched)
    }

}

// MARK: - Helper

extension AgogoViewController {
    private func handleTap(at point: CGPoint) {
        let bell = agogo.bells.first { $0.polygon.bezierPath.contains(point) }
        guard let tappedBell = bell else { return }
        playSound(forBell: tappedBell)
    }

    private func playSound(forBell bell: Agogo.Bell) {
        guard let player = bell.audioPlayer else { return }

        try? AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
        player.currentTime = 0.1

        guard !player.isPlaying else { return }
        player.play()
    }
}

// MARK: - View Setup

extension AgogoViewController {
    fileprivate func setupView() {
        agogo = Agogo.init(bells: [Agogo.Bell(type: .lower, polygon: Agogo.Bell.Polygon(points: bell1Points()), audioURL: nil, audioPlayer: nil),
                                   Agogo.Bell(type: .low, polygon: Agogo.Bell.Polygon(points: bell2Points()), audioURL: nil, audioPlayer: nil),
                                   Agogo.Bell(type: .high, polygon: Agogo.Bell.Polygon(points: bell3Points()), audioURL: nil, audioPlayer: nil),
                                   Agogo.Bell(type: .higher, polygon: Agogo.Bell.Polygon(points: bell4Points()), audioURL: nil, audioPlayer: nil)])

        for index in 0..<agogo.bells.count {
            guard let url = Bundle.main.url(forResource: agogo.bells[index].audioFile, withExtension: "wav") else { return }
            agogo.bells[index].audioURL = url
            do {
                try agogo.bells[index].audioPlayer = AVAudioPlayer(contentsOf: url)
            } catch {
                print("problem loading sound \(index)")
            }
        }
    }

    fileprivate func bell1Points() -> [CGPoint] {
        // Coordinates: (0, 260), (460, 0), (830, 980), (0, 390)
        return screenPointsFromImage(coordinates: [CGPoint(x: 0, y: 260),
                                                   CGPoint(x: 460, y: 0),
                                                   CGPoint(x: 830, y: 980),
                                                   CGPoint(x: 0, y: 390)])
    }

    fileprivate func bell2Points() -> [CGPoint] {
        // Coordinates: (545, 0), (1060, 0), (1060, 170), (850, 830), (545, 202),
        return screenPointsFromImage(coordinates: [CGPoint(x: 545, y: 0),
                                                   CGPoint(x: 1060, y: 0),
                                                   CGPoint(x: 1060, y: 170),
                                                   CGPoint(x: 850, y: 830),
                                                   CGPoint(x: 545, y: 202)])
    }

    fileprivate func bell3Points() -> [CGPoint] {
        // Coordinates: (1150, 25), (1600, 260), (1515, 360), (920, 730)
        return screenPointsFromImage(coordinates: [CGPoint(x: 1150, y: 25),
                                                   CGPoint(x: 1600, y: 260),
                                                   CGPoint(x: 1515, y: 360),
                                                   CGPoint(x: 920, y: 730)])
    }

    fileprivate func bell4Points() -> [CGPoint] {
        // Coordinates: (1120, 615), (1640, 280), (1760, 540), (1760, 700), (1120, 700)
        return screenPointsFromImage(coordinates: [CGPoint(x: 1120, y: 615),
                                                   CGPoint(x: 1640, y: 280),
                                                   CGPoint(x: 1760, y: 540),
                                                   CGPoint(x: 1760, y: 700),
                                                   CGPoint(x: 1120, y: 700)])
    }

    fileprivate func screenPointsFromImage(coordinates: [CGPoint]) -> [CGPoint] {
        guard let originalSize = agogoImageView.image?.size else { return [] }
        let reference = agogoImageView.imageActualRect

        var points = [CGPoint]()

        coordinates.forEach { coordinate in
            let point = CGPoint(x: reference.origin.x + ((coordinate.x * reference.width) / originalSize.width),
                                y: reference.origin.y + ((coordinate.y * reference.height) / originalSize.height))
            points.append(point)
        }
        return points
    }
}
