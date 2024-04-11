//
//  FoodPageModels.swift
//  Login
//
//  Created by Thananjayan Selvarajan on 26/10/23.
//

import Foundation

struct FoodPageSection {
    let title: SectionTitle
    var items: [ItemsType]
}

struct BasicData {
    let image: String
    let detail: String
}

struct CarouselData {
    let image: String
    let cardNum: Int
}

struct RestaurantData {
    let image: String
    let name: String
    let cuisine: String
    let rating: Double
    let reviews: Int
    let time: Int
    let distance: Double
    let location: String
    let offers: [String]
}

struct CravingData {
    let images: [String]
    let captions: [String]
}

enum ItemsType {
    case threeStaticCell(data: BasicData)
    case videoCell(data: String)
    case carouselCell(data: CarouselData)
    case restaurantThumbnailMiniCell(data: RestaurantData)
    case dishCell(data: BasicData)
    case cravingInteractionCell(data: CravingData)
    case trustedPicksCapsuleSegment(data: BasicData)
    case quickPicksCapsuleSegment(data: BasicData)
    case restaurantCell(data: RestaurantData)
    case restaurantThumbnailMegaCell(data: RestaurantData)
    case carouselPageControlCell
}

enum SectionTitle {
    case ThreeStaticSection(String)
    case VideoSection(String)
    case CarouselSection(String)
    case CapsuleSection(String)
    case SixRestaurantSection(String)
    case DishTypeSection(String)
    case TopRatedNearYouSection(String)
    case CarouselPageControlSection(String)
}
