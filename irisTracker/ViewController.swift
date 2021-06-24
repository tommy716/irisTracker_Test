//
//  ViewController.swift
//  irisTracker
//
//  Created by Tommy on 2021/06/24.
//

import UIKit

class ViewController: UIViewController {
    
    // MARK: IBOutlet
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var rightEyeLabel: UILabel!
    @IBOutlet var leftEyeLabel: UILabel!
    
    // MARK: Variables
    var irisTracker: MPIrisTracker!
    
    // MARK: Life cycles
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        irisTracker = MPIrisTracker()
        irisTracker.delegate = self
        irisTracker.start()
    }
}

// MARK: Iris Detector Delegate Method
extension ViewController: MPTrackerDelegate {
    func faceMeshDidUpdate(_ tracker: MPIrisTracker!, didOutputLandmarks landmarks: [MPLandmark]!, timestamp: Int) {
        // print(landmarks.count)
    }
    
    func irisTrackingDidUpdate(_ tracker: MPIrisTracker!, didOutputLandmarks landmarks: [MPLandmark]!, timestamp: Int) {
        DispatchQueue.main.async {
            self.rightEyeLabel.text = "Right Eye: x=\(String(format: "%01.4f", landmarks[0].x)) y=\(String(format: "%01.4f", landmarks[0].y))"
            self.leftEyeLabel.text = "Left Eye: x=\(String(format: "%01.4f", landmarks[5].x)) y=\(String(format: "%01.4f", landmarks[5].y))"
        }
    }
    
    func frameWillUpdate(_ tracker: MPIrisTracker!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!, timestamp: Int) {
        // Pixel Buffer is original image
    }
    
    func frameDidUpdate(_ tracker: MPIrisTracker!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!) {
        // Pixel Buffer is anotated image
        guard let image = UIImage(pixelBuffer: pixelBuffer) else { return }
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}
