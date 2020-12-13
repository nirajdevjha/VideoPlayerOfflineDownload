//
//  VideoListProtocols.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 13/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import Foundation
import UIKit

//MARK:- SECTION PROTOCOLS
protocol VideoListSectionProtocol: class {
    func openVideoDetail(video: VideoModel)
}

enum VideoListSectionType: String {
    case videoList
}

enum VideoListRowModelType {
    case list
}

protocol VideoListRowModel {
    var type: VideoListRowModelType { get }
}

protocol VideoListCardPresenterProtocol {
    var sectionType: VideoListSectionType { get }
    var section: Int { get set }
    func numberOfCells() -> Int
    func willDisplayCellAtIndexPath(_ indexPath: IndexPath)
    func cellModelForRowAtIndex(_ index: Int) -> (VideoListRowModel, VideoListCardPresenterProtocol)?
    func sectionHeaderHeight(_ section: Int) -> CGFloat
    func sectionFooterHeight(_ section: Int) -> CGFloat
    func didSelectCellAtIndexpath(_ indexPath: IndexPath)
}

extension VideoListCardPresenterProtocol {
   
    func willDisplayCellAtIndexPath(_ indexPath: IndexPath) { }
    
    func didSelectCellAtIndexpath(_ indexPath: IndexPath) { }
    
    func heightForRowAtIndex(_ index: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func sectionHeaderHeight(_ section: Int) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func sectionFooterHeight(_ section: Int) -> CGFloat {
        return CGFloat.leastNormalMagnitude
    }
}



//MARK:- VIEW PROTOCOLS
protocol VideoListViewProtocol: class {
    var presenter: VideoListPresenterProtocol? { get set }
        
    // PRESENTER -> VIEW
    func showLoading()
    func hideLoading()
    func reloadPage()
    func disableUserInteraction()
    func enableUserInteraction()
    func showErrorMsg(_ msg: String)
}


//MARK:- PRESENTER PROTOCOLS
protocol VideoListCardDataSource: class {
    func numberOfSections() -> Int
    func numberOfCardInSection(_ section: Int) -> Int
    func sectionDetailAtIndex(_ section: Int) -> VideoListCardPresenterProtocol?
    func sectionFooterHeight(_ section: Int) -> CGFloat
    func cellModelAtIndex(_ indexPath: IndexPath) -> (VideoListRowModel, VideoListCardPresenterProtocol)?
}

protocol VideoListPresenterProtocol: VideoListCardDataSource {
    var interactor: VideoListInteractorInputProtocol? { get set }
    var view: VideoListViewProtocol? { get set }
    var wireFrame: InternalVideoListWireFrameProtocol? { get set }
    
    //VIEW -> PRESENTER
    func viewDidLoad()
    func viewWillAppear()
    func viewWillDisappear()
}

//MARK:- INTERACTOR PROTOCOLS
protocol VideoListInteractorInputProtocol: class {
    var presenter: VideoListInteractorOutputProtocol? { get set }
    var remoteDatamanager: VideoListDataManagerProtocol? { get set }
    func fetchVideoListAPI()
}

protocol VideoListInteractorOutputProtocol: class {
    // INTERACTOR -> PRESENTER
    func didReceiveVideoListResponse(_ response: VideoListResponseModel)
    func didFailToReceiveVideoListResponse(error: VideoListAPIError)
}

//MARK:- DATA MANAGER PROTOCOLS
protocol VideoListDataManagerProtocol: class {
    // INTERACTOR -> REMOTE DATA MANAGER
    func fetchVideoListAPI(completion: @escaping (_ result: Result<VideoListResponseModel, VideoListAPIError>) -> Void)
}

//MARK:- WIRE FRAME PROTOCOLS
protocol VideoListWireFrameProtocol {
    // PRESENTER -> WIREFRAME
    static func createVideoListModule(videoListRef: VideoListView)
}

internal protocol InternalVideoListWireFrameProtocol: VideoListWireFrameProtocol {
    func openVideoDetail(view: VideoListViewProtocol, viewModel: VideoDetailViewModel)
}

