//
//  SettingsViewController.swift
//  NewsApp
//
//  Created by Danylo Kushlianskyi on 18.07.2023.
//

import UIKit

class ThemeViewController: UIViewController {
    
    // MARK: - UI Elements
    lazy var segmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: Constants.ThemesViewController.themeItems)
        segmentedControl.selectedSegmentIndex = UserDefaults.standard.theme.rawValue
        segmentedControl.addTarget(self, action: #selector(segmentedControlValueChanged(_:)), for: .valueChanged)
        return segmentedControl
    }()
    
    // MARK: - Properties
    private var theme: Theme {
        get {
            return UserDefaults.standard.theme
        }
        set {
            UserDefaults.standard.theme = newValue
            configureStyle(for: newValue)
        }
    }
    
    // MARK: - Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    private func configureStyle(for theme: Theme) {
        view.window?.overrideUserInterfaceStyle = theme.userInterfaceStyle
    }
    
    // MARK: - Actions
    @objc
    private func segmentedControlValueChanged(_ sender: UISegmentedControl) {
        theme = Theme(rawValue: sender.selectedSegmentIndex) ?? .device
    }
     
    // MARK: - Configurational Methods
    private func setupUI() {
        view.backgroundColor = .systemGray6
        setupSegmentedControl()
    }
    
    private func setupSegmentedControl() {
        view.addSubview(segmentedControl)
        segmentedControl.snp.makeConstraints { make in
            make.leading.top.equalToSuperview().offset(30)
            make.trailing.equalToSuperview().inset(30)
            make.height.equalTo(50)
        }
    }
}
