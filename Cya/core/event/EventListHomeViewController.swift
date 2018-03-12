//
//  EventListHomeViewController.swift
//  Cya
//
//  Created by Rigo on 17/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class EventListHomeViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var tableView: UITableView!
    var viewContent: UIView = UIView()
    var headerContainer: UIView = UIView()
    var headerBackground: UIView = UIView()
    
    var isSearching = false
    
    var events = [Event]() //var animalArray = [Animal]()
    var filteredEvents =  [Event]() // var currentAnimalArray = [Animal]() //update table
    
    var toolBarMenu: ToolBarMenu = ToolBarMenu()
    var toolBarMenuBackground: UIView = UIView()
    var _eventService: EventService!
    var _eventType: Int?
    
    // MARK: - View Setup
    override func viewDidLoad() {
        super.viewDidLoad()
//        setupView()
        setUpEvents()
        setUpSearchBar()
        alterLayout()
        setBottomBar()
        viewConstraint()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
//        scrollTable(animatedScroll: false)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setBottomBar(){
        
        toolBarMenu.setCurrenView(currentView: "EventList")
        toolBarMenu.setParentView(parentView: self)
        view.addSubview(toolBarMenu)
        toolBarMenu.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        toolBarMenu.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        
        view.addSubview(toolBarMenuBackground)
        
        toolBarMenuBackground.translatesAutoresizingMaskIntoConstraints = false
        
        toolBarMenuBackground.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        toolBarMenuBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        toolBarMenuBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: 0).isActive = true
        toolBarMenuBackground.topAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: 0).isActive = true
        
        toolBarMenuBackground.backgroundColor = UIColor.darkGray
    }
    
   
    

    
    private func setUpSearchBar() {
        searchBar.delegate = self
        searchBar.returnKeyType = UIReturnKeyType.done
    }
    
    func alterLayout() {
        // Setup the Search Controller
        tableView.delegate = self
        tableView.dataSource = self
        
        // Setup the search footer
        tableView.tableFooterView = searchFooter
        
//        tableView.tableHeaderView = UIView()
        // search bar in section header
//        tableView.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
//        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search"
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["LATEST", "UPCOMING", "LIVE NOW", "MY EVENTS"]
       
        searchBar.barTintColor = UIColor.cyaLightGrayBg
        searchBar.tintColor = UIColor.clear
        
        
        tableView.tableHeaderView = self.searchBar
        scrollTable(animatedScroll: false)
        
        // Selected text
        let titleTextAttributesSelected = [NSAttributedStringKey.foregroundColor: UIColor.cyaMagenta, NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue, NSAttributedStringKey.underlineColor: UIColor.cyaMagenta] as [NSAttributedStringKey : Any]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesSelected, for: .selected)
        UISegmentedControl.appearance().backgroundColor = UIColor.clear
        
        // Normal text
        let titleTextAttributesNormal = [NSAttributedStringKey.foregroundColor: UIColor.cyaMagenta]
        UISegmentedControl.appearance().setTitleTextAttributes(titleTextAttributesNormal, for: .normal)
        
    }
    
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "showDetailEvent" {
            let idEventSelectes = sender as! Int
                let _eventDetail: EventDetail = segue.destination as! EventDetail
                _eventDetail.eventID = events[idEventSelectes].id!
        }
    }

    // MARK: - Private instance methods
    

    func  viewConstraint(){
        
        let marginGuide = view.layoutMarginsGuide
        
        tableView.register(ListEventsCell.self, forCellReuseIdentifier: "ListEventsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 0).isActive = true
        
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: -50).isActive = true
        
    }
    
    
}

    // MARK: - Table View
extension EventListHomeViewController {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListEventsCell", for: indexPath) as! ListEventsCell
        
        
        
        let event: Event
        if isSearching {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        
        
        
        if(event.roles?.count != 0){
            let layout = UICollectionViewFlowLayout()
            cell.avatarRoles = AvatarView(collectionViewLayout: layout, avatarArray: (event.roles)!)
            self.addChildViewController(cell.avatarRoles!)
            cell.contentRoles.addSubview(cell.avatarRoles!.view)
            
            cell.avatarRoles!.view.translatesAutoresizingMaskIntoConstraints = false
            
            cell.avatarRoles!.view.topAnchor.constraint(equalTo: cell.contentRoles.topAnchor, constant: 0).isActive = true
            cell.avatarRoles!.view.leftAnchor.constraint(equalTo: cell.contentRoles.leftAnchor, constant: 0).isActive = true
            cell.avatarRoles!.view.rightAnchor.constraint(equalTo: cell.contentRoles.rightAnchor, constant: 0).isActive = true
            cell.avatarRoles!.view.bottomAnchor.constraint(equalTo: cell.contentRoles.bottomAnchor, constant: 0).isActive = true
            cell.avatarRoles!.didMove(toParentViewController: self)
        }
        
        
        
        
        
        
        cell.titleEvent.text = events[indexPath.row].title!
        if (events[indexPath.row].start_at != nil ){
            cell.TimeEvent.text = NSString.convertFormatOfDate(date: events[indexPath.row].start_at!, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "EEEE, dd MMMM ,yyyy")
        }
        
        cell.imageAvatar.downloadedFrom(defaultImage: "thumb-logo", link: events[indexPath.row].thumbnail!)
        cell.descriptionEvent.text = events[indexPath.row].description
        
//        cell.selectionStyle = .none
//        cell.selectionStyle = UITableViewCellSelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        let event: Event
        if isSearching {
            event = filteredEvents[indexPath.row]
        } else {
            event = events[indexPath.row]
        }
        
        if(event.roles?.count == 0){
            return 320
        }else{
            return 420
        }
        
    }
    
    func scrollTable(animatedScroll: Bool){
        if (filteredEvents.count > 0){
            let indexPath = IndexPath(row: 0, section: 0)
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: false)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let eventSelected =  indexPath.row
        self.performSegue(withIdentifier: "showDetailEvent", sender: eventSelected)
    }
    

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            searchFooter.setIsFilteringToShow(filteredItemCount: filteredEvents.count, of: events.count)
            return filteredEvents.count
        }
        searchFooter.setNotFiltering()
        return filteredEvents.count
    }
}

extension EventListHomeViewController{
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            self.filteredEvents = self.events
            tableView.reloadData()
        }
        else {
            isSearching = true
            filterContentForSearchText(searchBar.text!)
        }

    }
//
    func filterContentForSearchText(_ searchText: String) {
        filteredEvents = events.filter({ _event -> Bool in
            return _event.title!.lowercased().contains(searchText.lowercased())
        })
        tableView.reloadData()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        switch selectedScope {
        // searchBar.scopeButtonTitles = ["LATEST", "UPCOMING", "LIVE NOW", "MY EVENTS"]
        case 0:
            filterEvents(offset: 0, limit: 50, state: 0)
        case 1:
            filterEvents(offset: 0, limit: 50, state: 1)
        case 2:
            filterEvents(offset: 0, limit: 50, state: 2)
        case 3:
            filterEvents(offset: 0, limit: 30, state: 3)
        default:
            break
        }
        tableView.reloadData()
        
        scrollTable(animatedScroll: false)
       
    }
    
    private func setUpEvents() {
        _eventService = EventService()
        let listItem = _eventService.getEventList(offset: 0, limit: 100, state: 0)
        self.events = listItem.items!
        
        self.filteredEvents = self.events
    }
    
    func filterEvents(offset: Int, limit: Int, state: Int) {
        let listItem = _eventService.getEventList(offset: offset, limit: limit, state: state)
        self.events = listItem.items!
        self.filteredEvents = self.events
    }
}

extension EventListHomeViewController {
    func setupView(){
        setViewContent()
        setHeader()
    }
    
    func setViewContent(){
        self.view.addSubview(viewContent)
        
        let marginGuide = view.layoutMarginsGuide
        
        viewContent.bottomAnchor.constraint(equalTo: marginGuide.bottomAnchor).isActive = true
        viewContent.topAnchor.constraint(equalTo: marginGuide.topAnchor, constant: -20).isActive = true
        viewContent.leftAnchor.constraint(equalTo: marginGuide.leftAnchor, constant: -20).isActive = true
        viewContent.rightAnchor.constraint(equalTo: marginGuide.rightAnchor, constant: 20).isActive = true
        viewContent.translatesAutoresizingMaskIntoConstraints       = false
        
        viewContent.backgroundColor = UIColor.white
    }
    
    func setHeader(){
    
        view.addSubview(headerContainer)
        view.addSubview(headerBackground)
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerBackground.translatesAutoresizingMaskIntoConstraints = false
        
        headerContainer.heightAnchor.constraint(equalToConstant: 50).isActive = true
        headerContainer.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 0).isActive = true
        headerContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        headerContainer.backgroundColor = UIColor.cyaMagenta
        
        
        headerBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerBackground.bottomAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 0).isActive = true
        headerBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        headerBackground.backgroundColor = UIColor.cyaMagenta
        
    }
}


