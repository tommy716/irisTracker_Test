//
//  LookingScreenViewController.swift
//  irisTracker
//
//  Created by Tommy on 2021/07/01.
//

import UIKit

class LookingScreenViewController: UIViewController {
    
    // MARK: Variables
    var timer: Timer!
    var timer2: Timer!
    var irisTracker: MPIrisTrackerH!
    var documentInteraction: UIDocumentInteractionController!
    var irisPosition: [[String]] = []
    var facePosition: [[String]] = []
    
    @IBOutlet var redCircleView: UIView!
    let screenSize = UIScreen.main.bounds.size
    var topBarHeight: CGFloat {
        return (view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0.0) +
            (self.navigationController?.navigationBar.frame.height ?? 0.0)
    }
    
    var speedX: CGFloat = 15.0
    var speedY: CGFloat = 10.0
    
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
        speedX = CGFloat.random(in: 5...15)
        speedY = CGFloat.random(in: 5...15)
        startTimer()
    }
    
    func startTimer() {
        timer = Timer.scheduledTimer(
            timeInterval: 10,
            target: self,
            selector: #selector(self.timerCounter),
            userInfo: nil,
            repeats: true)
        
        timer2 = Timer.scheduledTimer(
            timeInterval: 0.01,
            target: self,
            selector: #selector(self.moveBall),
            userInfo: nil,
            repeats: true)
    }
    
    @objc func timerCounter() {
        self.performSegue(withIdentifier: "toDone", sender: self)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
        timer2.invalidate()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDone" {
            let destination = segue.destination as! DoneViewController
            destination.facePosition = self.facePosition
            destination.irisPosition = self.irisPosition
        }
    }
    
    @objc func moveBall() {
        redCircleView.center.x += speedX
        redCircleView.center.y -= speedY
        
        if redCircleView.center.x >= screenSize.width - (redCircleView.frame.width / 2) {
            speedX = -CGFloat.random(in: 5...15)
        }
        if redCircleView.center.y >= screenSize.height - (redCircleView.frame.height / 2) {
            speedY = CGFloat.random(in: 5...15)
        }
        if redCircleView.center.x <= (redCircleView.frame.height / 2) {
            speedX = CGFloat.random(in: 5...15)
        }
        if redCircleView.center.y <= topBarHeight + (redCircleView.frame.height / 2) {
            speedY = -CGFloat.random(in: 5...15)
        }
    }
}

// MARK: Iris Detector Delegate Method
extension LookingScreenViewController: MPTrackerDelegate {
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
