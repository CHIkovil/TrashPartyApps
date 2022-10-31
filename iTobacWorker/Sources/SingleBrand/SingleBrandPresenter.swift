//
//  SingleBrandPresenter.swift
//  iTobacWorker
//
//  Created by Nikolas on 12.02.2022.
//

import UIKit

protocol SingleBrandDelegate
{
 
}

class SingleBrandPresenter
{
    weak var singleBrandViewDelegate: SingleBrandViewDelegate?
    
      init(delegate:SingleBrandViewDelegate){
          self.singleBrandViewDelegate = delegate
      }
   
}

extension SingleBrandPresenter: SingleBrandDelegate {
    
}
