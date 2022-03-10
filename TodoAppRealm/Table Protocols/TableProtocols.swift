//
//  TableProtocols.swift
//  TodoAppRealm
//
//  Created by Nato Egnatashvili on 02.03.22.
//

import UIKit

protocol TableCellModelProtocol {
    var name: String { get set}
    var height: CGFloat  { get set}
}

protocol TableCellConfigurable {
    func configure(model: TableCellModelProtocol)
}
