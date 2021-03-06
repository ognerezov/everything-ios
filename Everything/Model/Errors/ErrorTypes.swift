//
//  ErrorTypes.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 01.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

enum ErrorType: Int{
    case CanceledPurchase = -5
    case UnparsableResponse = -4
    case WaitForEmail = -3
    case TimeOut = -2
    case Processing = -1
    case NoNetwork = 0
    case PasswordsNotTheSame = 77
    case NoException = 200
    case WrongRequest = 400
    case Unauthorized = 401
    case PaymentNotVerified = 402
    case Forbidden = 403
    case NotFound = 404
    case UnsupportedMethod = 405
    case Conflict = 409
    case Gone = 410
    case DisabledUser = 418
    case WrongTempToken = 422
    case FailedDependency = 424
    case ModificationProhibited = 451
    case ServerException = 500
    
    var hasError : Bool{
        get{
            switch self {
            case .NoException:
                return false;
            case .Processing:
                return false;
            default:
                    return true;
            }
        }
        set{

        }
    }
    
    var description : String{
        get{
            switch self {
                case .CanceledPurchase:
                    return "Покупка отменена"
                case .NoException:
                    return "Нет ошибки"
                case .Processing:
                    return "Запрос обрабатывается"
                case .NoNetwork:
                    return "Отсутствует интернет-соединение"
                case .PaymentNotVerified:
                    return "Не удалось подтвердить покупку. Для подтверждения свяжитесь с разработчиками"
                case .Forbidden:
                    return "В доступе отказано"
                case .Unauthorized:
                    return "Не удалось авторизоваться на сервере"
                case .Conflict:
                    return "Пользователь с таким email уже зарегистрирован"
                case .NotFound:
                        return "По вашему запросу ничего не найдено"
                case .UnsupportedMethod:
                        return "Неверный метод запроса"
                case .UnparsableResponse:
                    return "Неизвестный формат ответа сервера"
                default:
                    return "Неизвестная ошибка"
            }
        }
        set{

        }
    }
}
