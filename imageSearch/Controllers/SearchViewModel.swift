//
//  SearchViewModel.swift
//  imageSearch
//
//  Created by Sergio Orozco  on 3/27/19.
//  Copyright © 2019 nothing. All rights reserved.
//

import Foundation


public protocol SearchViewModelType: class {
    var gallery: [GalleryItem]? {get set}
    func loadGallery(completion: @escaping (_ success: Bool) -> Void)
    func getCurrentPage() -> Int
    func resetPage()
    func setText(_ text: String)
    func resetText()
    func moveToNextPage()
    func getItemAt(index: Int) -> GalleryItem?
    func getItemsCount() -> Int
}

class SearchViewModel: SearchViewModelType, GalleryServices {
    var gallery: [GalleryItem]?
    var currentPage = 1
    var currentText: String?
    
    func loadGallery(completion: @escaping (Bool) -> Void) {
        
        guard let text = currentText else { return }
        
        getGallerySearch(search: text, page: getCurrentPage()) { [weak self] (reponse, error) in
            if let _ = error {
                completion(false)
                return
            }
            self?.addNew(items: reponse?.data)
            completion(true)
        }
    }
    
    private func addNew(items: [GalleryItem]?) {
        guard let newItems = items, newItems.count > 0 else { return }
        
        if getCurrentPage() <= 1 {
            self.gallery = newItems
            return
        }
        
        guard var currentGallery = self.gallery else {
            return
        }
        
        currentGallery.append(contentsOf: newItems)
        self.gallery = currentGallery
    }
    
    func getCurrentPage() -> Int {
        return currentPage
    }
    
    func moveToNextPage() {
        currentPage += 1
    }
    
    func getItemAt(index: Int) -> GalleryItem? {
        if getItemsCount() > 0 {
            return gallery?[index]
        }
        return nil
    }
    
    func resetPage() {
        currentPage = 1
    }
    
    func getItemsCount() -> Int {
        guard let items = gallery else { return 0 }
        return items.count
    }
    
    func setText(_ text: String) {
        currentText = text
    }
    
    func resetText() {
        currentText = nil
        gallery?.removeAll()
    }
    
}
