//
//  PictureViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/12/04.
//

import UIKit
import Firebase
import FirebaseAuth

class PictureViewController: ViewController{

    @IBOutlet weak var introduceLabel: UILabel!
    @IBOutlet weak var centerImage: UIImageView!
    let imagePickerController = UIImagePickerController()
    var ref : DatabaseReference! = Database.database().reference()
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    @IBAction func uploadButton(_ sender: Any) {
        if centerImage.image != nil{
            UserModel.shared.myInfo.picture += 1
            self.ref.child("picture_count").child(UserModel.shared.myInfo.uid).setValue(UserModel.shared.myInfo.picture)
            self.navigationController?.popViewController(animated: true)
        }
        else{
            showToast(message: "아무런 사진도 선택되지 않았습니다.")
        }
    }
    @IBAction func clickCamera(_ sender: Any) {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .camera
        //animated true : 아래에서 올라오는 애니메이션
        //false : 바로 화면이 나옴
        present(self.imagePickerController, animated: true, completion: nil)
        
        introduceLabel.isHidden = true // hide
    }
    @IBAction func clickGallery(_ sender: Any) {
        self.imagePickerController.delegate = self
        self.imagePickerController.sourceType = .photoLibrary
        present(self.imagePickerController, animated: true, completion: nil)
        
        introduceLabel.isHidden = true // hide
    }
    
    @IBAction func returnMain(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }

}
extension PictureViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            centerImage.image = image
            
        }
        picker.dismiss(animated: true, completion: nil)//dismiss를 직접 해야함
        
    }
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
