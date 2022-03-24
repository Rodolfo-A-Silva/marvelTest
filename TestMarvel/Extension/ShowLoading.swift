//
//  ShowLoading.swift
//  TestMarvel
//
//  Created by Reedy on 23/03/22.
//

import Foundation
import UIKit

extension UIViewController {
    
    func showLoading(enable: Bool = true){
        let loadingVC = LoadingController()
        // Animate loadingVC over the existing views on screen
        loadingVC.modalPresentationStyle = .overCurrentContext
        
        // Animate loadingVC with a fade in animation
        loadingVC.modalTransitionStyle = .crossDissolve
        
        if enable {
            //inicio do load
            present(loadingVC, animated: true, completion: nil)
            
        }else {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
