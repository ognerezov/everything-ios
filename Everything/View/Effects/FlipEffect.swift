//
//  FlipEffect.swift
//  Everything
//
//  Created by Sergey Okhotnikov on 29.08.2020.
//  Copyright © 2020 Sergey Okhotnikov. All rights reserved.
//

import SwiftUI

struct FlipEffect: GeometryEffect {

      func effectValue(size: CGSize) -> ProjectionTransform {


            var transform3d = CATransform3DIdentity;

            transform3d = CATransform3DTranslate(transform3d, -size.width/2.0, -size.height/2.0, 0)

            let affineTransform = ProjectionTransform(CGAffineTransform(translationX: size.width/2.0, y: size.height / 2.0))

            return ProjectionTransform(transform3d).concatenating(affineTransform)
      }
}
