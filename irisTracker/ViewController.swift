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
    @IBOutlet var leftEyeInfoLabel: UILabel!
    @IBOutlet var rightEyeInfoLabel: UILabel!
    
    // MARK: Variables
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
    
    @IBAction func exportIrisData() {
        createFile(fileArrData: irisPosition, isIris: true)
    }
    
    @IBAction func exportFaceData() {
        createFile(fileArrData: facePosition, isIris: false)
    }
}

// MARK: Iris Detector Delegate Method
extension ViewController: MPTrackerDelegate {
    func faceMeshDidUpdate(_ tracker: MPIrisTrackerH!, didOutputLandmarks landmarks: [MPLandmark]!, timestamp: Int) {
        DispatchQueue.main.async {
            self.leftEyeInfoLabel.text = "左目左端: (\(String(format: "%01.4f", landmarks[33].x)), \(String(format: "%01.4f", landmarks[33].y))), 左目右端: (\(String(format: "%01.4f", landmarks[133].x)), \(String(format: "%01.4f", landmarks[133].y)))"
            self.rightEyeInfoLabel.text = "右目左端: (\(String(format: "%01.4f", landmarks[398].x)), \(String(format: "%01.4f", landmarks[398].y))), 右目右端: (\(String(format: "%01.4f", landmarks[263].x)), \(String(format: "%01.4f", landmarks[263].y)))"
        }
        self.facePosition.append(Array(landmarks).map { "\($0.x),\($0.y),\($0.z)" })
    }
    
    func irisTrackingDidUpdate(_ tracker: MPIrisTrackerH!, didOutputLandmarks landmarks: [MPLandmark]!, timestamp: Int) {
        DispatchQueue.main.async {
            self.rightEyeLabel.text = "Right Eye: x=\(String(format: "%01.4f", landmarks[5].x)) y=\(String(format: "%01.4f", landmarks[5].y))"
            self.leftEyeLabel.text = "Left Eye: x=\(String(format: "%01.4f", landmarks[0].x)) y=\(String(format: "%01.4f", landmarks[0].y))"
            self.irisPosition.append(Array(landmarks).map { "\($0.x),\($0.y),\($0.z)" })
        }
    }
    
    func frameWillUpdate(_ tracker: MPIrisTrackerH!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!, timestamp: Int) {
        // Pixel Buffer is original image
    }
    
    func frameDidUpdate(_ tracker: MPIrisTrackerH!, didOutputPixelBuffer pixelBuffer: CVPixelBuffer!) {
        // Pixel Buffer is anotated image
        guard let image = UIImage(pixelBuffer: pixelBuffer) else { return }
        DispatchQueue.main.async {
            self.imageView.image = image
        }
    }
}

extension ViewController {
    func createFile(fileArrData : [[String]], isIris: Bool){
        var fileStrData:String = ""
        let fileName = isIris ? "iris_position.csv" : "face_position.csv"
        
        for i in 0..<fileArrData[0].count {
            if i == (fileArrData[0].count - 1) {
                fileStrData += "x\(i),y\(i),z\(i)\n"
            } else {
                fileStrData += "x\(i),y\(i),z\(i),"
            }
        }
        
        for singleArray in fileArrData{
            for i in 0..<singleArray.count {
                if i == (singleArray.count - 1) {
                    fileStrData += "\(singleArray[i])\n"
                } else {
                    fileStrData += "\(singleArray[i]),"
                }
            }
        }
        
        let documentDirectoryFileURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last!
        
        let FilePath = documentDirectoryFileURL.appendingPathComponent(fileName)
        
        do {
            try fileStrData.write(to: FilePath, atomically: true, encoding: String.Encoding.utf8)
        } catch let error as NSError {
            print("failed to write: \(error)")
        }
        
        documentInteraction = UIDocumentInteractionController()
        documentInteraction.url = FilePath
        
        if !(documentInteraction?.presentOpenInMenu(from:  CGRect(x: 0, y: 0, width: 10, height: 10), in: self.view, animated: true))! {
            let alert = UIAlertController(title: "Failed to send", message: "Cannot find available apps", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
}
