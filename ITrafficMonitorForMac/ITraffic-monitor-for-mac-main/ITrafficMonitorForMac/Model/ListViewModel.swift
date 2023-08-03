//
//  ListViewModel.swift
//  ITrafficMonitorForMac
//
//  Created by f.zou on 2021/5/23.
//

import Foundation

class ListViewModel: ObservableObject {

    @Published var items: [ProcessEntity] = []
    var globalModel = SharedStore.globalModel
    var gcCounter = 0
    
    public func updateData(newItems: [ProcessEntity]) {
        if shouldClearItemsForReduceSomeMemory() {
            items.removeAll()
        }

        var pid2IndexForItems = [String: Int]()
        var pidInNewItems = [String: Int]()
        for i in 0..<items.count {
            pid2IndexForItems["\(items[i].pid)"] = i
        }
        
        for newItem in newItems {
            let i = pid2IndexForItems["\(newItem.pid)"] ?? -1
            if i != -1 {
                items[i].icon = newItem.icon
                items[i].name = newItem.name
                items[i].inBytes = newItem.inBytes
                items[i].outBytes = newItem.outBytes
            } else {
                items.append(newItem)
            }
            pidInNewItems["\(newItem.pid)"] = 1
        }
        
        items = items.filter(){ pidInNewItems["\($0.pid)"] ?? -1 != -1 }
        
        items = sort(items: items)
    }
    
    func sort(items: [ProcessEntity]) -> [ProcessEntity] {
        return items.sorted {  (lhs:ProcessEntity, rhs:ProcessEntity) in
            let lTotalBytes = lhs.inBytes + lhs.outBytes
            let rTotalBytes = rhs.inBytes + rhs.outBytes
            if lTotalBytes != rTotalBytes {
                return lTotalBytes > rTotalBytes
            }
            return lhs.name < rhs.name
        }
    }
    
    public func shouldClearItemsForReduceSomeMemory() -> Bool {
        gcCounter += 1
        if !self.globalModel.viewShowing && gcCounter >= 50 {
            gcCounter = 0
            return true
        }
        return false
    }
}
