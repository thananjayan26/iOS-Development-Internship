//
//  FoodPageViewController.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 27/10/23.
//
//  Updated

import UIKit
import CoreLocation

class FoodPageViewController: UIViewController {
    
    @IBOutlet weak var foodPageCollectionView: UICollectionView!
    
    @IBOutlet weak var cartRestaurantNameLabel: UILabel!
    @IBOutlet weak var cartitemPriceLabel: UILabel!
    @IBOutlet weak var cartCapsuleView: UIView!
    @IBOutlet weak var cartBackgroundView: UIView!
    @IBOutlet weak var cartRestaurantImageView: UIImageView!
    @IBOutlet weak var viewFullMenuLabel: UILabel!
    @IBOutlet weak var deleteOrderButton: UIButton!
    @IBOutlet weak var foodPageCollectionViewBottomSuperviewConstraint: NSLayoutConstraint!
    @IBOutlet weak var foodPageCollectionViewBottomCartViewConstraint: NSLayoutConstraint!
    
    
    private let searchController = UISearchController()
    var trustedPicksSelectedCapsuleIndex: Int = 0
    var quickPicksSelectedCapsuleIndex: Int = 0
    var currentCarouselIndex: Int = 0
    var carouselIndexSection: Int?
    var timer: Timer?
    var autoScrolling: Bool? = true
    var updatePageControlDelegate: UpdatePageControlDelegate?
    let refreshControl = UIRefreshControl()
    let locationShortNameLabel = UILabel()
    let locationLongNameLabel = UILabel()
    var address: String? = nil
    
    @IBAction func deleteOrderButtonClicked(_ sender: Any) {
        AppCoreData.instance.deleteOrderDetails()
        cartBackgroundView.isHidden = true
        updateFoodCollectionViewBottomToSuperViewBottom()
    }
 
    @objc func continueCarousel() {
        startTimer()
    }
    
    @objc func scrollToNextCarousel() {
        guard let carouselSection = carouselIndexSection else { return }
        let carouselLength = foodPageCollectionView.numberOfItems(inSection: carouselSection)
        if currentCarouselIndex < carouselLength-1 {
            currentCarouselIndex += 1
        } else {
            currentCarouselIndex = 0
        }
        updatePageControlDelegate?.updatePageControl(currentPage: currentCarouselIndex)
        autoScrolling = true
        if currentCarouselIndex == 0 {
            self.foodPageCollectionView.scrollToItem(at: IndexPath(item: self.currentCarouselIndex, section: carouselSection), at: .left, animated: true)
            return
        }
        UIView.animate(withDuration: 0.85, animations: { [weak self] in
            guard let self = self else { return }
            self.foodPageCollectionView.scrollToItem(at: IndexPath(item: self.currentCarouselIndex, section: carouselSection), at: .right, animated: false)
        })
        autoScrolling = false
    }
    
    func updateFoodCollectionViewBottomToCartTop() {
        self.view.layoutIfNeeded()
        print(cartBackgroundView.frame.height)
        foodPageCollectionView.contentInset.bottom = cartBackgroundView.frame.height
    }
    
    func updateFoodCollectionViewBottomToSuperViewBottom() {
        foodPageCollectionView.contentInset.bottom = 0
    }

    
    func displayCartSummary() {
        let totalItems = AppCoreData.instance.getNumberOfItems() ?? 0
        if totalItems == 0 {
            cartBackgroundView.isHidden = true
            updateFoodCollectionViewBottomToSuperViewBottom()
        } else {
            updateFoodCollectionViewBottomToCartTop()
            cartBackgroundView.isHidden = false
            let totalOrderPrice = AppCoreData.instance.getOrderTotal()
            cartitemPriceLabel.text = "\(totalItems) Items | ₹\(totalOrderPrice)"
        }
    }
    
    func updateAddressLabels(setAddress: String) {
        let splitAddress = setAddress.split(separator: ",", maxSplits: 1).map(String.init)
        locationShortNameLabel.text = splitAddress.first
        if splitAddress.count > 1 {
            locationLongNameLabel.text = splitAddress.last
        } else {
            locationLongNameLabel.text = ""
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        (tabBarController as? HomeTabBarController)?.checkForSelectedAddress()

        displayCartSummary()
        startTimer()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        autoScrolling = false
    }
    
    func startTimer() {
        if timer == nil || !timer!.isValid {
            timer = Timer.scheduledTimer(timeInterval: 3.2, target: self, selector: #selector(scrollToNextCarousel), userInfo: nil, repeats: true)
        }
    }
    
    func stopTimer() {
        if ((timer?.isValid) != nil) {
            timer?.invalidate()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        stopTimer()
    }
    
    @objc func refreshCollectionView() {
        refreshControl.beginRefreshing()
        print("refresh control called")
        DispatchQueue.global().asyncAfter(deadline: .now() + .seconds(1)){
            DispatchQueue.main.async {
                self.foodPageCollectionView.reloadData()
                self.refreshControl.endRefreshing()
            }
        }
    }
    
    @objc func goToCartViewController() {
        guard let cartViewController = storyboard?.instantiateViewController(identifier: CartViewController.identifier) as? CartViewController else { return }
        navigationController?.pushViewController(cartViewController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.setNavigationBarHidden(true, animated: true)
        let cartTap = UITapGestureRecognizer(target: self, action: #selector(goToCartViewController))
        cartCapsuleView.addGestureRecognizer(cartTap)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.prominent)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        
        blurEffectView.frame = cartBackgroundView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cartBackgroundView.insertSubview(blurEffectView, at: 0)
        blurEffectView.layer.cornerRadius = 24
        blurEffectView.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        blurEffectView.clipsToBounds = true
       
        cartRestaurantImageView.layer.cornerRadius = cartRestaurantImageView.frame.height/2
        cartBackgroundView.isHidden = false
        cartCapsuleView.layer.cornerRadius = 12
        deleteOrderButton.tintColor = .deleteTint
        
        foodPageCollectionView.register(TrustedPicksCapsuleCollectionViewCell.nib, forCellWithReuseIdentifier: TrustedPicksCapsuleCollectionViewCell.identifier)
        foodPageCollectionView.register(SectionHeaderCollectionReusableView.nib, forCellWithReuseIdentifier: SectionHeaderCollectionReusableView.identifier)
        foodPageCollectionView.register(CarouselCollectionViewCell.nib, forCellWithReuseIdentifier: CarouselCollectionViewCell.identifier)
        foodPageCollectionView.register(StaticThreeCollectionViewCell.nib, forCellWithReuseIdentifier: StaticThreeCollectionViewCell.identifier)
        foodPageCollectionView.register(VideoCollectionViewCell.nib, forCellWithReuseIdentifier: VideoCollectionViewCell.identifier)
        foodPageCollectionView.register(RestaurantThumbnailMiniCollectionViewCell.nib, forCellWithReuseIdentifier: RestaurantThumbnailMiniCollectionViewCell.identifier)
        foodPageCollectionView.register(QuickPicksCapsuleCollectionViewCell.nib, forCellWithReuseIdentifier: QuickPicksCapsuleCollectionViewCell.identifier)
        foodPageCollectionView.register(CarouselPageControlCollectionViewCell.nib, forCellWithReuseIdentifier: CarouselPageControlCollectionViewCell.identifier)
        
        foodPageCollectionView.collectionViewLayout = createLayout()
        // Do any additional setup after loading the view.
        
        refreshControl.attributedTitle = NSAttributedString(string: "Refreshing Data ...")
        refreshControl.addTarget(self, action: #selector(refreshCollectionView), for: .valueChanged)
        refreshControl.tintColor = .orange
        foodPageCollectionView.refreshControl = refreshControl
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(viewFullMenuClicked))
        viewFullMenuLabel.addGestureRecognizer(tap)
    }
    
    @objc func viewFullMenuClicked() {
        print("view full menu clkcked")
        guard let collectionHomeViewController = storyboard?.instantiateViewController(withIdentifier: CollectionHomeViewController.identifier) as? CollectionHomeViewController else {
            return
        }
        navigationController?.pushViewController(collectionHomeViewController, animated: true)
    }
    
    private func createLayout() -> UICollectionViewCompositionalLayout {
        UICollectionViewCompositionalLayout { [weak self] sectionIndex, layoutEnvironment in
            if let self = self {
                let section = foodPageData[sectionIndex].title
                switch section {
                case .ThreeStaticSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.33), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.14)), repeatingSubitem: item, count: 3)
                    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(16)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 8, leading: leadingTrailingSectionInsetFoodPage, bottom: bottomSectionInsetFoodPage, trailing: leadingTrailingSectionInsetFoodPage)
                    section.orthogonalScrollingBehavior = .none
                    return section
                    
                case .VideoSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.11)), subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 8, bottom: bottomSectionInsetFoodPage, trailing: 8)
                    return section
                    
                case .CarouselSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.89), heightDimension: .fractionalHeight(0.25)), subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 0, bottom: 0, trailing: 0)
                    section.interGroupSpacing = 12
                    section.orthogonalScrollingBehavior = .groupPagingCentered
                    section.visibleItemsInvalidationHandler = { visibleItems, point, environment in
                        guard let carouselSection = self.carouselIndexSection else { return }
                        var temp: [Int] = []
                        for i in self.foodPageCollectionView.indexPathsForVisibleItems where i.section == carouselSection {
                            temp.append(i.item as Int)
                        }
                        temp.sort()
                        
                        let numberOfItemsInSection = self.foodPageCollectionView.numberOfItems(inSection: carouselSection)
                        
                        guard let userScrolled = self.autoScrolling else { return }
                        if !userScrolled {
                            if temp.count == 2 {
                                if temp[0] == 0 {
                                    self.currentCarouselIndex = 0
                                } else if temp[1] == numberOfItemsInSection-1 {
                                    self.currentCarouselIndex = numberOfItemsInSection-1
                                }
                            } else if temp.count == 3 {
                                self.currentCarouselIndex = temp[1]
                            } else if temp.count == 1 {
                                self.currentCarouselIndex = temp[0]
                            }
                            self.updatePageControlDelegate?.updatePageControl(currentPage: self.currentCarouselIndex)
                            self.stopTimer()
                        }
                    }
                    
                    return section
                    
                case .SixRestaurantSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.333), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.23)), repeatingSubitem: item, count: 3)
                    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(20)
                    group.contentInsets = .init(top: 14, leading: leadingTrailingSectionInsetFoodPage, bottom: 0, trailing: leadingTrailingSectionInsetFoodPage)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: 0, bottom: bottomSectionInsetFoodPage, trailing: 0)
                    section.interGroupSpacing = 8
                    section.orthogonalScrollingBehavior = .none
                    return section
                    
                case .CapsuleSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .estimated(100), heightDimension: .fractionalHeight(0.0455)), subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: leadingTrailingSectionInsetFoodPage, bottom: 0, trailing: leadingTrailingSectionInsetFoodPage)
                    section.interGroupSpacing = 8
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                    return section
                    
                case .DishTypeSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.5)))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.27), heightDimension: .fractionalHeight(0.3)), repeatingSubitem: item, count: 2)
                    group.interItemSpacing = NSCollectionLayoutSpacing.fixed(12)
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: leadingTrailingSectionInsetFoodPage, bottom: bottomSectionInsetFoodPage, trailing: leadingTrailingSectionInsetFoodPage)
                    section.interGroupSpacing = 8
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                    return section
                    
                case .TopRatedNearYouSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.35), heightDimension: .fractionalHeight(0.27)), subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 0, leading: leadingTrailingSectionInsetFoodPage, bottom: bottomSectionInsetFoodPage, trailing: leadingTrailingSectionInsetFoodPage)
                    section.interGroupSpacing = 22
                    section.orthogonalScrollingBehavior = .continuous
                    section.boundarySupplementaryItems = [self.supplementaryHeaderItem()]
                    return section
                    
                case .CarouselPageControlSection:
                    let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
                    let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.01)), subitems: [item])
                    let section = NSCollectionLayoutSection(group: group)
                    section.contentInsets = .init(top: 20, leading: leadingTrailingSectionInsetFoodPage, bottom: bottomSectionInsetFoodPage, trailing: leadingTrailingSectionInsetFoodPage)
                    return section
                }
            }

            let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.3), heightDimension: .fractionalHeight(1)))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(0.17)), subitems: [item, item, item])
            group.interItemSpacing = NSCollectionLayoutSpacing.fixed(8)
            let section = NSCollectionLayoutSection(group: group)
            section.contentInsets = .init(top: 0, leading: 16, bottom: 0, trailing: 16)
            section.interGroupSpacing = 40
            section.boundarySupplementaryItems = [self!.supplementaryHeaderItem()]
            section.orthogonalScrollingBehavior = .none
            return section
        }
    }
    
    private func supplementaryHeaderItem() -> NSCollectionLayoutBoundarySupplementaryItem {
        .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .estimated(50)), elementKind: UICollectionView.elementKindSectionHeader, alignment: .top)
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func updateCapsuleSelected(selectedIndexPath: IndexPath, previousSelectedIndexPath: IndexPath) {
        var currentCell = foodPageCollectionView.cellForItem(at: selectedIndexPath)
        if true {
            currentCell = currentCell as? TrustedPicksCapsuleCollectionViewCell
        }
    }
}



extension FoodPageViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let cell = foodPageCollectionView.cellForItem(at: indexPath) else {
            return
        }
        if cell.isKind(of: TrustedPicksCapsuleCollectionViewCell.self) {
            guard let currentSelectedCell = foodPageCollectionView.cellForItem(at: indexPath) as? TrustedPicksCapsuleCollectionViewCell else { return }
            currentSelectedCell.updateToSelectedState()
            guard let previousSelectedCell = foodPageCollectionView.cellForItem(at: IndexPath(row: trustedPicksSelectedCapsuleIndex, section: indexPath.section)) as? TrustedPicksCapsuleCollectionViewCell else { return }
            previousSelectedCell.updateToDeselectedState()
            trustedPicksSelectedCapsuleIndex = indexPath.item
        } else if cell.isKind(of: QuickPicksCapsuleCollectionViewCell.self) {
            guard let currentSelectedCell = foodPageCollectionView.cellForItem(at: indexPath) as? QuickPicksCapsuleCollectionViewCell else { return }
            currentSelectedCell.updateToSelectedState()
            guard let previousSelectedCell = foodPageCollectionView.cellForItem(at: IndexPath(row: quickPicksSelectedCapsuleIndex, section: indexPath.section)) as? QuickPicksCapsuleCollectionViewCell else { return }
            previousSelectedCell.updateToDeselectedState()
            quickPicksSelectedCapsuleIndex = indexPath.item
        } else if !(cell.isKind(of: CarouselCollectionViewCell.self)) {
            guard let collectionHomeViewController = storyboard?.instantiateViewController(withIdentifier: CollectionHomeViewController.identifier) as? CollectionHomeViewController else {
                return
            }
            navigationController?.pushViewController(collectionHomeViewController, animated: true)
        }
    }
}

extension FoodPageViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        foodPageData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        foodPageData[section].items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionView.elementKindSectionHeader:
            let header = foodPageCollectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: SectionHeaderCollectionReusableViewCell.identifier, for: indexPath) as! SectionHeaderCollectionReusableViewCell
            switch foodPageData[indexPath.section].title {
            case let .CapsuleSection(title):
                header.setUpCell(data: title)
            case let .DishTypeSection(title):
                header.setUpCell(data: title)
            case let .TopRatedNearYouSection(title):
                header.setUpCell(data: title)
            default:
                print("Add required case in viewforsupplementaryelemtnofkind")
            }
            return header
        default:
            return UICollectionReusableView()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let model = foodPageData[indexPath.section].items[indexPath.item]
        switch model.self {
        case .threeStaticCell(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: StaticThreeCollectionViewCell.identifier, for: indexPath) as? StaticThreeCollectionViewCell {
                cell.setUpCell(data: data)
                return cell
            }
            
        case .videoCell(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: VideoCollectionViewCell.identifier, for: indexPath) as? VideoCollectionViewCell {
                cell.setUpCell(data: data)
                return cell
            }
            
        case .carouselCell(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: CarouselCollectionViewCell.identifier, for: indexPath) as? CarouselCollectionViewCell {
                cell.setUpCell(data: data)
                if carouselIndexSection == nil {
                    carouselIndexSection = indexPath.section
                }
                guard let valid = timer?.isValid else { return cell }
                if !valid {
                }
                return cell
            }
            
        case .restaurantThumbnailMiniCell(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: RestaurantThumbnailMiniCollectionViewCell.identifier, for: indexPath) as? RestaurantThumbnailMiniCollectionViewCell {
                cell.setUpCell(data: data)
                return cell
            }
            
        case .dishCell(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: StaticThreeCollectionViewCell.identifier, for: indexPath) as? StaticThreeCollectionViewCell {
                cell.setUpCell(data: data)
                cell.layer.cornerRadius = 10
                cell.cellImageView.contentMode = .scaleAspectFit
                return cell
            }
            
            case .cravingInteractionCell(_):
            return UICollectionViewCell()
            
        case .trustedPicksCapsuleSegment(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: TrustedPicksCapsuleCollectionViewCell.identifier, for: indexPath) as? TrustedPicksCapsuleCollectionViewCell {
                cell.setUpCell(data: data)
                if indexPath.item == trustedPicksSelectedCapsuleIndex {
                    cell.updateToSelectedState()
                }
                return cell
            }
            
        case .quickPicksCapsuleSegment(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: QuickPicksCapsuleCollectionViewCell.identifier, for: indexPath) as? QuickPicksCapsuleCollectionViewCell {
                cell.setUpCell(data: data)
                if indexPath.item == quickPicksSelectedCapsuleIndex {
                    cell.updateToSelectedState()
                }
                return cell
            }
            
            case .restaurantCell(_):
            return UICollectionViewCell()
            
        case .restaurantThumbnailMegaCell(let data):
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: RestaurantThumbnailMiniCollectionViewCell.identifier, for: indexPath) as? RestaurantThumbnailMiniCollectionViewCell {
                cell.setUpCell(data: data)
                cell.configureToMega()
                return cell
            }
            
        case .carouselPageControlCell:
            if let cell = foodPageCollectionView.dequeueReusableCell(withReuseIdentifier: CarouselPageControlCollectionViewCell.identifier, for: indexPath) as? CarouselPageControlCollectionViewCell {
                self.updatePageControlDelegate = cell
                cell.setUpCell(pageCount: foodPageData[indexPath.section-1].items.count)
                return cell
            }
        }
        return UICollectionViewCell()
    }
}

extension FoodPageViewController: UIScrollViewDelegate {
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        stopTimer()
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        startTimer()
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
    }
}

extension FoodPageViewController: AddressSetDelegate {
    func sendDeliveryAddress(_ setAddress: String) {
        address = setAddress
        updateAddressLabels(setAddress: setAddress)
    }
}
