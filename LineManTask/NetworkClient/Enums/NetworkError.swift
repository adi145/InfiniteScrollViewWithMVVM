//
//  NetworkError.swift
//  NetworkClient
//
//  Created by Adinarayana Machavarapu on 19/9/2563 BE.
//

import Foundation

/**
 The ApiError enum used to catch the network error and return  message to app to display
*/
enum NetworkError: Error,Equatable {
    case badRequest // in case 400 status code
    case forbidden  // in case 403 status code
    case resourceNotFound // in case 404 status code
    case unAuthonticated  // in case 401 status code
    case generalError // in case of other status code
    case internalServer // in case 500...599 status code
    case noInternet
    case timeout
    case noData
    case custom(error:String) // custom error with localized string
    case parser(error: String) // in case error from json decode
    case none  // in case 200 status code
    
   /**
    This method is used find the error with http status code and return suitable case  to app
    
    - parameter response: HTTPURLResponse
    
    - returns: ApiError with suitable case
    */
   static func handleErrorResponse(errorCode: Int) -> NetworkError {
        switch errorCode {
        case 200:
            return .none
        case 400:
            return .badRequest
        case 401:
            return .unAuthonticated
        case 403:
            return .forbidden
        case 404:
            return .resourceNotFound
        case 500:
            return .internalServer
        default:
            return .generalError
        }
    }
    
   /**
    This is used to return error message based on condition
    
    - parameter error: ApiError
    
    - returns: Error message with string
    */
   static func getTheErrorMessage(error: NetworkError) -> String {
        var message : String!
        switch error {
        case .internalServer:
            message = NetworkErrorMessages.internalServerError
        case .noInternet:
            message = NetworkErrorMessages.internetErrorFromNetwork
        case .parser(let errorMessage):
            message = errorMessage
        case .custom(let errorMessage):
            message = errorMessage
        case .badRequest:
            message = NetworkErrorMessages.badRequestError
        case .forbidden:
            message = NetworkErrorMessages.forbiddenError
        case .resourceNotFound:
            message = NetworkErrorMessages.resourceNotFoundError
        case .timeout,unAuthonticated,noData:
            message = NetworkErrorMessages.someWentWrongError
        default:
            message = NetworkErrorMessages.someWentWrongError
            break
        }
        return message
    }
}
