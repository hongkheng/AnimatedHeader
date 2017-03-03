//
//  ViewController.swift
//  AnimatedHeader
//
//  Created by Yap Hong Kheng on 2/3/17.
//  Copyright © 2017 Singapore Power. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIScrollViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var toolbarView: UIToolbar!
    @IBOutlet weak var buttonBar: UIView!
    
    @IBOutlet weak var topContraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset.top = 75.0
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0/255.0, green: 176/255.0, blue: 178/255.0, alpha: 1.0)
        //UIApplication.shared.statusBarStyle = .lightContent
        //UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 0/255.0, green: 176/255.0, blue: 178/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.shadowImage = UIColor(red: 0.071/255.0, green: 0.706, blue: 0.722, alpha: 1.0).as1ptImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIColor(red: 0.071/255.0, green: 0.706, blue: 0.722, alpha: 1.0).as1ptImage(), for: .default)
        
        //self.buttonBar.backgroundColor = UIColor(red: 1/255.0, green: 176/255.0, blue: 181/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        print(scrollView)
        
        print("yoffset \(scrollView.contentOffset.y) navigationbar \(self.navigationController?.navigationBar.frame.size.height)")
        
        self.topContraint.constant = -scrollView.contentOffset.y - 75.0
 
        print("contraint \(self.topContraint.constant)")
        
        if self.topContraint.constant <= -75.0 {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.view.bringSubview(toFront: toolbarView)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.view.sendSubview(toBack: toolbarView)
        }
        
        self.view.setNeedsLayout()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "label cell \(indexPath.row)"
        return cell
    }
    
    

}

extension UIColor {
    func as1ptImage() -> UIImage {
        UIGraphicsBeginImageContext(CGSize(width: 1, height: 1))
        let ctx = UIGraphicsGetCurrentContext()
        self.setFill()
        ctx!.fill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
}
