//
//  ViewController.swift
//  PhotoManager
//
//  Created by Andrii Pyvovarov on 11/20/19.
//  Copyright © 2019 Andrii Pyvovarov. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - IBOutlets
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    //MARK: - Private properties
    private var searchController = UISearchController(searchResultsController: nil)
    
    private lazy var dataFetcherService = DataFetcherService()
    
    private lazy var pictureArray : [Picture] = []
    private lazy var pagesCount: Int = 0
    
    private var collectionView: UICollectionView?
    
    //MARK: - Lyfecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        setupViewSearchController()
        getNewPhotos()
    }
    
    //MARK: - Private Methods
    private func setupViewSearchController(){
        searchController.searchBar.delegate = self
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }

    private func getNewPhotos(){
        dataFetcherService.fetchNewPhotos { [weak self] (photos) in
                   guard let photos = photos else {return}
                   self?.pagesCount = 3
                   self?.pictureArray = self!.sliceArray(photos: photos, pageCount: 3)
                   self?.pageControl.numberOfPages = self!.pagesCount
                   self!.pageControl.currentPage = 0

                   DispatchQueue.main.async {
                       self?.collectionView?.reloadData()
                   }
               }
    }
    private func getSearchPhotos(query: String){
        dataFetcherService.fetchSearchPhotos(query: query) { [weak self] (photos) in
            guard let photos = photos else {return}
            self?.pictureArray = []
            self?.pictureArray = self!.sliceArray(photos: photos.results, pageCount: 3)
            self?.pagesCount = 3
            self?.pageControl.numberOfPages = self!.pagesCount

            DispatchQueue.main.async {
                self?.collectionView?.reloadData()
            }
        }
    }
    private func sliceArray(photos: [pictureelement], pageCount : Int) -> [Picture]{
        var arrayOfPhotos : [Picture] = []
        for i in 0..<pageCount {
            let arrayOfPhoto : [pictureelement] = Array(photos[i*6...(i*6+5)])
            arrayOfPhotos.append(arrayOfPhoto)
        }
        return arrayOfPhotos
    }
    private func setupViews() {
        
        navigationItem.title = "PhotoViewer"
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let frame = CGRect.init(x: 0, y: self.navigationController?.navigationBar.frame.height ?? 45,
                                width: self.view.frame.width, height: self.view.frame.height)
        
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView?.isPagingEnabled = true
        collectionView?.translatesAutoresizingMaskIntoConstraints = false
        collectionView?.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: String(describing: MainCollectionViewCell.self))
        
        view.addSubview(collectionView!)
        collectionView?.delegate = self
        collectionView?.dataSource = self
        
        collectionView?.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        collectionView?.rightAnchor.constraint(equalTo:  view.rightAnchor).isActive = true
        collectionView?.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        collectionView?.bottomAnchor.constraint(equalTo: pageControl.topAnchor).isActive = true
    }
}

//MARK: - UICollectionViewDataSource

extension ViewController : UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return pagesCount
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MainCollectionViewCell.self), for: indexPath) as? MainCollectionViewCell {
            cell.imagesArr = pictureArray[indexPath.row]
            return cell
        }
        
        return UICollectionViewCell()
    }
}

//MARK: - UICollectionViewDelegate

extension ViewController : UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = collectionView.frame.size
        return CGSize(width: size.width, height: size.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
             return 0.0
         }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
             return 0.0
         }
}

//MARK: - UIScrollViewDelegate

extension ViewController {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        pageControl.currentPage = Int(scrollView.contentOffset.x) / Int(scrollView.frame.width)
    }
}
//MARK: - UISearchBarDelegate

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
            getSearchPhotos(query: searchBar.text!)
    }
}
