//
//  VideoContentRouter.swift
//  MovieDB
//
//  Created by Aryuna on 8/17/19.
//  Copyright © 2019 Aryuna. All rights reserved.
//

import Foundation
import UIKit

class VideoContentDetailRouter {
    static func videoDetailScreen(videoContent: VideoContent) -> UIViewController {
        let viewModel = VideoContentDetailViewModel(videoContent: videoContent)
        return VideoContentDetailViewController(viewModel: viewModel)
    }
    
    static func navigateToVideoDetail(videoContent: VideoContent, presenter: UIViewController){
        let videoDetailScreen = VideoContentDetailRouter.videoDetailScreen(videoContent: videoContent)
        presenter.navigationController?.pushViewController(videoDetailScreen, animated: true)
    }
}
