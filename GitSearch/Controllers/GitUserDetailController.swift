//
//  GitUserDetailController.swift
//  GitSearch
//
//  Created by Amish on 19/10/19.
//  Copyright © 2019 Amish. All rights reserved.
//

import UIKit

class GitUserDetailController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var avatarImage: AsyncDownloadingImageView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var followersLabel: UILabel!
    @IBOutlet weak var followingsLabel: UILabel!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var bioLabel: UILabel!
    @IBOutlet weak var userName: UILabel!
    
    var profileURL: String?
    var repoURL: String?
    var userData: GitUser?
    var aryRepo: [RepoModelElement] = []
    var filterRepo: [RepoModelElement] = []
    var isSearching = false
    override func viewDidLoad() {
        super.viewDidLoad()
        tblView.dataSource = self
        tblView.delegate = self
        fetchRepoDetail()
        fetchProfileDetails()
    }
    
}

private extension GitUserDetailController {
    
    func fetchProfileDetails() {
        guard let url = URL(string: profileURL!) else { return }
        let httpMethod = NetworkManager.HttpMethod.get
        NetworkManager.sharedInstance.callWebservice(withUrl: url, httpMethod: httpMethod, parameters: nil, header: nil) { [weak self] (data, response, error) in
            
            guard let weakSelf = self else { return }
            
            if let err = error {
                Alert.showNormalAlertWith(message: err.localizedDescription)
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse, !data.isEmpty, httpResponse.statusCode == 200 {
                
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options:[]),
                    let jsonDict = json as? [String:Any],
                    let userData = try? JSONSerialization.data(withJSONObject: jsonDict, options: .prettyPrinted),
                    let user = try? JSONDecoder().decode(GitUser.self
                        , from: userData)
                else {
                    return
                }
                
                
                DispatchQueue.main.async {
                    weakSelf.userName.text = user.login
                    weakSelf.followersLabel.text = user.followers!.description
                    weakSelf.followersLabel.text = user.following!.description
                    weakSelf.avatarImage.loadImage(withImageURL: user.avatarURL, UIImage(systemName: "person.fill")!)
                    weakSelf.locationLabel.text = user.location
                    weakSelf.emailLabel.text = user.email
                    weakSelf.bioLabel.text = user.bio
                }
                
            }
            
        }
    }
    
    func fetchRepoDetail() {
        guard let url = URL(string: repoURL!) else { return }
        let httpMethod = NetworkManager.HttpMethod.get
        NetworkManager.sharedInstance.callWebservice(withUrl: url, httpMethod: httpMethod, parameters: nil, header: nil) { [weak self] (data, response, error) in
            
            guard let weakSelf = self else { return }
            
            if let err = error {
                Alert.showNormalAlertWith(message: err.localizedDescription)
            }
            
            if let data = data, let httpResponse = response as? HTTPURLResponse, !data.isEmpty, httpResponse.statusCode == 200 {
                
                guard
                    let json = try? JSONSerialization.jsonObject(with: data, options:[]),
                    let jsonDict = json as? [[String:Any]],
                    let repoData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []),
                    let repo = try? JSONDecoder().decode([RepoModelElement].self
                        , from: repoData)
                else {
                    return
                }
                
                weakSelf.aryRepo.removeAll()
                weakSelf.aryRepo = repo
                
                DispatchQueue.main.async {
                    weakSelf.tblView.reloadData()
                }
                
            }
            
        }
    }
}

extension GitUserDetailController: UITableViewDelegate, UITableViewDataSource  {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return aryRepo.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let repoCell = tblView.dequeueReusableCell(withIdentifier: "RepoCell") as! RepoCell
        repoCell.repoData = aryRepo[indexPath.row]
        return repoCell
    }
    
    
}

extension GitUserDetailController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if !isSearching {
            searchBar.showsCancelButton = true
        }
        
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.searchTextField.resignFirstResponder()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearching = false
        searchBar.searchTextField.resignFirstResponder()
    }
}
