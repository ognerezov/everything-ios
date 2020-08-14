//
//  TextCosumer.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 14.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import Foundation

protocol TextConsumer {
    func receiveText(_ val : String?) -> Void
}
