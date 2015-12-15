//
//  Row.swift
//  Shoyu
//
//  Created by asai.yuki on 2015/12/12.
//  Copyright © 2015年 yukiasai. All rights reserved.
//

import UIKit

protocol RowType {
    var reuseIdentifier: String { get set }
    var height: CGFloat? { get }
    
    func configureCell(cell: UITableViewCell, indexPath: NSIndexPath)
    func heightFor(indexPath: NSIndexPath) -> CGFloat?
    func didSelect(indexPath: NSIndexPath)
    func didDeselect(indexPath: NSIndexPath)
    func willDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath)
    func didEndDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath)
}

class Row<T: UITableViewCell>: RowType {
    init() { }
    
    init(@noescape clousure: (Row<T> -> Void)) {
        clousure(self)
    }
    
    var configureCell: ((T, NSIndexPath) -> Void)?
    var heightFor: (NSIndexPath -> CGFloat?)?
    var didSelect: (NSIndexPath -> Void)?
    var didDeselect: (NSIndexPath -> Void)?
    var willDisplayCell: ((T, NSIndexPath) -> Void)?
    var didEndDisplayCell: ((T, NSIndexPath) -> Void)?
    
    private var _reuseIdentifier: String?
    var reuseIdentifier: String {
        set {
            _reuseIdentifier = newValue
        }
        get {
            if let identifier = _reuseIdentifier {
                return identifier
            }
            if let identifier = T() as? ReuseIdentifierType {
                return identifier.identifier
            }
            fatalError()
        }
    }
    
    var height: CGFloat?
}

extension Row {
    internal func configureCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        configureCell?(genericCell, indexPath)
    }
    
    internal func heightFor(indexPath: NSIndexPath) -> CGFloat? {
        return heightFor?(indexPath) ?? height
    }
    
    internal func didSelect(indexPath: NSIndexPath) {
        didSelect?(indexPath)
    }
    
    internal func didDeselect(indexPath: NSIndexPath) {
        didDeselect?(indexPath)
    }
    
    internal func willDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        willDisplayCell?(genericCell, indexPath)
    }
    
    internal func didEndDisplayCell(cell: UITableViewCell, indexPath: NSIndexPath) {
        guard let genericCell = cell as? T else {
            fatalError()
        }
        didEndDisplayCell?(genericCell, indexPath)
    }
}