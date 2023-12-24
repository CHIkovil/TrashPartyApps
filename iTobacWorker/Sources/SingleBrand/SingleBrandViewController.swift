//
//  SingleBrandViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import UIKit

protocol SingleBrandViewDelegate: AnyObject
{
    
}

class SingleBrandViewController: UIViewController
{
    var singleBrandView: SingleBrandView!
    var singleBrandPresenter: SingleBrandDelegate!
    
    var brand: Brand!
    
    // MARK: Object lifecycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setup()
    }
    
    // MARK: Setup
    
    private func setup()
    {
        singleBrandView = SingleBrandView()
        singleBrandPresenter = SingleBrandPresenter(delegate: self)
        
        
        singleBrandView.closeButton.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(didPressCloseButton)))
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        view = singleBrandView
        
        singleBrandView.brandLabel.text = brand.title
    }
    
    // MARK: OBJC
    
    @objc func didPressCloseButton() {
        self.dismiss(animated: false)
    }
}

// MARK: DELEGATE

extension SingleBrandViewController: SingleBrandViewDelegate {
    
}


