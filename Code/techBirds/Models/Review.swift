//
//  Review.swift
//  techBirds
//
//  Created by Artem Belkov on 31.07.2020.
//  Copyright © 2020 techBirds. All rights reserved.
//

import Foundation

struct Review {
    let author: String
    let rating: Int
    let title: String
    let content: String
    
    var text: String { "\(title) \(content)" }
    
    private(set) var category: Category = .undefined
    private(set) var categoryPropability: [String: Double] = [:]
    
    private(set) var team: Team = .undefined
    private(set) var teamPropability: [String: Double] = [:]

    mutating func updateCategory(_ category: Category, propability: [String: Double]) {
        self.category = category
        self.categoryPropability = propability
    }
    
    mutating func updateTeam(_ team: Team, propability: [String: Double]) {
        self.team = team
        self.teamPropability = propability
    }
}

extension Review {
    enum Category: String {
        case bug // баг
        case comment // замечание
        case question // вопрос
        case proposal // пожелание
        case like // все отлично
        case undefined
        
        static var all: [Category] {
            [
                bug,
                comment,
                question,
                proposal,
                like
            ]
        }
    }
    
    enum Team: String, Encodable {
        case iOSPlatform = "iOS Platform"
        case globalNavigation = "Global Navigation"
        case ddaProfile = "DDA Profile"
        case pfm = "PFM"
        case pfmPlace = "PFMMPLACE"
        case pushIOS = "PUSH iOS"
        case dbpShowcases = "DBP.Витрины продаж"
        case gosuslugi = "Госуслуги"
        case iosRelease = "iOS Release Engineer"
        case messenger = "Мессенджер"
        case storeAndSales = "Store-n-Sales"
        case integrationPlatform = "Integration Platform"
        case dataDrivenApp = "Data Driven App"
        case crowdfunding = "Краудфандинг"
        case dbpGifts = "DBP.Подарки"
        case sberbankIDB2C = "Sberbank ID B2C"
        case operationsHistory = "История операций"
        case editableCustomerProfile = "Редактируемый профиль клиента"
        case efsExtractsAndReferencesMobile = "ЕФС Выписки и справки. Mobile"
        case efsPaymentsMobile = "ЕФС.Платежи МП"
        case paymentsAndPenalties = "Платежи.Штрафы"
        case pdvDigital = "ПДВ в Digital"
        case sbolClassicTranslations = "СБОЛ.Классические переводы"
        case efsAutoPayments = "ЕФС.Автоплатежи"
        case autoTranslations = "Автопереводы"
        case digitalSberbankPremier = "Digital Сбербанк Премьер"
        case loyaltyDevelopmentMobileSBOL = "Развитие лояльности в МП СБОЛ"
        case debitCardMobile = "Дебетовые карты в мобильном приложении"
        case deviceCard = "Карта в телефоне"
        case digitalPin = "Digital PIN"
        case debitCardReissue = "Плановый и досрочный перевыпуск дебетовых карт"
        case selEmployed = "Self-employed"
        case digitalCredit = "Цифровой Кредит"
        case vsMobileDeposits = "ВС.МП вклады"
        case comissionProducts = "Комиссионные продукты"
        case pfmBudget = "PFM Бюджет"
        case mobileOnlinePOS = "Mobile Online POS (Розничный кредит)"
        case textChat = "Текстовый чат"
        case efsCreditCardCosmonauts = "[ЕФС].Кредитные карты.Космонавты (Доп. услуги и сервисы)"
        case efsBrokerMobile = "ЕФС. Брокеридж. Мобайл"
        case efsSBOLWealth = "[ЕФС] Б.УБ.СБОЛ.Баллонг"
        case efsInsurance = "ЕФС. Страхование"
        case telecom = "Телеком"
        case marketing = "Маркетинг"
        case undefined
        
        static var all: [Team] {
            [
                iOSPlatform,
                globalNavigation,
                ddaProfile,
                pfm,
                pfmPlace,
                pushIOS,
                dbpShowcases,
                gosuslugi,
                iosRelease,
                messenger,
                storeAndSales,
                integrationPlatform,
                dataDrivenApp,
                crowdfunding,
                dbpGifts,
                sberbankIDB2C,
                operationsHistory,
                editableCustomerProfile,
                efsExtractsAndReferencesMobile,
                efsPaymentsMobile,
                paymentsAndPenalties,
                pdvDigital,
                sbolClassicTranslations,
                efsAutoPayments,
                autoTranslations,
                digitalSberbankPremier,
                loyaltyDevelopmentMobileSBOL,
                debitCardMobile,
                deviceCard,
                digitalPin,
                debitCardReissue,
                selEmployed,
                digitalCredit,
                vsMobileDeposits,
                comissionProducts,
                pfmBudget,
                mobileOnlinePOS,
                textChat,
                efsCreditCardCosmonauts,
                efsBrokerMobile,
                efsSBOLWealth,
                efsInsurance,
                telecom,
                marketing
            ]
        }
    }
}

extension Review: Decodable {
    enum CodingKeys: String, CodingKey {
        case author
        case rating = "im:rating"
        case title
        case content
    }

    enum AuthorContainerKeys: String, CodingKey {
        case name
    }

    enum ContainerKeys: String, CodingKey {
        case label
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        let authorContainer = try container.nestedContainer(keyedBy: AuthorContainerKeys.self, forKey: .author)
        let authorNameConstainer = try authorContainer.nestedContainer(keyedBy: ContainerKeys.self, forKey: .name)
        author = try authorNameConstainer.decode(String.self, forKey: .label)

        let ratingContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .rating)
        let stringRating = try ratingContainer.decode(String.self, forKey: .label)
        rating = Int(stringRating) ?? 0

        let titleContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .title)
        title = try titleContainer.decode(String.self, forKey: .label)

        let contentContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .content)
        content = try contentContainer.decode(String.self, forKey: .label)
    }
}

struct ReviewsFeed: Decodable {
    let reviews: [Review]

    enum CodingKeys: String, CodingKey {
        case feed
    }

    enum ContainerKeys: String, CodingKey {
        case reviews = "entry"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let reviewsContainer = try container.nestedContainer(keyedBy: ContainerKeys.self, forKey: .feed)

        reviews = try reviewsContainer.decode([Review].self, forKey: .reviews)
    }
}
