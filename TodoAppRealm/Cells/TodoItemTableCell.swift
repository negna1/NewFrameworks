//
//  TodoItemTableCell.swift
//  TodoAppRealm
//
//  Created by Nato Egnatashvili on 02.03.22.
//

import Foundation
import UIKit

class TodoItemTableCell: UITableViewCell{
    
    private let title: UILabel = {
        let lbl = UILabel()
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        initial()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func initial() {
        self.contentView.addSubview(title)
        title.leftAnchor.constraint(equalTo: self.contentView.leftAnchor, constant: 16).isActive = true
        title.topAnchor.constraint(equalTo: self.contentView.topAnchor, constant: 16).isActive = true
    }
}

extension TodoItemTableCell: TableCellConfigurable {
    func configure(model: TableCellModelProtocol) {
        guard let newModel = model as? CellModel else { return }
        self.title.text = newModel.text
    }
}

extension TodoItemTableCell {
    struct CellModel: TableCellModelProtocol {
        var name: String = "TodoItemTableCell"
        var height: CGFloat = UITableView.automaticDimension
        var text: String
        var isCompleted: Bool
        
        public init(text: String, isCompleted: Bool = false) {
            self.text = text
            self.isCompleted = isCompleted
        }
    }
}

