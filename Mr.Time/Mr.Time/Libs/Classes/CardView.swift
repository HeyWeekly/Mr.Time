//
//  CardView.swift
//  Pods
//
//  Created by MILLMAN on 2016/9/20.
//
//

import UIKit

public class CardView: UIView {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(collectionView)
    }
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    fileprivate var isFilterMode = false

    fileprivate var filterSet = [Int]()
    var filterArr = [AnyObject]()
    fileprivate var cardArr = [AnyObject]() {
        didSet {
            self.collectionView.reloadData()
            if cardArr.count > 0 {
                filterSet = Array(0...cardArr.count-1)
            }
            filterArr.removeAll()
            filterArr += cardArr
        }
    }
    fileprivate var transition = CustomFlipTransition(duration: 0.3)
    lazy var collectionView:UICollectionView = {
        let layout = CustomCardLayout()
        let c = UICollectionView.init(frame: self.bounds, collectionViewLayout: layout)
        c.delegate = self
        c.backgroundColor = UIColor.clear
        return c
    }()

    public func set(cards:[AnyObject]) {
        cardArr.removeAll()
        cardArr += cards
    }
    
    public func filterAllDataWith(isInclued:@escaping (Int,AnyObject) -> Bool) {
     
        DispatchQueue.main.async {
            var removeIdx = [Int]()
            var insertIdx = [Int]()
            for (idx,value) in self.cardArr.enumerated() {
                let rc = isInclued(idx,value)
                
                if !rc && self.filterSet.contains(idx) {
                    let i = self.filterSet.index(of: idx)!
                    removeIdx.append(i)
                } else if rc && !self.filterSet.contains(idx){
                    insertIdx.append(idx)
                }
            }
            self.filterArr = self.filterArr.enumerated().filter { !removeIdx.contains($0.offset)}.map {$0.element}
            self.filterSet = self.filterSet.enumerated().filter { !removeIdx.contains($0.offset)}.map {$0.element}
            let removePaths = removeIdx.map { IndexPath.init(row: $0, section: 0) }
            self.collectionView.performBatchUpdates({
                self.collectionView.deleteItems(at: removePaths)
            }) { (finish) in
                var add = self.filterSet + insertIdx
                var insertPath = [IndexPath]()
                if insertIdx.count > 0 {
                    insertPath += Array(self.filterSet.count...add.count-1).map {IndexPath.init(row: $0, section: 0)}
                }
                self.filterArr = add.map {self.cardArr[$0]}
                self.filterSet = add
                
                
                self.collectionView.performBatchUpdates({
                    self.collectionView.insertItems(at: insertPath)
                    }, completion: { (finish) in
                        
                        if self.filterArr.count == 1 {
                            self.selectAt(index: 0)
                        } else {
                            self.selectAt(index: -1)
                        }

                        if insertIdx.count == 0 || !finish {
                            return
                        }
                        add = add.enumerated().sorted(by: {$0.0.element < $0.1.element}).map {$0.element}
                        let value:[(IndexPath,IndexPath)] = self.filterSet.enumerated().map {
                            let from = IndexPath.init(row: $0.offset, section: 0)
                            let to = IndexPath.init(row: add.index(of: $0.element)!, section: 0)
                            return (from , to)
                        }
                        self.filterSet = add
                        self.filterArr = add.map {self.cardArr[$0]}

                        self.collectionView.performBatchUpdates({
                            for (from,to) in value {

                                self.collectionView.moveItem(at: from, to: to)
                            }

                            }, completion: { (finish) in
                                
                                let sortsCell = self.collectionView.visibleCells.sorted(by: { (cell1, cell2) -> Bool in
                                    let path1 = self.collectionView.indexPath(for: cell1)
                                    let path2 = self.collectionView.indexPath(for: cell2)
                                    return path1!.row < path2!.row
                                })
                                
                                
                                for (index,cell) in sortsCell.enumerated() {
                                    cell.removeFromSuperview()
                                    self.collectionView.insertSubview(cell, at: index)
                                }                                
                        })
                })
            }
        }
    }
    
    public func showAllData() {
        self.filterAllDataWith { _,_ in true}
    }
    
    public func showStyle(style:Int) {
        DispatchQueue.main.async { 
            if let custom = self.collectionView.collectionViewLayout as? CustomCardLayout {
                custom.showStyle = style
            }            
        }
    }
    
    public func presentViewController(to vc:UIViewController) {
        if let custom = collectionView.collectionViewLayout as? CustomCardLayout ,custom.selectIdx == -1{
            print ("You need select a cell")
            return
        }

        let current = UIViewController.currentViewController()
        vc.transitioningDelegate = self
        vc.modalPresentationStyle = .custom
        current.present(vc, animated: true, completion: nil)
    }

    public func registerCardCell(c:AnyClass,nib:UINib) {
        if (c.alloc().isKind(of: CardCell.classForCoder())) {
            let identifier = c.value(forKey: "cellIdentifier") as! String
            collectionView.register(nib, forCellWithReuseIdentifier: identifier)
        } else {
            NSException(name: NSExceptionName(rawValue: "Cell type error!!"), reason: "Need to inherit CardCell", userInfo: nil).raise()
        }
    }
    
    public func registerCardCell(identifier:String,nib:UINib) {
        collectionView.register(nib, forCellWithReuseIdentifier: identifier)
    }
    
    public func registerCardCell(c:AnyClass, identifier:String) {
        collectionView.register(c, forCellWithReuseIdentifier: identifier)
    }
    
    public func expandBottomCount(count:Int) {
        if let layout = self.collectionView.collectionViewLayout as? CustomCardLayout {
            layout.bottomShowCount = count
        }
    }
    
    public func setCardTitleHeight(heihgt:CGFloat) {
        DispatchQueue.main.async {
            if let layout = self.collectionView.collectionViewLayout as? CustomCardLayout {
                layout.titleHeight = heihgt
            }
        }
    }
    
    public func setCardHeight(height:CGFloat) {
        DispatchQueue.main.async {
            if let layout = self.collectionView.collectionViewLayout as? CustomCardLayout {
                layout.cellSize = CGSize.init(width: layout.cellSize.width, height: height)
                layout.invalidateLayout()
            }
        }
    }
    
    public func removeCard(at index:Int) {
        if index > -1 {
            self.collectionView.performBatchUpdates({
                self.filterArr.remove(at: index)
                self.collectionView.deleteItems(at: [IndexPath.init(item: index, section: 0)])

            }, completion: { (finish) in
                if !finish {
                    return
                }

                if let layout = self.collectionView.collectionViewLayout as? CustomCardLayout {
                    layout.selectIdx = -1
                }
                
                let realIdx = self.filterSet[index]
                self.filterSet.remove(at: index)
                self.cardArr.remove(at: realIdx)
            })
        }
    }
    
    public func removeSelectCard() {
        let idx = currentIdx()
        self.removeCard(at: idx)
    }

    public func currentIdx() -> Int {
        if let custom = collectionView.collectionViewLayout as? CustomCardLayout {
           return custom.selectIdx
        }
        return -1
    }

    fileprivate func selectAt(index:Int) {
        if let custom = collectionView.collectionViewLayout as? CustomCardLayout {
            custom.selectIdx = index
        }
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        if let layout = collectionView.collectionViewLayout as? CustomCardLayout {
            layout.updateCellSize()
            layout.invalidateLayout()
        }
    }

}

extension CardView:UICollectionViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.selectAt(index: indexPath.row)
    }
}

extension CardView:UIViewControllerTransitioningDelegate{

    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Present
        if let custom = collectionView.collectionViewLayout as? CustomCardLayout {
            transition.cardView = self.collectionView.cellForItem(at: IndexPath.init(row: custom.selectIdx, section: 0))
            custom.isFullScreen = true
        }
        return transition
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        transition.transitionMode = .Dismiss
        if let custom = collectionView.collectionViewLayout as? CustomCardLayout {
            custom.isFullScreen = false
        }
        return transition
    }
}
