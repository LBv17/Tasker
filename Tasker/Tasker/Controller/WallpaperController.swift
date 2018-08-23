//
//  WallpaperController.swift
//  Tasker
//
//  Created by Lorenzo Baldassarri on 07.08.18.
//  Copyright © 2018 Lorenzo Baldassarri. All rights reserved.
//

import UIKit

class WallpaperController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        collectionView.dataSource = self
        collectionView.delegate = self
        
        
        for cell in collectionView.visibleCells {
            print(cell)
        }
        
        /*
        var counter = 0
        for name in names {
            if name == Preferences.backgroundImageName {
                // check amount of cells in view
                let cell = self.collectionView.cellForItem(at: IndexPath(item: counter, section: 0)) as! WallpaperCell
                cell.currentWallpaper.isHidden = false
                cell.layer.borderWidth = 4
                cell.layer.borderColor = UIColor.black.cgColor
            }
            counter += 1
        }*/
        
    }
    
    @IBOutlet weak var collectionView: UICollectionView!
    var names = ["Lavender Magenta", "Dodger Blue", "Texas Rose", "Pastel Green","Watermelon", "Heliotrope", "None", "black", "Vibrant Paint"]
    var images = [UIImage(named: "Lavender Magenta"), UIImage(named: "Dodger Blue"), UIImage(named: "Texas Rose"), UIImage(named: "Pastel Green"), UIImage(named: "Watermelon"), UIImage(named: "Heliotrope"), UIImage(), UIImage(named: "black"), UIImage(named: "Vibrant Paint")]
    let reuseID = "wallpaperCell"
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseID, for: indexPath) as! WallpaperCell
        cell.wallpaper.image = images[indexPath.item]
        cell.wallpaper.layer.cornerRadius = 10.0
        cell.currentWallpaper.isHidden = true
        cell.layer.cornerRadius = 10.0
        cell.layer.borderWidth = 2
        cell.layer.borderColor = UIColor.black.cgColor
        
        if indexPath.item >= 7 {
            cell.currentWallpaper.image = UIImage(named: "checkmark-white.png")
        } else {
            cell.currentWallpaper.image = UIImage(named: "checkmark-black.png")
        }
        
        var index = 0
        for name in names {
            if name == Preferences.backgroundImageName {
                if (indexPath.item == index) {
                    cell.currentWallpaper.isHidden = false
                    cell.layer.borderWidth = 4
                    cell.layer.borderColor = UIColor.black.cgColor
                }
            }
            index += 1
        }
        

        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: CGFloat(100), height: CGFloat(150))
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        for x in 0..<images.count {
            print(x)
            let cell = collectionView.cellForItem(at: IndexPath(item: x, section: 0)) as! WallpaperCell
            cell.currentWallpaper.isHidden = true
            cell.layer.borderWidth = 2
            cell.layer.borderColor = UIColor.black.cgColor
        }
        
        let cell = collectionView.cellForItem(at: indexPath) as! WallpaperCell
        
        cell.currentWallpaper.isHidden = false
        cell.layer.borderWidth = 4
        cell.layer.borderColor = UIColor.black.cgColor
        // save wallpaper name to prefrences
        
        Preferences.backgroundImageName = names[indexPath.item]
        
        print("Selected \(indexPath.item)")
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
