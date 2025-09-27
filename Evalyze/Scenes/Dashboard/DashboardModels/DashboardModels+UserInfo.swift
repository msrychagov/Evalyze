//
//  DashboardModels+UserInfo.swift
//  Evalyze
//
//  Created by Михаил Рычагов on 26.09.2025.
//

extension DashboardModels {
    enum UserInfo {
        struct Request {}
        struct Response {}
        struct ViewModel {
            let title: String
            let name: String
            let group: String
        }
    }
}
