//
//  Store.swift
//  ITrafficMonitorForMac
//
//  Created by f.zou on 2021/5/23.
//

import SwiftUI

enum SharedStore {
    static let listViewModel = ListViewModel()
    static let statusDataModel = StatusDataModel()
}

extension View {
    func withGlobalEnvironmentObjects() -> some View {
        environmentObject(SharedStore.listViewModel)
        .environmentObject(SharedStore.statusDataModel)
    }
}
