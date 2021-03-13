//
//  ListTableViewController.swift
//  VinuTask
//
//  Created by Vinu on 12/03/21.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var listArr = [Details]()
    
    var page = 1
    
    var isFetching = false
    
    var cardListArr = [Person]()
        
    lazy var loaderMoreView: UIView = {
        let loaderView = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.medium)
        loaderView.color = UIColor.gray
        loaderView.startAnimating()
        return loaderView
    }()
    
    lazy var alertView : UIAlertController = {
        let alView = UIAlertController(title: nil, message: "Loading...", preferredStyle: .alert)
        alView.view.tintColor = UIColor.black
        let loadingIndicator = UIActivityIndicatorView(frame: CGRect(x: 10, y: 5, width: 50, height: 50)) as UIActivityIndicatorView
        loadingIndicator.hidesWhenStopped = true
        loadingIndicator.style = UIActivityIndicatorView.Style.medium
        loadingIndicator.startAnimating();
        alView.view.addSubview(loadingIndicator)
        return alView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: self, action:nil)
        
        self.tableView.register(ListTbleVCell.nib, forCellReuseIdentifier: ListTbleVCell.identifier)
        
        self.present(alertView, animated: true) { [self] in
            getAPIResponse()
        }
        
       // self.creditCardStruct()
        
    }
    
    // MARK: - Credit Card Struct
    
    func creditCardStruct() {
        var person = Person(name: "Vinu", dob: "14/05/2000", aadhaarNo: "8976 34567 2345", panNo: "AEDR89756WD", card: [])
        for i in 0..<3 {
            person.card.append(CardDetails(cvvno: 354, cardNo:"6\(i)78 9\(i)87 54\(i)7 234\(i)", expiry: "1\(i)/2020", person: person))
        }
        cardListArr.append(person)
    }
    
    
    // MARK: - API Request & Response
    
    func getAPIResponse() {
        if isFetching {
            return
        }
        self.isFetching = true

        APIService.shared.getResponse(pageNo:page, responseType: [Details].self) { [self] (result) in
            switch result {
            case .success(let data):
                page += 1
                listArr.append(contentsOf: data)
                self.navigationItem.rightBarButtonItem?.title = "\(listArr.count)"
                tableView.reloadData()
            case .failure(_):
                print("error")
            }
            if self.isFetching {
                DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                 self.setUpLoaderView(toShow: false)
                }
            }
            self.isFetching = false
            self.dismiss(animated: true, completion: nil)
        }
    }
  
    func setUpLoaderView(toShow: Bool) {
        if toShow {
            self.tableView.tableFooterView?.isHidden = false
            self.tableView.tableFooterView = self.loaderMoreView
        } else {
            self.tableView.tableFooterView = UIView()
        }
    }
    

    // MARK: - Load More

    override func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.isFetching = false
        let currentOffset = scrollView.contentOffset.y
        let maximumOffset = scrollView.contentSize.height - scrollView.frame.size.height
        if maximumOffset - currentOffset <= 10.0 && !isFetching {
            self.setUpLoaderView(toShow: true)
            self.getAPIResponse()
        }
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listArr.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ListTbleVCell.identifier, for: indexPath) as! ListTbleVCell
        cell.setDetails(info:listArr[indexPath.row], index: indexPath.row)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "DetailsView", sender: indexPath.row)
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "DetailsView" {
            let detailV = segue.destination as! DetailViewController
            detailV.index = sender as? Int
            detailV.info = listArr[sender as! Int]
        }
    }
}
