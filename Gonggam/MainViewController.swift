//
//  MainViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/23.
//

import UIKit
import Firebase
import FirebaseAuth

class MainViewController: ViewController {
    @IBOutlet weak var TimerView: UIView!
    @IBOutlet weak var timerText: UILabel!
    @IBOutlet weak var pictuerbtnView: UIView!
    @IBOutlet weak var picturebtn: UIButton!
    @IBOutlet weak var stopwartchbtnView: UIView!
    @IBOutlet weak var stopwartchbtn: UIButton!
    @IBOutlet weak var personbtnView: UIView!
    @IBOutlet weak var personbtn: UIButton!
    
    var count = 0
    var timer = Timer()
    var ref : DatabaseReference! = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        TimerView.layer.cornerRadius = 10
        pictuerbtnView.layer.cornerRadius = 10
        stopwartchbtnView.layer.cornerRadius = 10
        personbtnView.layer.cornerRadius = 10
        firstText()

    }
    func firstText(){
        ref.child("total_time").child(UserModel.shared.myInfo.uid).observe(.value, with: { snapshot in
            let usertime = snapshot.value as! [String : Int]
            
            self.timerText.text = self.timerTextChange(tiemr: Double(usertime["total_time"] ?? 0))
        })
    }
    @IBAction func stopwatchTimer(_ sender: Any) {
        print("stopwatchbuttonTap")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "StopwatchViewController") else { return }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    @IBAction func stopwatchTap(_ sender: Any) {
        print("stopwatchTap")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "StopwatchViewController") else { return }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        timerText.text = timerTextChange(tiemr: UserModel.shared.myInfo.timer)
        
    }
    @IBAction func AIButton(_ sender: Any) {
        print("aibuttonTap")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "AIViewController") else { return }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    @IBAction func aiTap(_ sender: Any) {
        print("aiTap")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "AIViewController") else { return }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    @IBAction func pictureButton(_ sender: Any) {
        print("picturebuttonTap")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewController") else { return }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    @IBAction func pictureTap(_ sender: Any) {
        print("pictureTap")
        guard let homeVC = self.storyboard?.instantiateViewController(withIdentifier: "PictureViewController") else { return }
        self.navigationController?.pushViewController(homeVC, animated: true)
    }
    
    
}
