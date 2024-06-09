//
//  GifDTO.swift
//  giphy
//
//  Created by najin on 4/10/24.
//

import Foundation

struct GifDTO: Codable {
    var data: [GifImageDTO] = []
    let meta: GifMetaDTO?
    let pagination: GifPageDTO?
    
    func toEntity() -> [GifModel] {
        return data.map { item in
            let image = item.images?.small
            return GifModel(width: CGFloat(Int(image?.width ?? "0") ?? 0),
                            height: CGFloat(Int(image?.height ?? "0") ?? 0),
                            url: image?.url ?? "")
        }
    }
}

struct GifImageDTO: Codable {
    let images: Images?
}

struct Images: Codable {
    let original: FixedHeight?
    let small: FixedHeight?
    
    enum CodingKeys: String, CodingKey {
        case original
        case small = "fixed_height"
    }
}

struct FixedHeight: Codable {
    let height, width, size: String?
    let url: String?

    enum CodingKeys: String, CodingKey {
        case height, width, size, url
    }
}

struct GifMetaDTO: Codable {
    let status: Int?
    let msg, responseID: String?

    enum CodingKeys: String, CodingKey {
        case status, msg
        case responseID = "response_id"
    }
}

struct GifPageDTO: Codable {
    let totalCount, count, offset: Int?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case count, offset
    }
}
