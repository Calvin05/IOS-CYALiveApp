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
        setUpEvents()
        setUpSearchBar()
        alterLayout()
        
        setBottomBar()
        viewConstraint()
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {

        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }

        super.viewWillAppear(animated)
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
        
        tableView.tableHeaderView = UIView()
        // search bar in section header
        tableView.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search"
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["LATEST", "UPCOMING", "LIVE NOW", "MY EVENTS"]
       
        searchBar.barTintColor = UIColor.cyaLightGrayBg
        searchBar.tintColor = UIColor.clear
        
        
        
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
        
        tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 110).isActive = true
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
        return 320
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


