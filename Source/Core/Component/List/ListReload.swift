//
//  ListReload.swift
//  ArgoKit
//
//  Created by Bruce on 2020/12/24.
//

import Foundation
extension List {
    public func reloadData() ->Self{
        tableNode.reloadData()
        return self
    }
    public func insertSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
        tableNode.insertSections(sections,with: animation)
        return self
    }

    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
        tableNode.deleteSections(sections,with: animation)
        return self
    }

    public func reloadSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) ->Self{
        tableNode.reloadSections(sections,with: animation)
        return self
    }

    public func moveSection(_ section: Int, toSection newSection: Int) ->Self{
        tableNode.moveSection(section,toSection: newSection)
        return self
    }

    
    public func insertRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self{
        tableNode.insertRows(at:indexPaths,with: animation)
        return self
    }

    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self{
        tableNode.deleteRows(at:indexPaths,with: animation)
        return self
    }
    public func reloadRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) ->Self{
        tableNode.reloadRows(at:indexPaths,with: animation)
        return self
    }
    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) ->Self{
        tableNode.moveRow(at:indexPath,to: newIndexPath)
        return self
    }
    
//    @discardableResult
//    public func reloadData(_ data: [D]? = nil, sectionHeaderData: ArgoKitIdentifiable? = nil, sectionFooterData: ArgoKitIdentifiable? = nil) -> Self where D : ArgoKitIdentifiable{
//        tableNode.reloadData(data: data != nil ? [data!] : nil, sectionHeaderData: (sectionHeaderData != nil) ? [sectionHeaderData!] : nil, sectionFooterData: (sectionFooterData != nil) ? [sectionFooterData!] : nil)
//        return self
//    }
//
//    @discardableResult
//    public func reloadData(_ sectionData: [[D]]? = nil, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil) -> Self where D : ArgoKitIdentifiable{
//        tableNode.reloadData(data: sectionData, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData)
//        return self
//    }
//
//    @discardableResult
//    public func reloadSections(_ sectionData: [[D]]? = nil, sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, sections: IndexSet, with animation: UITableView.RowAnimation) -> Self where D : ArgoKitIdentifiable{
//        tableNode.reloadSections(sectionData, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, sections: sections, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func appendSections(_ data: [[D]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, with animation: UITableView.RowAnimation) -> Self where D : ArgoKitIdentifiable{
//        tableNode.appendSections(data, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func insertSections(_ data: [[D]], sectionHeaderData: [ArgoKitIdentifiable]? = nil, sectionFooterData: [ArgoKitIdentifiable]? = nil, at sections: IndexSet, with animation: UITableView.RowAnimation) -> Self where D : ArgoKitIdentifiable{
//        tableNode.insertSections(data, sectionHeaderData: sectionHeaderData, sectionFooterData: sectionFooterData, at: sections, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func deleteSections(_ sections: IndexSet, with animation: UITableView.RowAnimation) -> Self {
//        tableNode.deleteSections(sections, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func moveSection(_ section: Int, toSection newSection: Int) -> Self {
//        tableNode.moveSection(section, toSection: newSection)
//        return self
//    }
//
//    @discardableResult
//    public func reloadRows(_ rowData: [D]?, at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self where D : ArgoKitIdentifiable{
//        tableNode.reloadRows(rowData, at: indexPaths, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func appendRows(_ rowData: [D], at section: Int = 0, with animation: UITableView.RowAnimation) -> Self where D : ArgoKitIdentifiable{
//        tableNode.appendRows(rowData, at: section, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func insertRows(_ rowData: [D], at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self where D : ArgoKitIdentifiable{
//        tableNode.insertRows(rowData, at: indexPaths, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func deleteRows(at indexPaths: [IndexPath], with animation: UITableView.RowAnimation) -> Self {
//        tableNode.deleteRows(at: indexPaths, with: animation)
//        return self
//    }
//
//    @discardableResult
//    public func moveRow(at indexPath: IndexPath, to newIndexPath: IndexPath) -> Self {
//        tableNode.moveRow(at: indexPath, to: newIndexPath)
//        return self
//    }
}
