//
//  VideoListView.swift
//  VideoPlayerOfflineDownload
//
//  Created by Niraj Kumar Jha on 12/12/20.
//  Copyright © 2020 Niraj Kumar Jha. All rights reserved.
//

import UIKit

class VideoListView: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView()
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        activityIndicator.style = .large
        activityIndicator.color = .white
        return activityIndicator
    }()
    
    private lazy var clearDownloadsBtn: UIBarButtonItem = {
        let button = UIButton(type: .custom)
        button.setTitle("Reset", for: .normal)
        button.setTitleColor(UIColor(red: 0/255, green: 140/255, blue: 255/255, alpha: 1.0), for: .normal)
        button.addTarget(self, action: #selector(didTapClear), for: .touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        return barButton
    }()
    
    var presenter: VideoListPresenterProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        VideoListWireFrame.createVideoListModule(videoListRef: self)
        setupViews()
        presenter?.viewDidLoad()
    }
    
    private func setupViews() {
        title = "Video List"
        navigationItem.rightBarButtonItem = clearDownloadsBtn
        view.addSubview(activityIndicator)
        NSLayoutConstraint.activate([
            activityIndicator.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ])
        VideoListCellBuilder.registerCells(to: tableView)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    @objc
    private func didTapClear() {
        presenter?.clearDownloadsTapped()
    }
}

extension VideoListView: VideoListViewProtocol {
    func showLoading() {
       activityIndicator.startAnimating()
    }
    
    func hideLoading() {
      activityIndicator.stopAnimating()
    }
    
    func reloadPage() {
        tableView.reloadData()
    }
    
    func disableUserInteraction() {
        view.isUserInteractionEnabled = false
    }
    
    func enableUserInteraction() {
       view.isUserInteractionEnabled = true
    }
    
    func showErrorMsg(_ msg: String) {
        UIAlertController.showErrorMsgAlert(from: self, title: "OK", msg: msg, okHandler: nil)
    }
}

extension VideoListView: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        return presenter.numberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let presenter = presenter else {
            return 0
        }
        return presenter.numberOfCardInSection(section)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let (cellModel, actionDelegate) = presenter?.cellModelAtIndex(indexPath) else {
            return UITableViewCell()
        }
        
        return VideoListCellBuilder.getTableViewCell(atIndexPath: indexPath, from: cellModel, forTableView: tableView, actionDelegate: actionDelegate)
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
}

extension VideoListView: UITableViewDelegate {
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let height: CGFloat = presenter?.sectionDetailAtIndex(indexPath.section)?.heightForRowAtIndex(indexPath.row) else {
            return UITableView.automaticDimension
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        guard let height: CGFloat =  presenter?.sectionDetailAtIndex(section)?.sectionHeaderHeight(section) else {
            return CGFloat.leastNormalMagnitude
        }
        return height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        guard let height: CGFloat =  presenter?.sectionDetailAtIndex(section)?.sectionFooterHeight(section) else {
            return CGFloat.leastNormalMagnitude
        }
        return height
    }
    
    public func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let presenter = presenter,
            let sectionDetail = presenter.sectionDetailAtIndex(indexPath.section) else {
                return
        }
        sectionDetail.willDisplayCellAtIndexPath(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let presenter = presenter,
            let sectionDetail = presenter.sectionDetailAtIndex(indexPath.section) else {
                return
        }
        sectionDetail.didSelectCellAtIndexpath(indexPath)
    }
}

