//
//  BrandsViewController.swift
//  iTobacWorker
//
//  Created by Nikolas on 29.01.2022.
//

import UIKit


//MARK: STRING

private enum BrandsViewString: String {
    case collectionCellIdentifier = "CollectionViewCellIdentifier"
}

// MARK: DELEGATE

protocol BrandsViewDelegate: AnyObject{
    
}


class BrandsViewController: UIViewController
{
    var brandsView: BrandsView!
    var brandsPresenter: (BrandsParseDelegate & BrandsDataSourceDelegate)!
    
    var selectedCell: CollectionViewCell?
    var selectedCellImageViewSnapshot: UIView?
    weak var selectedBrandController: SingleBrandViewController?
    
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
        brandsView = BrandsView()
        brandsPresenter = BrandsPresenter(delegate: self)
    }
    
    // MARK: View lifecycle
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        view = brandsView
        
        brandsView.collectionView.delegate = self
        brandsView.collectionView.dataSource = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.brandsView.collectionView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        brandsPresenter.parseBrandsFromFolder()
    }
    
    // MARK: SUPPORT FUNC
    
    func presentBrandController(with data: Brand) {
        let singleBrandViewController = SingleBrandViewController()
        
        singleBrandViewController.transitioningDelegate = self
        singleBrandViewController.brand = data
        
        selectedBrandController = singleBrandViewController
        
        present(singleBrandViewController, animated: true)
    }
    
}

//MARK: DELEGATE EXTENSION

extension BrandsViewController: BrandsViewDelegate {
    
}

extension BrandsViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        let origCenter = cell.center
        
        let randomAngle = arc4random_uniform(361) + 360
        
        cell.transform = CGAffineTransform(scaleX: 0.01, y: 0.01).rotated(by: CGFloat(randomAngle))
        cell.center = CGPoint(x: self.brandsView.collectionView.bounds.midX, y: self.brandsView.collectionView.bounds.maxY)
        
        UIView.animate(
            withDuration: 2,
            delay: 0.05 * Double(indexPath.row),
            usingSpringWithDamping: 0.4,
            initialSpringVelocity: 0.1,
            options: [.curveEaseInOut],
            animations: {
                cell.transform = CGAffineTransform.identity
                cell.center = origCenter
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return brandsPresenter.getBrandsCount() ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: BrandsViewString.collectionCellIdentifier.rawValue)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BrandsViewString.collectionCellIdentifier.rawValue, for: indexPath) as! CollectionViewCell
        if let brand = brandsPresenter.getBrandByIndex(at: indexPath.row) {
            cell.configure(with: brand)
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCell = collectionView.cellForItem(at: indexPath) as? CollectionViewCell
        selectedCellImageViewSnapshot = selectedCell?.brandImageView.snapshotView(afterScreenUpdates: false)
        if let brand = brandsPresenter.getBrandByIndex(at: indexPath.row) {
            presentBrandController(with: brand)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (collectionView.bounds.width - 4 * BrandsViewConstants.cellSpacing) / 2
        return .init(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: BrandsViewConstants.cellSpacing, left: BrandsViewConstants.cellSpacing, bottom: BrandsViewConstants.cellSpacing, right: BrandsViewConstants.cellSpacing)
    }
}

extension BrandsViewController: UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        guard let secondViewController = selectedBrandController,
              let selectedCellImageViewSnapshot = selectedCellImageViewSnapshot
        else { return nil }
        
        let animator = CollectionAnimator(firstViewController: self, secondViewController: secondViewController, selectedCellImageViewSnapshot: selectedCellImageViewSnapshot)
        return animator
    }
}

