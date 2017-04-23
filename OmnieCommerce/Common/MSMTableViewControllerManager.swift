//
//  MSMTableViewControllerManager.swift
//  OmnieCommerce
//
//  Created by msm72 on 04.03.17.
//  Copyright © 2017 Omniesoft. All rights reserved.
//

import UIKit

class MSMTableViewControllerManager: BaseViewController {
    // MARK: - Properties
    var sectionsCount = 0
    var dataSourceFiltered = [Any]()
    var expandedCells = [IndexPath]()
    var isSearchBarActive: Bool = false
    var refreshControl: UIRefreshControl?
    var footerViewHeight: CGFloat = 60.0
    var isLoadMore = false
    var dataSource = [Any]()
    var emptyText: String!
    
    weak var tableView: MSMTableView? {
        didSet {
            tableView!.rowHeight = UITableViewAutomaticDimension
        }
    }
    
    var handlerSelectRowCompletion: HandlerPassDataCompletion?
    var handlerSendButtonCompletion: HandlerSendButtonCompletion?
    var handlerCancelButtonCompletion: HandlerCancelButtonCompletion?
    var handlerPullRefreshCompletion: HandlerSendButtonCompletion?
    var handlerInfiniteScrollCompletion: HandlerSendButtonCompletion?
    
    
    // MARK: - Class Initialization
    init(withTableView tableView: MSMTableView, andSectionsCount sections: Int, andEmptyMessageText text: String) {
        super.init(nibName: nil, bundle: nil)
        
        self.tableView = tableView
        self.sectionsCount = sections
        self.emptyText = text
        self.tableView!.tableFooterView = (text.contains(" list is empty")) ? MSMTableViewFooterView.init(frame: CGRect.init(origin: .zero, size: CGSize.init(width: tableView.frame.width, height: footerViewHeight))) : nil

        if (emptyText != "DropDownList") {
            self.pullRefreshDidCreate()
        }
        
        if (tableView.hasHeaders) {
            // Register the Nib header/footer section views
            let headerIdentifier = tableView.headears!.first!.cellIdentifier
            tableView.register(UINib(nibName: headerIdentifier, bundle: nil), forHeaderFooterViewReuseIdentifier: headerIdentifier)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Class Functions
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        print(object: "\(type(of: self)): \(#function) run in [line \(#line)]. UIScrollView.contentOffset.y = \(scrollView.contentOffset.y)")
        
        self.tableView!.setScrollIndicatorColor(color: UIColor.veryLightOrange)
        
        // Set Infinite Scroll
        guard isNetworkAvailable else {
            return
        }
        
        if (!self.tableView!.hasHeaders && (self.dataSource.count + self.dataSourceFiltered.count > 0)) {
            if (emptyText != "DropDownList") {
                if (scrollView.contentOffset.y >= footerViewHeight && !isLoadMore) {
                    isLoadMore = !isLoadMore
                    
                    // Refresh FooterView
                    self.tableView!.beginUpdates()
                    self.tableView!.tableFooterView?.isHidden = false
                    
                    (self.tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: dataSource.count,
                                                                                           andEmptyText: "Services list is empty")
                    
                    self.tableView!.endUpdates()
                    
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
                        self.handlerInfiniteScrollCompletion!()
                    }
                }
            }            
        }
    }
    
    
    // MARK: - Custom Functions
    private func pullRefreshDidCreate() {
        if (!tableView!.hasHeaders) {
            refreshControl = UIRefreshControl()
            refreshControl!.tintColor = UIColor.init(hexString: "#dedede", withAlpha: 1.0)
            refreshControl!.attributedTitle = NSAttributedString(string: "Loading Data".localized(),
                                                                 attributes: [NSFontAttributeName:  UIFont(name: "Ubuntu-Light", size: 12.0)!,
                                                                              NSForegroundColorAttributeName: UIColor.veryLightGray])
            
            if #available(iOS 10.0, *) {
                tableView!.refreshControl = refreshControl!
            } else {
                tableView!.addSubview(refreshControl!)
            }
            
            refreshControl!.addTarget(self, action: #selector(handlerPullRefresh), for: .valueChanged)
        }
    }
    
    func pullRefreshDidFinish() {
        refreshControl!.endRefreshing()
        isLoadMore = false
    }
    
    func handlerPullRefresh(refreshControl: UIRefreshControl) {
        guard isNetworkAvailable else {
            refreshControl.endRefreshing()
            return
        }
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 2) {
            self.handlerPullRefreshCompletion!()
        }
    }
}


// MARK: - UITableViewDataSource
extension MSMTableViewControllerManager: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionsCount
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if (self.tableView!.hasHeaders) {
            return (self.tableView!.headears![section].isExpanded) ? (dataSource as! [[Any]])[section].count : 0
        }
        
        return (isSearchBarActive) ? dataSourceFiltered.count : dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cellIdentifier: String!

        if (self.tableView!.hasHeaders) {
            cellIdentifier = ((dataSource[indexPath.section] as! [Price])[indexPath.row] as InitCellParameters).cellIdentifier
        } else {
            cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        }
        
        self.tableView!.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)

        let cell = self.tableView!.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
        var item: Any!
        
        if (self.tableView!.hasHeaders) {
            item = (dataSource[indexPath.section] as! [Price])[indexPath.row]
        } else {
            item = (isSearchBarActive) ? dataSourceFiltered[indexPath.row] : dataSource[indexPath.row]
        }
        
        switch cell {
        case cell as UserTemplateTableViewCell:
            let userTemplateCell = (cell as! UserTemplateTableViewCell)
            
            // Show Expanded Cells
            if (expandedCells.count > 0) {
                userTemplateCell.isExpanded = expandedCells.contains(indexPath)
                userTemplateCell.expandButton.setImage(UIImage.init(named: (userTemplateCell.isExpanded) ? "icon-cell-expand-on-normal" : "icon-cell-expand-off-normal"),
                                                                    for: .normal)
            }

            // Handler Expanded Button tap
            userTemplateCell.handlerSendButtonCompletion = { _ in
                if (userTemplateCell.isExpanded) {
                    self.expandedCells.append(indexPath)
                    
                    self.tableView!.beginUpdates()

                    // Redraw Dotted Border View
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.0) {
                        userTemplateCell.dottedBorderView.setNeedsDisplay()
                    }
                    
                    self.tableView!.endUpdates()
                }
                
                guard self.expandedCells.count > 0 else {
                    return
                }
                
                if (!userTemplateCell.isExpanded) {
                    self.expandedCells.remove(at: self.expandedCells.index(where: { $0 == indexPath })!)
                    
                    self.tableView!.beginUpdates()
                    
                    // Redraw Dotted Border View
                    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.3) {
                        userTemplateCell.dottedBorderView.setNeedsDisplay()
                    }
                    
                    self.tableView!.endUpdates()
                }
            }
            
        case cell as FavoriteOrganizationTableViewCell:
            let favoriteOrganizationCell = cell as! FavoriteOrganizationTableViewCell
            
            // Handler Favorite Button tap
            favoriteOrganizationCell.handlerFavoriteButtonTapCompletion = { organizationID in
                let organization = (self.dataSource as! [Organization]).first(where: { $0.codeID == organizationID as! String })!
                let organizationIndex = (self.dataSource as! [Organization]).index(of: organization)!
                var organizationsList = self.dataSource as! [Organization]
                
                // Delete selected row from table view
                organizationsList.remove(at: organizationIndex)
                self.dataSource = organizationsList
                self.tableView!.beginUpdates()

                if (self.dataSource.count == 0) {
                    self.tableView!.tableFooterView?.isHidden = false
                    (self.tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: 0,
                                                                                           andEmptyText: "Organizations list is empty")
                }

                self.tableView!.deleteRows(at: [IndexPath(row: organizationIndex, section: 0)], with: .left)
                self.tableView!.endUpdates()
            }

        case cell as FavoriteServiceTableViewCell:
            let favoriteServiceCell = cell as! FavoriteServiceTableViewCell
            
            // Handler Favorite Button tap
            favoriteServiceCell.handlerFavoriteButtonTapCompletion = { serviceID in
                let service = (self.dataSource as! [Service]).first(where: { $0.codeID == serviceID as! String })!
                let serviceIndex = (self.dataSource as! [Service]).index(of: service)!
                var servicesList = self.dataSource as! [Service]
                
                // Delete selected row from table view
                servicesList.remove(at: serviceIndex)
                self.dataSource = servicesList
                
                if (self.dataSource.count == 0) {
                    self.tableView!.tableFooterView?.isHidden = false
                    (self.tableView!.tableFooterView as! MSMTableViewFooterView).didUpload(forItemsCount: 0,
                                                                                           andEmptyText: "Services list is empty")
                }
                
                self.tableView!.beginUpdates()
                self.tableView!.deleteRows(at: [IndexPath(row: serviceIndex, section: 0)], with: .left)
                self.tableView!.endUpdates()
                
                self.tableView!.reloadData()
            }

            
//        case cell as AvatarTableViewCell:
//            let avatarCell  =   (cell as! AvatarTableViewCell)
//            
//            // Handler show UIImagePickerController
//            avatarCell.handlerNewViewControllerShowCompletion   =   { imagePicker in
//                self.present(imagePicker, animated: true, completion: nil)
//            }
//
//        case cell as ActionButtonsTableViewCell:
//            let actionButtonsCell   =   (cell as! ActionButtonsTableViewCell)
//            
//            // Handler Save Button tap
//            actionButtonsCell.handlerSendButtonCompletion       =   { _ in
//                self.handlerSendButtonCompletion!()
//            }
//
//            // Handler Cancel Button tap
//            actionButtonsCell.handlerCancelButtonCompletion     =   { _ in
//                self.handlerCancelButtonCompletion!()
//            }
            
        default:
            break
        }
        
        // Config cell
        (cell as! ConfigureCell).setup(withItem: item, andIndexPath: indexPath)
        
        return cell
    }
}


// MARK: - UITableViewDelegate
extension MSMTableViewControllerManager: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if (self.tableView!.hasHeaders) {
            // TODO: - ADD HANDLERS
            
        } else {
            handlerSelectRowCompletion!((isSearchBarActive) ? dataSourceFiltered[indexPath.row] : dataSource[indexPath.row])
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        var height: CGFloat!
        var cellIdentifier: String!
        
        if (self.tableView!.hasHeaders) {
            height = ((dataSource[indexPath.section] as! [Price])[indexPath.row] as InitCellParameters).cellHeight
            cellIdentifier = ((dataSource[indexPath.section] as! [Price])[indexPath.row] as InitCellParameters).cellIdentifier
        } else {
            height = (dataSource[indexPath.row] as! InitCellParameters).cellHeight
            cellIdentifier = (dataSource[indexPath.row] as! InitCellParameters).cellIdentifier
        }

        if (cellIdentifier == "UserTemplateTableViewCell") {
            self.tableView!.estimatedRowHeight = 290.0
            self.tableView!.rowHeight = UITableViewAutomaticDimension

            return self.tableView!.rowHeight
        }
        
        return height
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        if (!self.tableView!.hasHeaders) {
            let cell = tableView.cellForRow(at: indexPath)!
            cell.contentView.backgroundColor = .veryDarkGrayishBlue38
        }
    }
    
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        if (!self.tableView!.hasHeaders) {
            let cell = tableView.cellForRow(at: indexPath)!
            cell.contentView.backgroundColor = .clear
        }
    }
        
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return (self.tableView!.hasHeaders) ? self.tableView!.headears!.first!.cellHeight : 0.0
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if (self.tableView!.hasHeaders) {
            let headerIdentifier = self.tableView!.headears!.first!.cellIdentifier
            var headerView: UITableViewHeaderFooterView?
            
            switch headerIdentifier {
            case "ExpandedTableViewHeaderView":
                headerView = self.tableView!.dequeueReusableHeaderFooterView(withIdentifier: headerIdentifier)
                
                let item = self.tableView!.headears![section]
                (headerView as! ExpandedTableViewHeaderView).setup(withItem: item, andIndexPath: IndexPath(item: 0, section: section))

                // Handler Header view tap
                (headerView as! ExpandedTableViewHeaderView).handlerExpandButtonTapCompletion = { isExpanded in
                    _ = self.tableView!.headears!.filter({ $0.name == item.name }).map { $0.isExpanded = isExpanded as! Bool }
                    self.tableView!.reloadSections(NSIndexSet(index: section) as IndexSet, with: .fade)
                }
                
                return headerView!
                
            default:
                break
            }
        }
        
        return nil
    }
}


// MARK: - UISearchBarDelegate
extension MSMTableViewControllerManager: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // TODO: - ADD API TO SEARCH ORGANIZATIONS
        handlerSendButtonCompletion!()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarActive = false
        searchBar.text = nil
        
        handlerCancelButtonCompletion!()
        tableView!.reloadData()
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        isSearchBarActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        isSearchBarActive = false
    }
    
    func searchBarBookmarkButtonClicked(_ searchBar: UISearchBar) {
        isSearchBarActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        dataSourceFiltered = (searchText.isEmpty) ? dataSource : dataSource.filter{ ($0 as! SearchObject).name.contains(searchBar.text!) }
        
        tableView!.reloadData()
    }
}
