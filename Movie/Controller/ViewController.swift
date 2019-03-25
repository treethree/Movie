//
//  ViewController.swift
//  Movie
//
//  Created by SHILEI CUI on 3/21/19.
//  Copyright © 2019 scui5. All rights reserved.
//

//for UISearchController
extension ViewController: UISearchResultsUpdating {
    // MARK: - UISearchResultsUpdating Delegate
    func updateSearchResults(for searchController: UISearchController) {
        if isFiltering(){
            filterContentForSearchText(searchController.searchBar.text!)
        }else{
           colView.reloadData()
        }
    }
}

import UIKit

var filteredMovie = [Result]()

var loadNewData : Bool = false

class ViewController: UIViewController ,UICollectionViewDataSource, UICollectionViewDelegate, UIScrollViewDelegate{

    @IBOutlet weak var colView: UICollectionView!
    
    var json_arr : Array<Result> = [] {
        didSet{
            DispatchQueue.main.async {
                self.colView.delegate = self
                self.colView.dataSource = self
                self.updateSearchResults(for: self.searchController)
                self.colView.reloadData()
                //update UI like table reloading
            }
        }
    }
    
    
    let searchController = UISearchController(searchResultsController: nil)
    
    var searchText : String?
    
    var i = 1
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search"
        
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search Movies"
        searchController.hidesNavigationBarDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isFiltering(){
            return filteredMovie.count
        }
        return json_arr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colView.dequeueReusableCell(withReuseIdentifier: "collectionCell", for: indexPath) as? CustomCollectionViewCell
        
        let obj : Result
        
        if isFiltering(){
                obj = filteredMovie[indexPath.row]
        }else{
                obj = json_arr[indexPath.row]
        }
        
        cell?.lblView.text = obj.title

        //Add disptachQueue
        DispatchQueue.global().async {
            let imgPath = obj.posterPath
            if let uwImgPath = imgPath{
                let imgURL = URL(string: "https://image.tmdb.org/t/p/w185/\(uwImgPath)")
                if let uwImgURL = imgURL{
                        let imgdata = try? Data(contentsOf: uwImgURL)
                        DispatchQueue.main.async {
                            //imgdata is nil
                            if imgdata != nil{
                                cell?.imgView.image = UIImage(data: imgdata!)
                            }else{
                                print("imdata is nil!!!")
                            }
                        }
                }
                else{
                    print("Ayaya")
                }
            }else{
                print("Opps")
                DispatchQueue.main.async {
                    cell?.imgView.image = UIImage(named: "no_image")
                }
            }
        }
        return cell!
    }

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        //Detect scroll view bottom reached
        if (scrollView.contentOffset.y + 1) >= (scrollView.contentSize.height - scrollView.frame.size.height) {
            loadNewData = true
            i += 1
            getApiForMovies(searchQuery: self.searchText!, pageNum: i)

        }else{
            print("do nothing")
        }
    }
    
    func getApiForMovies(searchQuery : String, pageNum : Int) {
        Apihandler.sharedInstance.getApiForMovies (searchQuery: searchQuery, page: pageNum) {(movies, error) in
            if error == nil{
                if let arr = movies{
                    if !loadNewData{
                        self.json_arr = arr
                    }else{
                        self.json_arr.append(contentsOf: arr)
                    }
                }
            }
        }
    }
    
    func filterContentForSearchText(_ searchText: String, scope: String = "All") {
            filteredMovie = json_arr.filter({( movie : Result) -> Bool in
                return (movie.title.lowercased().contains(searchText.lowercased()))
            })
            colView.reloadData()
    }
    func searchBarIsEmpty() -> Bool {
        // Returns true if the text is empty or nil
        return searchController.searchBar.text?.isEmpty ?? true
    }
    func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    
    
    @IBAction func submitBtn(_ sender: UIBarButtonItem) {
        //i is page number
        i = 1
        json_arr = []
        searchText = self.searchController.searchBar.text!
        //searchText?.lowercased()
        if !searchBarIsEmpty(){
            self.getApiForMovies(searchQuery: self.searchText!, pageNum: 1)
            //searchController.searchBar.resignFirstResponder()
        }
        colView.reloadData()
    }
}

