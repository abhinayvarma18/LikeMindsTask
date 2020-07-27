//
//  NewContactViewController.swift
//  Wassup
//
//  Created by abhinay varma on 27/07/20.
//  Copyright © 2020 abhinay varma. All rights reserved.
//

import Foundation
import UIKit

class NewContactViewController:UIViewController {
    @IBOutlet weak var newContactsTableView: UITableView!
    var contacts:[Contact] = [] {
        didSet {
            newContactsTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        contacts = DatabaseManager.shared.getContacts()
        navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        setupTableView()
        FirebaseChatManager.shared.getUsers(completion: { [weak self](contact) in
            if contact != nil {
                self?.contacts.append(contact!)
            }
        })
    }
    
    private func setupTableView() {
        newContactsTableView.dataSource = self
        newContactsTableView.delegate = self
        newContactsTableView.register(UINib(nibName: "NewContactTableViewCell", bundle: nil), forCellReuseIdentifier: "NewContactTableViewCell")
        newContactsTableView.separatorStyle = .none
        self.newContactsTableView.reloadData()
    }
}

extension NewContactViewController:UITableViewDataSource,UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewContactTableViewCell", for: indexPath) as? NewContactTableViewCell
        cell?.profileImageView.layer.masksToBounds = false
        cell?.profileImageView.layer.cornerRadius = (cell?.profileImageView.bounds.size.width ?? 0.0)/2.0
        cell?.profileImageView.clipsToBounds = true
        cell?.updateCell(contact: contacts[indexPath.row])
        return cell ?? UITableViewCell()
    }
    
}
