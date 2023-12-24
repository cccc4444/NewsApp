//
//  StoriesService.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 24.12.2023.
//

import Foundation

extension NetworkRequest {
    static func fetchSectionList() -> NetworkRequest<SectionListModel> {
        return NetworkRequest<SectionListModel>(
            method: .get,
            url: StoriesURLs.sectionList,
            header: .standard
        )
    }
}
