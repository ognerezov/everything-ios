//
//  ErrorTypes.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 01.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

enum ErrorType: Int{
    case UnparsableResponse = -4
    case WaitForEmail = -3
    case TimeOut = -2
    case Processing = -1
    case NoNetwork = 0
    case PasswordsNotTheSame = 77
    case NoException = 200
    case WrongRequest = 400
    case Unauthorized = 401
    case Forbidden = 403
    case NotFound = 404
    case Conflict = 409
    case Gone = 410
    case DisabledUser = 418
    case WrongTempToken = 422
    case FailedDependency = 424
    case ModificationProhibited = 451
    case ServerException = 500
}
