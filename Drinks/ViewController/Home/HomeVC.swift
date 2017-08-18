//
//  HomeVC.swift
//  Drinks
//
//  Created by maninder on 8/4/17.
//  Copyright © 2017 Maninderjit Singh. All rights reserved.
//

import UIKit

class HomeVC: UIViewController,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var btnCreateGroup: UIButton!
    @IBOutlet var collectionFlowLayout: UICollectionViewFlowLayout!
    @IBOutlet var collectionViewGroup: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.layoutIfNeeded()
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true

        self.view.backgroundColor = UIColor.groupTableViewBackground
        
        let nib = UINib(nibName: "GroupCell", bundle: nil)
        collectionViewGroup.register(nib, forCellWithReuseIdentifier: "GroupCell")
        collectionViewGroup.delegate = self
        collectionViewGroup.dataSource = self
        collectionViewGroup.backgroundColor = UIColor.groupTableViewBackground

        

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationItem.hidesBackButton = true

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func actionBtnCreateGroup(_ sender: UIButton) {
        let camera =  self.storyboard?.instantiateViewController(withIdentifier: "CreateGroupVC") as! CreateGroupVC
        let navigation = UINavigationController(rootViewController: camera)
        self.navigationController?.present(navigation, animated: true, completion: nil)
        
    }
    
    //MARK:- CollectionView Delegate Methods
    //MARK:-
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 10
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GroupCell", for: indexPath) as! GroupCell
         return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize{
        return CGSize(width: self.collectionViewGroup.bounds.width, height: 5)
    }
    

    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        let size = CGSize(width: ((collectionViewGroup.frame.width - 5)/2), height: collectionViewGroup.frame.width/2 + 90)
        return size
        
    }
    
 
    
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let groupVC =  self.storyboard?.instantiateViewController(withIdentifier: "FilterVC") as! FilterVC
        self.navigationController?.pushViewController(groupVC, animated: true)

    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
