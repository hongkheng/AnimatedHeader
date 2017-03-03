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
    
    var previousScrollViewYOffset: CGFloat = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.contentInset.top = 75.0
        //self.navigationController?.navigationBar.backgroundColor = UIColor(red: 0/255.0, green: 176/255.0, blue: 178/255.0, alpha: 1.0)
        //UIApplication.shared.statusBarStyle = .lightContent
        UIApplication.shared.statusBarView?.backgroundColor = UIColor(red: 0/255.0, green: 176/255.0, blue: 178/255.0, alpha: 1.0)
        
        self.navigationController?.navigationBar.shadowImage = UIColor(red: 1/255.0, green: 176/255.0, blue: 181/255.0, alpha: 1.0).as1ptImage()
        self.navigationController?.navigationBar.setBackgroundImage(UIColor(red: 0.071/255.0, green: 0.706, blue: 0.722, alpha: 1.0).as1ptImage(), for: .default)
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = UIColor.clear
        //self.buttonBar.backgroundColor = UIColor(red: 1/255.0, green: 176/255.0, blue: 181/255.0, alpha: 1.0)

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //print("yoffset \(scrollView.contentOffset.y)")
        
        //self.topContraint.constant = -scrollView.contentOffset.y - 75.0
        //print("contraint \(self.topContraint.constant)")
        
        if self.topContraint.constant <= -75.0 {
            self.navigationController?.setNavigationBarHidden(true, animated: false)
            self.view.bringSubview(toFront: toolbarView)
        } else {
            self.navigationController?.setNavigationBarHidden(false, animated: false)
            self.view.sendSubview(toBack: toolbarView)
        }
        
        var frame:CGRect = (self.navigationController?.navigationBar.frame)!
        //var buttonBarFrame = self.buttonBar.frame
        let size = frame.size.height - 21
        let buttonSize = self.buttonBar.frame.size.height - 37
        let framePrecentageHidden = (20 - frame.origin.y) / (frame.size.height - 1)
        let scrollOffset = scrollView.contentOffset.y;
        let scrollDiff = scrollOffset - self.previousScrollViewYOffset;
        let scrollHeight = scrollView.frame.size.height;
        let scrollContentSizeHeight = scrollView.contentSize.height + scrollView.contentInset.bottom;
        print("frame origin \(frame.origin.y)")
        print("scrol offset \(scrollOffset)")
        
        // reach
        if (scrollOffset <= -scrollView.contentInset.top) {
            frame.origin.y = 20;
            self.topContraint.constant = 0.0
            print("scroll up? \(self.topContraint.constant)")
        } else if ((scrollOffset + scrollHeight) >= scrollContentSizeHeight) {
            frame.origin.y = -size;
            self.topContraint.constant = -44 - size
            print("reach bottom? \(self.topContraint.constant)")
        } else {
            frame.origin.y = min(20, max(-size, frame.origin.y - scrollDiff))
            self.topContraint.constant = min(0.0, max(-44 - size, self.topContraint.constant - scrollDiff))
            print("frame.origin.y \(frame.origin.y) \(-size) \(-buttonSize)")
            print("contraint y \(self.topContraint.constant - scrollDiff)")
        }
        
        self.navigationController?.navigationBar.frame = frame
        self.updateBarButtonItems(alpha: (1 - framePrecentageHidden))
        self.previousScrollViewYOffset = scrollOffset
        
        //let alpha: CGFloat = max(0,1 + (self.topContraint.constant / 75.0))
        //print("alpha \(alpha)")
        //self.navigationController?.navigationBar.alpha = alpha
        
        self.view.layoutIfNeeded()
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        //self.stoppedScrolling()
    }

    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            self.stoppedScrolling()
        }
        //print("end drag")
    }
    
    func stoppedScrolling() {
        // animate nav bar
        let frame = self.navigationController?.navigationBar.frame
        if let yValue = frame?.origin.y {
            if yValue < CGFloat(20.0) {
                self.animateNavBarTo(y: -((frame?.size.height)! - 21))
                self.animateButtonBarTo(y: -65)
            }
        }

    }
    
    func updateBarButtonItems(alpha: CGFloat) {
        
        if let leftBarButtonItems = self.navigationItem.leftBarButtonItems {
            for (item) in leftBarButtonItems {
                item.customView?.alpha = alpha;
            }
        }

        self.navigationItem.titleView?.tintColor.withAlphaComponent(alpha)
    
        self.navigationController?.navigationBar.tintColor = self.navigationController?.navigationBar.tintColor.withAlphaComponent(alpha)
    
    }
    
    func animateNavBarTo(y: CGFloat) {
    
        UIView.animate(withDuration: 0.2, animations: {
        
            var frame = self.navigationController?.navigationBar.frame
            let alpha = (frame?.origin.y)! >= y ? 0 : 1
            frame?.origin.y = y
            self.navigationController?.navigationBar.frame = frame!
            self.updateBarButtonItems(alpha: CGFloat(alpha))
        })
    }
    
    func animateButtonBarTo(y: CGFloat) {
        UIView.animate(withDuration: 0.2, animations: {
            
            self.topContraint.constant = y
            print("end scroll \(y)")
        })
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
