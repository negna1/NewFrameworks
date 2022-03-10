//
//  ViewController.swift
//  TodoAppRealm
//
//  Created by Nato Egnatashvili on 02.03.22.
//

import UIKit
import RealmSwift

class ViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var items = ToDoItem.all() {
        didSet {
            self.dataSource = items.map { todoItem in
                TodoItemTableCell.CellModel(text: todoItem.text)
            }
        }
    }
    private lazy var dataSource: [TableCellModelProtocol] = items.map { todoItem in
        TodoItemTableCell.CellModel(text: todoItem.text)
    }
    private var itemsToken: NotificationToken?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem.init(barButtonSystemItem: .add, target: self, action: #selector(addItem))]
        self.tableView.register(TodoItemTableCell.self, forCellReuseIdentifier: "TodoItemTableCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        itemsToken = items.observe { [weak tableView] changes in
          guard let tableView = tableView else { return }
          switch changes {
          case .initial:
            tableView.reloadData()
          case .update(_, let deletions, let insertions, let updates):
            tableView.applyChanges(deletions: deletions, insertions: insertions,
        updates: updates)
          case .error: break
        } }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        itemsToken?.invalidate()
    }
    
    @objc func addItem() {
        addPresenter()
    }
    
    private func addPresenter() {
        
        let presentModal = NameController(title: "", message: nil, preferredStyle: .alert)
        presentModal.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { _ in
            presentModal.dismiss(animated: true, completion: nil)
        }))
        presentModal.addAction(UIAlertAction.init(title: "Add", style: .default, handler: { _ in
           ToDoItem.add(text: presentModal.getText())
            self.items = ToDoItem.all()
        }))
        self.present(presentModal, animated: true, completion: nil)
    }
}

// MARK: - Table view delegate and datasource

extension ViewController: UITableViewDelegate {
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: dataSource[indexPath.row].name,
                                                 for: indexPath) 
        if let cell = cell as? TableCellConfigurable {
            cell.configure(model: dataSource[indexPath.row])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }
    
    func tableView(_ tableView: UITableView,
                       leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        

        // Trash action
        let trash = UIContextualAction(style: .destructive,
                                       title: "Remove") { [weak self] (action, view, completionHandler) in
            self?.removeItem(at: indexPath.row)
                                        completionHandler(true)
        }
        trash.backgroundColor = .systemRed
        let configuration = UISwipeActionsConfiguration(actions: [trash])
        configuration.performsFirstActionWithFullSwipe = false
        return configuration
    }
    
    func removeItem(at row: Int) {
        items[row].delete()
        items = ToDoItem.all()
    }
}

class NameController: UIAlertController {
    private let textField: UITextField = {
        let textField = UITextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    override func viewDidLoad() {
        self.view.addSubview(textField)
        textField.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant: 10).isActive = true
        textField.topAnchor.constraint(equalTo: self.view.topAnchor, constant: 10).isActive = true
        textField.placeholder = "Add here"
    }
    
    func getText() -> String {
        return textField.text ?? ""
    }
}

extension UITableView {
    func applyChanges(deletions: [Int], insertions: [Int],
                      updates: [Int]) {
        let deletionsS = deletions.map { d in
            IndexPath.init(row: d, section: 0)
        }
        let insertionsS = insertions.map { d in
            IndexPath.init(row: d, section: 0)
        }
        self.beginUpdates()
        self.deleteRows(at: deletionsS, with: .fade)
        self.insertRows(at: insertionsS, with: .automatic)
        self.endUpdates()
    }
}
