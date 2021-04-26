//
//  ViewPageTest.swift
//  ArgoKitDemo
//
//  Created by sun-zt on 2020/12/5.
//

import Foundation
import UIKit
import ArgoKit

class TestCollectionCell: UICollectionViewCell {
    
}

class ViewPageTest: UIViewController, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    private var collectionView:UICollectionView?
    
    override func viewDidLoad() {
        let layout = UICollectionViewFlowLayout()
        let collectionView1 = UICollectionView(frame: CGRect.init(x: 0, y: 100, width: 300, height: 200), collectionViewLayout: layout);
        
        layout.scrollDirection = .horizontal
        collectionView1.delegate = self
        collectionView1.dataSource = self
        collectionView1.isPagingEnabled = true
        collectionView1.alwaysBounceVertical = false
        collectionView1.alwaysBounceHorizontal = true
        collectionView1.showsVerticalScrollIndicator = false
        collectionView1.showsHorizontalScrollIndicator = false
        collectionView1.bouncesZoom = false
        collectionView1.bounces = false
        
        
        self.collectionView = collectionView1
        
        self.collectionView?.backgroundColor = UIColor.red
        
        collectionView1.register(TestCollectionCell.self, forCellWithReuseIdentifier: "abc")
        
        self.view.addSubview(collectionView1)
        
        self.view.backgroundColor = UIColor.white
        
        
//        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 0
        
        
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let view = collectionView.dequeueReusableCell(withReuseIdentifier: "abc", for: indexPath)
        if indexPath.row % 2 == 0 {
            view.contentView.backgroundColor = UIColor.gray
        }else {
            view.contentView.backgroundColor = UIColor.blue
        }
        
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width - 50, height: 200)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 25, bottom: 0, right: 25)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 50
    }
    
    
    private var isScrolling:Bool = false
    private var currentIndex:Int = 0
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.isScrolling = true
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isScrolling = decelerate
        scrollViewScrollEnd(scrollView)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.isScrolling = false
        scrollViewScrollEnd(scrollView)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        scrollViewScrollPercent(scrollView)
    }
    
    
    func scrollViewScrollPercent(_ scrollView: UIScrollView) {
        guard self.isScrolling else { return }
        let percentX = scrollView.contentOffset.x / scrollView.frame.width
        let toIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        
        
        
    }
    
    func scrollViewScrollEnd(_ scrollView: UIScrollView) {
        guard !self.isScrolling else { return }
        
        let toIndex:Int = Int(scrollView.contentOffset.x / scrollView.frame.width)
        
        NSLog("--%d", toIndex)
        
        
        
        self.currentIndex = toIndex
        
        
        
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.collectionView?.scrollToItem(at: NSIndexPath(item: 2, section: 0) as IndexPath, at: .centeredHorizontally, animated: true)
    }
    
}
