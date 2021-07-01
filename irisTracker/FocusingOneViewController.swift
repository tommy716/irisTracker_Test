//
//  FocusingOneViewController.swift
//  irisTracker
//
//  Created by Tommy on 2021/07/01.
//

import UIKit

class FocusingOneViewController: UIViewController {
    
    // MARK: Variables
    var timer: Timer!
    var irisTracker: MPIrisTrackerH!
    var documentInteraction: UIDocumentInteractionController!
    var irisPosition: [[String]] = []
    var facePosition: [[String]] = []
    
    // MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        irisTracker = MPIrisTrackerH()
        irisTracker.delegate = self
        irisTracker.start()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func timerCounter() {
        self.performSegue(withIdentifier: "toDone", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDone" {
            let destination = segue.destination as! DoneViewController
            destination.facePosition = self.facePosition
            destination.irisPosition = self.irisPosition
        }
    }
}

// MARK: Iris Detector Delegate Method
extension FocusingOneViewController: MPTrackerDelegate {
    func faceMeshDidUpdate(_ tracker: MPIrisTrackerH!, didOutputLandmarks landmarks: [MPLandmark]!, timestamp: Int) {
        self.facePosition.append(Array(landmarks).map { "\($0.x),\($0.y),\($0.z)" })
    }
    
    func irisTrackingDidUpdate(_ tracker: MPIrisTrackerH!, didOutputLandmarks landmarks: [MPLandmark]!, timestamp: Int) {
        DispatchQueue.main.async {
            self.irisPosition.append(Array(landmarks).map { "\($0.x),\($0.y),\($0.z)" })
        }
    }
    
    func frameWillUpdate(_ tracker: MPIrisTrackerH!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!, timestamp: Int) {
        // Pixel Buffer is original image
    }
    
    func frameDidUpdate(_ tracker: MPIrisTrackerH!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!) {
        // Pixel Buffer is anotated image
    }
}
