//
//  Artist.swift
//  yandexMusic-iOS
//
//  Created by Developer on 10.06.2021.
//

import Foundation

///Represents artist
public class Artist: YMBaseObject, Decodable {
   
   /*deserialize note: Мне очень интересно увидеть как в яндухе на клиентах солвят свой бэковский костыль, пригласите на экскурсию
   if data.get('decomposed'):
       data['decomposed'] = [
           Artist.de_json(part, client) if isinstance(part, dict) else part for part in data['decomposed']
       ]*/
   
   //Note: Так как в разных запросах id у артиста может быть как int, так и string [wtf?], то надо переопределять дефолтный декодер
   enum CodingKeys: CodingKey {
      case id
      case error
      case reason
      case name
      case cover
      case various
      case composer
      case genres
      case ogImage
      case opImage
      case noPicturesFromSearch
      case counts
      case available
      case ratings
      case links
      case ticketsAvailable
      case likesCount
      case popularTracks
      case regions
      case decomposed
      case fullNames
      case handMadeDescription
      case description
      case countries
      case enWikipediaLink
      case dbAliases
      case aliases
      case initDate
      case endDate
      case yaMoneyId
   }
   
   ///Artist UID
   public let id: Int
   ///Error description
   public let error: String?
   ///Error reason
   public let reason: String?
   ///Artist name
   public let name: String?
   ///Artist cover
   public let cover: Cover?
   ///Artist has several names marker
   public let various: Bool?
   ///Artist is composer marker
   public let composer: Bool?
   ///Artist's genres
   public let genres: [String]?
   ///Open Graph image url
   public let ogImage: String?
   ///Cover iamge url. Not null when original cover is null
   public let opImage: String?
   ///TODO
   public let noPicturesFromSearch: Bool?
   ///Artist counters
   public let counts: Counts?
   //Is artist available for listening marker
   public let available: Bool?
   ///Artist's ratings
   public let ratings: Ratings?
   ///Artist's resources links
   public let links: [Link]?
   ///Avilable for sale tickets
   public let ticketsAvailable: Bool?
   ///Likes count
   public let likesCount: Int?
   ///Artist popular tracks
   public let popularTracks: [Track]?
   ///Artist regions TODO
   public let regions: [String]?
   ///Artist decomposition
   public let decomposed: [Artist]?// Optional[List[Union[str, 'Artist']]] = None
   ///Artist several names (contains value if 'various' is TRUE)
   public let fullNames: String?
   ///Yandex description
   public let handMadeDescription: String?
   ///Artist description
   public let description: Description?
   ///Artist countries
   public let countries: [String]?
   ///Artist wikipedia url
   public let enWikipediaLink: String?
   ///Artist's aliases. Usually in other languages
   public let dbAliases: [String]?
   ///Artist pseudo names
   public let aliases: [String]?
   ///Begin date (YYYY-MM-DD or YYYY formats)
   public let initDate: String?
   ///End date (YYYY-MM-DD or YYYY formats)
   public let endDate: String?
   ///Artist Yandex.Money wallet ID TODO
   public let yaMoneyId: String?
   
   ///Artist name getter
   public var artistName: String {
      var name: String = name ?? ""
      if (name.isEmpty && (various ?? false)) {
          if let g_names = fullNames {
              name = g_names
          }
      }
      if (name.isEmpty) {
          if let g_aliases = aliases, g_aliases.count > 0 {
              name = g_aliases[0]
          }
      }
      return name
   }
   
   public init(id: Int,
               error: String?,
               reason: String?,
               name: String?,
               cover: Cover?,
               various: Bool?,
               composer: Bool?,
               genres: [String]?,
               ogImage: String?,
               opImage: String?,
               noPicturesFromSearch: Bool?,
               counts: Counts?,
               available: Bool?,
               ratings: Ratings?,
               links: [Link]?,
               ticketsAvailable: Bool?,
               likesCount: Int?,
               popularTracks: [Track]?,
               regions: [String]?,
               decomposed: [Artist]?,
               fullNames: String?,
               handMadeDescription: String?,
               description: Description?,
               countries: [String]?,
               enWikipediaLink: String?,
               dbAliases: [String]?,
               aliases: [String]?,
               initDate: String?,
               endDate: String?,
               yaMoneyId: String?) {
      self.id = id

      self.error = error
      self.reason = reason
      self.name = name
      self.cover = cover
      self.various = various
      self.composer = composer
      self.genres = genres
      self.ogImage = ogImage
      self.opImage = opImage
      self.noPicturesFromSearch = noPicturesFromSearch
      self.counts = counts
      self.available = available
      self.ratings = ratings
      self.links = links
      self.ticketsAvailable = ticketsAvailable
      self.regions = regions
      self.decomposed = decomposed
      self.popularTracks = popularTracks
      self.likesCount = likesCount
      self.fullNames = fullNames
      self.handMadeDescription = handMadeDescription
      self.description = description
      self.countries = countries
      self.enWikipediaLink = enWikipediaLink
      self.dbAliases = dbAliases
      self.aliases = aliases
      self.yaMoneyId = yaMoneyId

      //Может прийти конкретная дата или просто год
      self.initDate = initDate
      self.endDate = endDate
   }
   
   public required init(from decoder: Decoder) throws {
      let container = try decoder.container(keyedBy: CodingKeys.self)
      var id: Int = 0
      do {
          id = try container.decode(Int.self, forKey: .id)
      } catch {
         let idString = (try? container.decodeIfPresent(String.self, forKey: .id)) ?? "0"
         id = Int(idString) ?? 0
      }
      self.id = id
      
      self.error = try? container.decodeIfPresent(String.self, forKey: .error)
      self.reason = try? container.decodeIfPresent(String.self, forKey: .reason)
      self.name = try? container.decodeIfPresent(String.self, forKey: .name)
      self.cover = try? container.decodeIfPresent(Cover.self, forKey: .cover)
      self.various = try? container.decodeIfPresent(Bool.self, forKey: .various)
      self.composer = try? container.decodeIfPresent(Bool.self, forKey: .composer)
      self.genres = try? container.decodeIfPresent([String].self, forKey: .genres)
      self.ogImage = try? container.decodeIfPresent(String.self, forKey: .ogImage)
      self.opImage = try? container.decodeIfPresent(String.self, forKey: .opImage)
      self.noPicturesFromSearch = try? container.decodeIfPresent(Bool.self, forKey: .noPicturesFromSearch)
      self.counts = try? container.decodeIfPresent(Counts.self, forKey: .counts)
      self.available = try? container.decodeIfPresent(Bool.self, forKey: .available)
      self.ratings = try? container.decodeIfPresent(Ratings.self, forKey: .ratings)
      self.links = try? container.decodeIfPresent([Link].self, forKey: .links)
      self.ticketsAvailable = try? container.decodeIfPresent(Bool.self, forKey: .ticketsAvailable)
      self.regions = try? container.decodeIfPresent([String].self, forKey: .regions)
      self.decomposed = try? container.decodeIfPresent([Artist].self, forKey: .decomposed)
      self.popularTracks = try? container.decodeIfPresent([Track].self, forKey: .popularTracks)
      self.likesCount = try? container.decodeIfPresent(Int.self, forKey: .likesCount)
      self.fullNames = try? container.decodeIfPresent(String.self, forKey: .fullNames)
      self.handMadeDescription = try? container.decodeIfPresent(String.self, forKey: .handMadeDescription)
      self.description = try? container.decodeIfPresent(Description.self, forKey: .description)
      self.countries = try? container.decodeIfPresent([String].self, forKey: .countries)
      self.enWikipediaLink = try? container.decodeIfPresent(String.self, forKey: .enWikipediaLink)
      self.dbAliases = try? container.decodeIfPresent([String].self, forKey: .dbAliases)
      self.aliases = try? container.decodeIfPresent([String].self, forKey: .aliases)
      self.yaMoneyId = try? container.decodeIfPresent(String.self, forKey: .yaMoneyId)

      //Может прийти конкретная дата или просто год
      self.initDate = try? container.decodeIfPresent(String.self, forKey: .initDate)
      self.endDate = try? container.decodeIfPresent(String.self, forKey: .endDate)
   }
   

   ///Downloads open graph image
   ///- Parameter width: Width of the image
   ///- Parameter height: Height of the image
   ///- Parameter completion: image data response handler
   public func downloadOgImage(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
       if let g_ogImg = ogImage {
           let size = String(width) + "x" + String(height)
           let urlStr = "https://" + g_ogImg.replacingOccurrences(of: "%%", with: size)
           download(fullPath: urlStr, completion: completion)
       }
   }
   
   ///Downloads cover image
   ///- Parameter width: Width of the image
   ///- Parameter height: Height of the image
   ///- Parameter completion: image data response handler
   public func downloadOpImage(width: Int = 200, height: Int = 200, completion: @escaping (Result<Data, YMError>) -> Void) {
       if let g_opImg = opImage {
           let size = String(width) + "x" + String(height)
           let urlStr = "https://" + g_opImg.replacingOccurrences(of: "%%", with: size)
           download(fullPath: urlStr, completion: completion)
       }
   }
   
   public func like(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
      addLikesArtistByApi(token: accountSecret, userId: accountUidStr, artistIds: [String(id)], completion: completion)
   }
   
   public func removeLike(completion: @escaping (_ result: Result<Bool, YMError>) -> Void) {
      removeLikesArtistByApi(token: accountSecret, userId: accountUidStr, artistIds: [String(id)], completion: completion)
   }
   
   public func getTracks(page: Int = 0, pageSize: Int = 20, completion: @escaping (_ result: Result<ArtistTracks, YMError>) -> Void) {
      getArtistTracksByApi(token: accountSecret, artistId: String(id), page: page, pageSize: pageSize, completion: completion)
   }
   
   public func getDirectAlbums(page: Int = 0, pageSize: Int = 20, sortBy: ArtistAlbumsSortBy = .year, completion: @escaping (_ result: Result<ArtistAlbums, YMError>) -> Void) {
      getArtistDirectAlbumsByApi(token: accountSecret, artistId: String(id), page: page, pageSize: pageSize, sortBy: sortBy.rawValue, completion: completion)
   }
}
