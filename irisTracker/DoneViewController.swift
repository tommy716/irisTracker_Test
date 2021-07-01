//
//  DoneViewController.swift
//  irisTracker
//
//  Created by Tommy on 2021/07/01.
//

import UIKit

class DoneViewController: UIViewController {
    
    var irisPosition: [[String]] = []
    var facePosition: [[String]] = []
    var documentInteraction: UIDocumentInteractionController!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func exportIrisData() {
        createFile(fileArrData: irisPosition, isIris: true)
    }
    
    @IBAction func exportFaceData() {
        createFile(fileArrData: facePosition, isIris: false)
    }

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
