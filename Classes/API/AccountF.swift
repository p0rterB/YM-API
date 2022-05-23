//
//  Account.swift
//  YM-API
//
//  Created by Developer on 13.07.2021.
//

import Foundation

func getAccountStatusByApi(token: String, completion: @escaping (_ result: Result<Status, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .account_status(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build account status info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let accStatus: Status = try JSONDecoder().decode(Status.self, from: data)
                completion(.success(accStatus))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Status.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getUserInfoByApi(userIdOrNickname: String, completion: @escaping (_ result: Result<User, YMError>) -> Void)
{
    if (userIdOrNickname.isEmpty) {
        completion(.failure(.badRequest(errCode: -1, description: "Empty userID or nickname")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .user_info(userIdOrNickname: userIdOrNickname)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build user info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let userInfo: User = try JSONDecoder().decode(User.self, from: data)
                completion(.success(userInfo))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: User.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getAccountSettingsByApi(token: String, completion: @escaping (_ result: Result<UserSettings, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .account_settings(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build account settings info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let accSettings: UserSettings = try JSONDecoder().decode(UserSettings.self, from: data)
                completion(.success(accSettings))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: UserSettings.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func setAccountSettingsByApi(token: String, editValues: [String: Any], completion: @escaping (_ result: Result<UserSettings, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .account_settings_edit(secret: token, values: editValues)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build account settings edit request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let accSettings: UserSettings = try JSONDecoder().decode(UserSettings.self, from: data)
                completion(.success(accSettings))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: UserSettings.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getRotorAccountStatusByApi(token: String, completion: @escaping (_ result: Result<Status, YMError>) -> Void)
{
    guard let req: URLRequest = buildRequest(for: .rotor_account_status(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build rotor account status info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let accStatus: Status = try JSONDecoder().decode(Status.self, from: data)
                completion(.success(accStatus))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: Status.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getPurchaseSuggestionsByApi(token: String, completion: @escaping (_ result: Result<PurchaseSuggestions, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .purchase_suggestions(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build account purchase suggestions info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let suggestions: PurchaseSuggestions = try JSONDecoder().decode(PurchaseSuggestions.self, from: data)
                completion(.success(suggestions))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: PurchaseSuggestions.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getAccountPermissionAlertsByApi(token: String, completion: @escaping (_ result: Result<PermissionAlert, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .permission_alerts(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build account alerts info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let alerts: PermissionAlert = try JSONDecoder().decode(PermissionAlert.self, from: data)
                completion(.success(alerts))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: PermissionAlert.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func sendPromoCodeByApi(token: String, code: String, lang: ApiLanguage, completion: @escaping (_ result: Result<PromoCodeStatus, YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .consume_promo_code(lang: lang, secret: token, code: code)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build promo code consume request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                let data = try JSONSerialization.data(withJSONObject: g_dict)
                let status: PromoCodeStatus = try JSONDecoder().decode(PromoCodeStatus.self, from: data)
                completion(.success(status))
                return
            }
            completion(.failure(.invalidObject(objType: String(describing: PromoCodeStatus.self), description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}

func getAccountExperimentsByApi(token: String, completion: @escaping (_ result: Result<[String: Any], YMError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .account_experiments(secret: token)) else {completion(.failure(.badRequest(errCode: -1, description: "Unable to build account experiments info request"))); return}
    requestYMResponse(req) { result in
        var response: YMResponse?
        do {
            let ymResponse = try result.get()
            response = ymResponse
            if let g_error = ymResponse.error {
                completion(.failure(.badResponseData(errCode: ymResponse.statusCode, data: ["errorName": g_error.name, "errorDescription": g_error.message])))
                return
            }
            if let g_dict = ymResponse.result as? [String: Any] {
                completion(.success(g_dict))
                return
            }
            completion(.failure(.invalidObject(objType: "Dictionary <String, Any>", description: "No data for parsing")))
        } catch {
            var data: [String: Any] = ["description": error]
            if let g_data = response?.result {
                data["data"] = g_data
            }
            let parsed: YMError = error as? YMError ?? YMError.general(errCode: response?.statusCode ?? -1, data: data)
            completion(.failure(parsed))
        }
    }
}
