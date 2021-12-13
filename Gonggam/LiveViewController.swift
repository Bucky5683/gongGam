//
//  LiveViewController.swift
//  GongGam
//
//  Created by 김서연 on 2021/09/25.
//

import UIKit

class LiveViewController: ViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    var imageName = ["1.png","1.png","1.png","1.png","1.png","1.png","1.png","1.png","1.png","1.png"]
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imageName.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! CollectionViewCell

        cell.imag.image = UIImage(named: imageName[indexPath.row])
        cell.imag.frame.size = CGSize(width: collectionView.frame.width, height: 188)
            
        return cell
    }
    
    // 위 아래 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
            return 6
        }

        // 옆 간격
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
            return 6
        }

        // cell 사이즈( 옆 라인을 고려하여 설정 )
        func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            let width = collectionView.frame.width / 3 - 6 ///  3등분하여 배치, 옆 간격이 1이므로 1을 빼줌
            print("collectionView width=\(collectionView.frame.width)")
            print("cell하나당 width=\(width)")
            print("root view width = \(self.view.frame.width)")

            let size = CGSize(width: width, height: 188)
            
            return size
        }
    @IBAction func startBtn(_ sender: Any) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "ReadyLiveViewController") else {print("error");return}

        print("storyboard name load")
        self.present(nextVC, animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }

}
