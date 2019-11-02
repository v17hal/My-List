import UIKit

class MyListTableViewController: UITableViewController, MyListCellDelegate {
    

    var todoItems:[MyListItem]!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        //self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
      //  self.navigationItem.leftBarButtonItem = self.editButtonItem
        loadData()
    }
    
    @IBAction func addNewTodo(_ sender: Any) {
        let addAlert = UIAlertController(title: "New Task", message: "What do you want to add to your list", preferredStyle: .alert)
        
        addAlert.addTextField { (textfield : UITextField) in
            textfield.placeholder = "ToDo Item Title"
        }
        
        
        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler:
            {(action:UIAlertAction) in
            
                guard let title = addAlert.textFields?.first?.text else { return }
                let newTodo = MyListItem.init(title: title, completed: false, createdAt: Date(), itemIdentifier: UUID())
                newTodo.saveItem()
                
                self.todoItems.append(newTodo)
                
                let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
                self.tableView.insertRows(at: [indexPath], with: .automatic)
        }))
        
        
        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(addAlert, animated: true,completion: nil)
        
    }
    
    func didRequestDelete(_ cell: ToDoTableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            todoItems[indexPath.row].deleteItem()
            todoItems.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
    }
    
//    func didRequestComplete(_ cell: ToDoTableViewCell) {
//        if let indexPath = tableView.indexPath(for: cell) {
//            var todoItem = todoItems[indexPath.row]
//            todoItem.markAsCompleted()
//            cell.todoLabel.attributedText = strikeThroughText(todoItem.title)
//        }
//    }
    
//    func strikeThroughText(_ text: String) -> NSAttributedString {
//        let attributeString: NSMutableAttributedString = NSMutableAttributedString(string: text)
//        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle,value: 1,range: NSMakeRange(0, attributeString.length))
//        
//        return attributeString
//    }
    
    func loadData() {
        todoItems = [MyListItem]()
        todoItems = DataManager.loadAll(MyListItem.self).sorted(by: {
            $0.createdAt < $1.createdAt
        })
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        
        cell.delegate = self
        
        let todoItem = todoItems[indexPath.row]
        
        cell.todoLabel.text = todoItem.title

//        if todoItem.completed {
//            cell.todoLabel.attributedText = todoItem.title
//        }
         //Configure the cell...

        return cell
    }
 



}
