//
//  QuestionsViewController.swift
//  Cya
//
//  Created by josvan salvarado on 10/5/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit

class QuestionsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionsTable: UITableView!
    @IBOutlet weak var question: UITextField!
    let chatService: ChatService = ChatService(sessionId: "")
    
    @IBOutlet weak var tfWriteQuestion: UITextField!
    
    var questions:[QuestionDisplayObject] = []
    let questionsCelldentifier = "questionsCelldentifier"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let mycolor = UIColor.gray
        
        tfWriteQuestion.layer.borderColor = mycolor.cgColor
        tfWriteQuestion.layer.borderWidth = 1.0
    
        questionsTable.register(QuestionsTableViewCell.self, forCellReuseIdentifier: questionsCelldentifier)
        
        questionsTable.rowHeight = UITableViewAutomaticDimension
        questionsTable.estimatedRowHeight = 100
        self.questionsTable.separatorStyle = UITableViewCellSeparatorStyle.none
        
        chatService.onQuestionHistory(handler: {data, ack in
            
            for question in data! {
                let q = QuestionDisplayObject()
                q.content = question.content!
                q.user_id = question.user_id
                q.chat_id = question.chat_id
                q.id = question.id
                q.marked_time = question.marked_time
                q.avatar = question.avatar
                q.username = question.username!
                
                self.questions.append(q)
                
            }
            //let pregunta = self.questions[self.questions.count - 1].content
            //self.questions[self.questions.count - 1].content = pregunta! + " " +  "\n1\n2\n3\n4\n5\n6"
            self.reload()
            
        })
        
        chatService.onNewQuestion(handler: {data, ack in
            let q = QuestionDisplayObject()
            q.content = data?.content
            q.user_id = data?.user_id
            q.chat_id = data?.chat_id
            q.id = data?.id
            q.marked_time = data?.marked_time
            q.avatar = data?.avatar
            q.username = data?.username
            
            self.questions.append(q)
             self.reload()
        })
        
        
         
        questionsTable.dataSource = self
        questionsTable.delegate = self
    }
    
    override func viewDidLayoutSubviews(){
     
    }

    @IBAction func dismissQuestions(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return questions.count
    }
    
   
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //let celda = UITableViewCell(style:UITableViewCellStyle.default, reuseIdentifier: "Cell")
        //celda.textLabel?.text = contenidoCeldas[indexPath.row]
        //return celda
        let cell = questionsTable.dequeueReusableCell(withIdentifier: "questionsCelldentifier", for: indexPath) as! QuestionsTableViewCell
        
        cell.userNameLabel.text = (questions[indexPath.row].username!)
        cell.messageLabel.text = questions[indexPath.row].content
        cell.profileImage.downloadedFrom(link: questions[indexPath.row].avatar!)
       
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }
 
  
    @IBAction func sendQuestion(_ sender: Any) {
       
        chatService.sendQuestion(msg: question.text!)
        
        if question.text == ""{ return }
        /*
        let q = QuestionDisplayObject()
        q.content = question.text
        q.user_id = "question.user_id"
        q.chat_id = "question.chat_id"
        q.id = "question.id"
        q.marked_time = "question.marked_time"
        q.username = "mi usr " + question.text!
        q.avatar = "https://s11.favim.com/orig/160618/icon-icons-selena-gomez-twitter-Favim.com-4423596.png"
        self.questions.append(q)
 
 
        self.reload()
      */
        question.text = ""
    }
    
    func reload(){
        self.questionsTable.reloadData()
        let lastIndexPath = IndexPath.init(row: self.questions.count-1, section: 0)
        questionsTable.scrollToRow(at: lastIndexPath, at: .bottom, animated: false)
    }
    
    
}


