//
//  ReadyLiveViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/10/18.
//

import UIKit
import AVFoundation
import MobileCoreServices

class ReadyLiveViewController: ViewController,UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var captureSession: UIImageView!
    
    let imagePicker: UIImagePickerController! = UIImagePickerController()
    var captureImage: UIImage!
    var videoURL: URL!
    var flagImageSave = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func startBtn(_ sender: Any) {
        if(UIImagePickerController.isSourceTypeAvailable(.camera)){
            flagImageSave = true
            imagePicker.delegate = self
            imagePicker.sourceType = .camera
            imagePicker.mediaTypes = [kUTTypeMovie as String]
            imagePicker.allowsEditing = false
            
            present(imagePicker, animated: true, completion: nil)
        }
        else{
            myAlert(title: "Camera inaccessable", Message: "Application cannot access the camera.")
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let mediaType = info[UIImagePickerController.InfoKey.mediaType] as! NSString //미디어 종류 확인
        if mediaType.isEqual(to: kUTTypeMovie as NSString as String){
            if flagImageSave{
                videoURL = (info[UIImagePickerController.InfoKey.mediaURL] as! URL) //비디오 가져옴
                UISaveVideoAtPathToSavedPhotosAlbum(videoURL.relativePath, self, nil, nil)
            }
            
            
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        self.dismiss(animated: true, completion: nil) //현재의 뷰(이미지 피커 제거)
    }
    
    func myAlert(title: String, Message: String){
        let Alert = UIAlertController(title: title, message: Message, preferredStyle: .alert)
        let Action = UIAlertAction(title: "Ok", style: UIAlertAction.Style.default)
        Alert.addAction(Action)
        self.present(Alert, animated: true, completion: nil)
    }
}
