//
//  EmployeeTableViewCell.swift
//  iOSTraineeTaskAvito
//
//  Created by Zhora Agadzhanyan on 18.10.2022.
//

import UIKit

class EmployeeCell: UITableViewCell {
    
    var employee : Employee? {
        didSet {
            nameLabel.text = employee?.name
            phoneLabel.text = employee?.phoneNumber
            skillsLabel.text = employee?.skills.joined(separator: ", ")
        }
    }

    private let imageSize: CGFloat = 100
    
    lazy private var employeeImage: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "placeholder"))
        imgView.contentMode = .scaleAspectFill
        imgView.layer.cornerRadius = self.imageSize / 2
        imgView.clipsToBounds = true
        return imgView
    }()
    
    private let nameLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-Medium", size: 22)
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let phoneLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 18)
        lbl.textAlignment = .right
        return lbl
    }()
    
    private let skillsLabel: UILabel = {
        let lbl = UILabel()
        lbl.font = UIFont(name: "AppleSDGothicNeo-UltraLight", size: 18)
        lbl.textAlignment = .right
        lbl.numberOfLines = 0
        return lbl
    }()
    
    private let name: UILabel = {
        let lbl = UILabel()
        lbl.text = "Name"
        lbl.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 22)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let phone: UILabel = {
        let lbl = UILabel()
        lbl.text = "Phone"
        lbl.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    private let skills: UILabel = {
        let lbl = UILabel()
        lbl.text = "Skills"
        lbl.font = UIFont(name: "AppleSDGothicNeo-Thin", size: 18)
        lbl.textAlignment = .left
        return lbl
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackViewLabels = UIStackView(arrangedSubviews: [nameLabel,phoneLabel,skillsLabel])
        stackViewLabels.distribution = .equalSpacing
        stackViewLabels.axis = .vertical
        stackViewLabels.spacing = 8
        
        let stackView = UIStackView(arrangedSubviews: [name,phone,skills])
        stackView.distribution = .equalSpacing
        stackView.axis = .vertical
        stackView.spacing = 8
        
        addSubview(stackViewLabels)
        addSubview(stackView)
        addSubview(employeeImage)
        
        employeeImage.anchor(
            top: topAnchor,
            left: leftAnchor,
            bottom: nil,
            right: nil,
            paddingTop: 10,
            paddingLeft: 16,
            paddingBottom: 10,
            paddingRight: 0,
            width: imageSize,
            height: imageSize,
            enableInsets: false)
        
        stackView.anchor(
            top: topAnchor,
            left: employeeImage.rightAnchor,
            bottom: nil,
            right: stackViewLabels.leftAnchor,
            paddingTop: 15,
            paddingLeft: 10,
            paddingBottom: 0,
            paddingRight: 0,
            width: 0,
            height: 0,
            enableInsets: false)
        
        stackViewLabels.anchor(
            top: topAnchor,
            left: stackView.rightAnchor,
            bottom: nil,
            right: rightAnchor,
            paddingTop: 15,
            paddingLeft: 10,
            paddingBottom: 0,
            paddingRight: 16,
            width: 0,
            height: 0,
            enableInsets: false)
       
        stackViewLabels.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -20).isActive = true
        
        employeeImage.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -10).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("coder init isn't implemented")
    }
}
