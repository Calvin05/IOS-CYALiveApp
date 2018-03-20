//
//  EventListHomeViewController.swift
//  Cya
//
//  Created by Rigo on 17/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
import SDWebImage


class EventListHomeViewController:UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Properties
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var searchFooter: SearchFooter!
    @IBOutlet weak var tableView: UITableView!
    var viewContent: UIView = UIView()
    
    var headerContainer: UIView = UIView()
    var headerBackground: UIView = UIView()
    var searchButton: UIButton = UIButton()
    var profileButton: UIButton = UIButton()
    var liveButton: UIButton = UIButton()
    var upComingButton: UIButton = UIButton()
    var pastButton: UIButton = UIButton()
    var searchContainer: UIView = UIView()
    var searchTextFiel: UITextField = UITextField()
    var searchActive: Bool = false
    var avatarImage: UIImageView = UIImageView()
    
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
        setupView()
        setUpEvents()
        setUpSearchBar()
        alterLayout()
        setBottomBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectionIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectionIndexPath, animated: animated)
        }
//        scrollTable(animatedScroll: false)
        profileButton.setImage(avatarImage.image, for: .normal)
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
//        tableView.estimatedSectionHeaderHeight = 50
        // search bar in navigation bar
//        navigationItem.titleView = searchBar
        searchBar.placeholder = "Search"
        searchBar.showsScopeBar = true
        searchBar.scopeButtonTitles = ["LATEST", "UPCOMING", "LIVE NOW", "MY EVENTS"]
       
        searchBar.barTintColor = UIColor.cyaLightGrayBg
        searchBar.tintColor = UIColor.clear
        
        
//        tableView.tableHeaderView = self.searchBar
//        scrollTable(animatedScroll: false)
        
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
    
    @objc func profile(){
        if(UserDisplayObject.username == ""){
            
            UserDisplayObject.token = ""
            UserDisplayObject.userId = ""
            UserDisplayObject.authorization = ""
            UserDisplayObject.avatar = ""
            UserDisplayObject.username = ""
            
            var HomeView: UIStoryboard!
            HomeView = UIStoryboard(name: "Auth", bundle: nil)
            let homeGo : UIViewController = HomeView.instantiateViewController(withIdentifier: "LoginSignupVC") as UIViewController
            
            self.show(homeGo, sender: nil)
        }else{
            let viewcontroller : GralInfoController = GralInfoController()
            self.show(viewcontroller, sender: nil)
        }
    }
    
    @objc func openCloseSearch(){
        if(searchActive){
            searchActive = false
            searchContainer.isHidden = true
        }else{
            searchActive = true
            searchContainer.isHidden = false
        }
    }
    
    @objc func selectFilterEvents(sender: UIButton){
        switch sender.tag {
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
    
    @objc func searchTextFieldDidChange(messageInput: UITextField){
        
        if (messageInput.text != nil && messageInput.text != "" && messageInput.text?.trimmingCharacters(in: .whitespaces) != ""){
            isSearching = true
            filteredEvents = events.filter({ _event -> Bool in
                return _event.title!.lowercased().contains(messageInput.text!.lowercased())
            })
            tableView.reloadData()
        }else{
            isSearching = false
            filteredEvents = events
            tableView.reloadData()
        }
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
            cell.contentRoles.subviews.forEach({ $0.removeFromSuperview() })
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
        
        cell.titleEvent.text = event.title
        
        if (event.start_at != nil ){
            cell.TimeEvent.text = NSString.convertFormatOfDate(date: event.start_at!, originalFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSZ", destinationFormat: "EEEE, dd MMMM ,yyyy")
        }
        
//        cell.imageAvatar.downloadedFrom(defaultImage: "thumb-logo", link: event.thumbnail!)
        cell.imageAvatar.sd_setImage(with: URL(string: event.thumbnail!), placeholderImage: UIImage(named: "thumb-logo"))
        cell.descriptionEvent.text = event.description
        
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
        setButtonsHeader()
        setSearch()
        setTable()
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
    
        viewContent.addSubview(headerContainer)
        view.addSubview(headerBackground)
        
        
        headerContainer.translatesAutoresizingMaskIntoConstraints = false
        headerBackground.translatesAutoresizingMaskIntoConstraints = false
        
        
        headerContainer.heightAnchor.constraint(equalToConstant: 45).isActive = true
        headerContainer.topAnchor.constraint(equalTo: viewContent.topAnchor, constant: 20).isActive = true
        headerContainer.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerContainer.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        headerContainer.backgroundColor = UIColor.cyaMagenta
        
        
        headerBackground.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        headerBackground.bottomAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 0).isActive = true
        headerBackground.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        headerBackground.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        headerBackground.backgroundColor = UIColor.cyaMagenta
    }
    
    func setButtonsHeader(){
        
        headerContainer.addSubview(searchButton)
        headerContainer.addSubview(liveButton)
        headerContainer.addSubview(upComingButton)
        headerContainer.addSubview(pastButton)
        headerContainer.addSubview(profileButton)
        
        
        searchButton.translatesAutoresizingMaskIntoConstraints = false
        liveButton.translatesAutoresizingMaskIntoConstraints = false
        upComingButton.translatesAutoresizingMaskIntoConstraints = false
        pastButton.translatesAutoresizingMaskIntoConstraints = false
        profileButton.translatesAutoresizingMaskIntoConstraints = false
        
        
        searchButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        searchButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        searchButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        searchButton.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 10).isActive = true
        
        searchButton.setImage(UIImage(named: "cya-search"), for: .normal)
        searchButton.imageView?.contentMode = .scaleAspectFit
        searchButton.imageEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        searchButton.addTarget(self, action: #selector(openCloseSearch), for: .touchUpInside)
        
        
        liveButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        liveButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        liveButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        liveButton.rightAnchor.constraint(equalTo: upComingButton.leftAnchor, constant: -10).isActive = true
        
        liveButton.titleLabel?.font = FontCya.CyaBody
        liveButton.setTitleColor(.white, for: .normal)
        liveButton.tag = 2
        liveButton.addTarget(self, action: #selector(selectFilterEvents), for: .touchUpInside)
        liveButton.setTitle("Live", for: .normal)
        
        
        upComingButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        upComingButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        upComingButton.widthAnchor.constraint(equalToConstant: 80).isActive = true
        upComingButton.centerXAnchor.constraint(equalTo: headerContainer.centerXAnchor, constant: -25).isActive = true
        
        upComingButton.titleLabel?.font = FontCya.CyaBody
        upComingButton.setTitleColor(.white, for: .normal)
        upComingButton.tag = 1
        upComingButton.addTarget(self, action: #selector(selectFilterEvents), for: .touchUpInside)
        upComingButton.setTitle("Upcoming", for: .normal)
        
        
        pastButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        pastButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        pastButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        pastButton.leftAnchor.constraint(equalTo: upComingButton.rightAnchor, constant: 10).isActive = true
        
        pastButton.titleLabel?.font = FontCya.CyaBody
        pastButton.setTitleColor(.white, for: .normal)
        pastButton.tag = 0
        pastButton.addTarget(self, action: #selector(selectFilterEvents), for: .touchUpInside)
        pastButton.setTitle("Past", for: .normal)
        
        
        profileButton.centerYAnchor.constraint(equalTo: headerContainer.centerYAnchor, constant: 0).isActive = true
        profileButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        profileButton.widthAnchor.constraint(equalToConstant: 30).isActive = true
        profileButton.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: -20).isActive = true
        
        avatarImage.sd_setImage(with: URL(string: UserDisplayObject.avatar), placeholderImage: UIImage(named: "cya-profile-gray-s"))
        
        profileButton.imageView?.contentMode = .scaleAspectFit
        profileButton.layer.cornerRadius = 15
        profileButton.layer.masksToBounds = true
        profileButton.addTarget(self, action: #selector(profile), for: .touchUpInside)
    }
    
    func setSearch(){
        
        headerContainer.addSubview(searchContainer)
        searchContainer.addSubview(searchTextFiel)
        
        searchContainer.isHidden = true
        
        searchContainer.translatesAutoresizingMaskIntoConstraints = false
        searchTextFiel.translatesAutoresizingMaskIntoConstraints = false
        
        
        searchContainer.topAnchor.constraint(equalTo: headerContainer.topAnchor, constant: 3).isActive = true
        searchContainer.bottomAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: -3).isActive = true
        searchContainer.rightAnchor.constraint(equalTo: headerContainer.rightAnchor, constant: -15).isActive = true
        searchContainer.leftAnchor.constraint(equalTo: searchButton.rightAnchor, constant: 0).isActive = true
        
        searchContainer.backgroundColor = UIColor.cyaLightGrayBg
        
        
        searchContainer.layer.masksToBounds = true
        searchContainer.layer.cornerRadius = 4
        
        
        searchTextFiel.topAnchor.constraint(equalTo: searchContainer.topAnchor, constant: 5).isActive = true
        searchTextFiel.bottomAnchor.constraint(equalTo: searchContainer.bottomAnchor, constant: -5).isActive = true
        searchTextFiel.rightAnchor.constraint(equalTo: searchContainer.rightAnchor, constant: -5).isActive = true
        searchTextFiel.leftAnchor.constraint(equalTo: searchContainer.leftAnchor, constant: 25).isActive = true
        
        searchTextFiel.backgroundColor = UIColor.white
        
        searchTextFiel.font = FontCya.CyaTitlesH5Light
        searchTextFiel.backgroundColor = UIColor.white
        searchTextFiel.placeholder = "Search Events"
        searchTextFiel.layer.masksToBounds = true
        searchTextFiel.borderStyle = UITextBorderStyle.bezel
        searchTextFiel.textColor = UIColor.black
        searchTextFiel.layer.borderWidth = 1
        searchTextFiel.layer.cornerRadius = 4
        searchTextFiel.layer.borderColor = UIColor.lightGray.cgColor
        
        searchTextFiel.addTarget(self, action: #selector(searchTextFieldDidChange), for: .editingChanged)
        
        
    }
    
    func setTable(){
        
        viewContent.addSubview(tableView)
        
        tableView.register(ListEventsCell.self, forCellReuseIdentifier: "ListEventsCell")
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        tableView.leftAnchor.constraint(equalTo: viewContent.leftAnchor, constant: 0).isActive = true
        tableView.rightAnchor.constraint(equalTo: viewContent.rightAnchor, constant: 0).isActive = true
        
        tableView.topAnchor.constraint(equalTo: headerContainer.bottomAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: viewContent.bottomAnchor, constant: -50).isActive = true
    }
    
}


