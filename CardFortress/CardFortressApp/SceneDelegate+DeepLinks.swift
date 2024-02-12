//
//  SceneDelegate+DeepLinks.swift
//  CardFortress
//
//  Created by Roberto Corrales on 2/11/24.
//

import Foundation

extension SceneDelegate {
    
    // MARK: Constants
    static let appScheme = "cardfortress"
    
    func handleDeepLinks(url: URL?) {
        // URL cardfortress://login?email=roberto.corrales@gmail.com&password=123456
        guard let url else { return }
        
        guard url.scheme == Self.appScheme else { return }
        
        guard let components = URLComponents(url: url, resolvingAgainstBaseURL: true) else {
            debugPrint("Invalid URL")
            return
        }
        
        guard let deepLinkAction = components.deepLinkRoute else {
            debugPrint("Unknown URL, we can't handle this one!")
            return
        }

        switch deepLinkAction {
        case .login:
            handleDeepLinkLogin(components: components)
        case .unknown:
            break
        }
    }
    
    private func handleDeepLinkLogin(components: URLComponents) {
        guard let email = components.email,
              let password = components.password else { return }
        let authAPI = self.container.resolve(AuthenticationAPI.self)
        Task {
            await authAPI?.signIn(withEmail: email, password: password)
        }
    }
}

enum QueryItem: String {
    case email
    case password
    case unknown
}

enum DeepLinkRoute: String {
    case login
    case unknown
    
    init?(rawValue: String?) {
        if let rawValue {
            self.init(rawValue: rawValue)
        } else {
            self = .unknown
        }
    }
}

extension URLComponents {
    var deepLinkRoute: DeepLinkRoute? {
        .init(rawValue: host)
    }
    
    var email: String? {
        queryItems?.first(where: { $0.queryItemType == .email })?.value
    }
    var password: String? {
        queryItems?.first(where: { $0.queryItemType == .password })?.value
    }
}

extension URLQueryItem {
    var queryItemType: QueryItem {
        .init(rawValue: self.name) ?? .unknown
    }
}
