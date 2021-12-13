//
//  ViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/14.
//
import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var NaviRbtn: UIButton!
    @IBOutlet weak var NaviLbtn: UIButton!
    @IBOutlet weak var NaviTitle: UILabel!
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func showToast(message : String, font: UIFont = UIFont.systemFont(ofSize: 14.0)) {
        let width_variable:CGFloat = 5
        let toastLabel = UILabel(frame: CGRect(x: width_variable, y: self.view.frame.size.height-100, width: view.frame.size.width-2*width_variable, height: 35));
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.font = font
        toastLabel.textAlignment = .center
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10
        toastLabel.clipsToBounds = true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: { toastLabel.alpha = 0.0 }, completion: {(isCompleted) in toastLabel.removeFromSuperview() })
    }
    
    func timerTextChange(tiemr: Double) -> String{
        let intTimer: Int = Int(tiemr)
        var changeTimer: String
        changeTimer = String(format: "%02d",intTimer/3600) + ":" + String(format: "%02d",(intTimer - (intTimer/3600)*3600)/60) + ":" + String(format: "%02d",(intTimer - (intTimer/3600)*3600)%60)
        return changeTimer
    }
    
    func rankTextChange(rank: Int) -> String {
        var changeRank: String
        if(rank < 10){
            changeRank = "00" + String(rank) + "위"
        }
        else if(rank >= 10 && rank < 100){
            changeRank = "0" + String(rank) + "위"
        }
        else if(rank >= 100 && rank < 1000){
            changeRank = String(rank) + "위"
        }
        else{
            changeRank = "999+위"
        }
        return changeRank
    }
    
}
