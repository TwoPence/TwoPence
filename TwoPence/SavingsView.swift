//
//  SavingsView.swift
//  TwoPence
//
//  Created by Will Gilman on 4/28/17.
//  Copyright © 2017 Samadhi Tech. All rights reserved.
//

import UIKit
import EFCountingLabel
import PieCharts
import NVActivityIndicatorView

protocol SavingsViewDelegate {
    
    func navigateToTransfersViewController(transfers: [Transfer], transferType: TransferType)
}

class SavingsView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var savedLabel: UILabel!
    @IBOutlet weak var amountSavedLabel: EFCountingLabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var chartView: PieChart!
    @IBOutlet weak var loading: NVActivityIndicatorView!
    
    var delegate: SavingsViewDelegate?
    var transfers = [Transfer]() {
        didSet {
            if transfers.isEmpty {
                self.savedLabel.text = "Total Asset"
                typeTotals = Transfer.assetClasses(transfers: transfers)
                Utils.setupGradientBackground(topColor: AppColor.MediumGray.color.cgColor, bottomColor: AppColor.PaleGray.color.cgColor, view: backgroundView)
                setNeedsDisplay()
            } else {
                typeTotals = Transfer.typeTotals(transfers: transfers)
            }
        }
    }
    var typeTotals = [(type: TransferType, total: Double)]() {
        didSet {
            totalAmountSaved = typeTotals.map({$0.total}).reduce(0, +)
            Timer.schedule(delay: startDelay) { (_) in
                self.amountSavedLabel.countFromZeroTo(CGFloat(self.totalAmountSaved), withDuration: self.withDuration)
            }
            tableView.reloadData()
            setupChart()
        }
    }
    var totalAmountSaved: Double = 0
    var chartThickness: CGFloat = 30
    var chartInset: CGFloat = 68
    var withDuration: CFTimeInterval = 1.0
    var startDelay: CFTimeInterval = 0.5
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        initSubviews()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    func initSubviews() {
        let nib = UINib(nibName: "SavingsView", bundle: nil)
        nib.instantiate(withOwner: self, options: nil)
        contentView.frame = bounds
        addSubview(contentView)
        
        loading.type = .ballPulse
        amountSavedLabel.formatBlock = { (value) in return Double(value).money(round: true) }
        amountSavedLabel.method = .easeOut
        
        Utils.setupGradientBackground(topColor: AppColor.DarkSeaGreen.color.cgColor, bottomColor: AppColor.MediumGreen.color.cgColor, view: backgroundView)
        
        setupTableView()
    }
    
    func setupTableView() {
        let cell = UINib(nibName: "TransferTypeCell", bundle: nil)
        tableView.register(cell, forCellReuseIdentifier: "TransferTypeCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.rowHeight = (tableView.bounds.size.height - 49) / 3
        tableView.bounces = true
        tableView.tableFooterView = UIView()
    }
    
    func setupChart() {
        let width = chartView.bounds.width
        chartView.selectedOffset = 10
        chartView.animDuration = 0.0
        chartView.innerRadius = width / 2 - chartInset - chartThickness
        chartView.outerRadius = width / 2 - chartInset
        chartView.referenceAngle = 270
        chartView.delegate = self
        chartView.models = createModels()
        Timer.schedule(delay: startDelay) { (_) in
            self.chartView.animDuration = self.withDuration
            self.updateChart()
        }
    }
    
    fileprivate func createModels() -> [PieSliceModel] {
        var slices = [PieSliceModel]()
        for typeTotal in typeTotals {
            let fakeSlice = PieSliceModel(value: 0.1, color: typeTotal.type.color, obj: typeTotal.type.rawValue as String)
            slices.append(fakeSlice)
        }
        
        return slices
    }
    
    func updateChart() {
        var index = 0
        for typeTotal in typeTotals {
            let slice = PieSliceModel(value: typeTotal.total, color: typeTotal.type.color, obj: typeTotal.type.rawValue as String)
            chartView.insertSlice(index: index, model: slice)
            index += 1
        }
    }
    
    func loadingStart(){
        amountSavedLabel.isHidden = true
        savedLabel.isHidden = true
        loading.isHidden = false
        loading.startAnimating()
    }
    
    func loadingEnd(){
        amountSavedLabel.isHidden = false
        savedLabel.isHidden = false
        loading.isHidden = true
        loading.stopAnimating()
    }
}

extension SavingsView: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeTotals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TransferTypeCell", for: indexPath) as! TransferTypeCell
        cell.typeTotal = typeTotals[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let type = typeTotals[indexPath.row].type
        let filtered = transfers.filter({$0.type == type})
        delegate?.navigateToTransfersViewController(transfers: filtered, transferType: type)
    }
}

extension SavingsView: PieChartDelegate {

    func onSelected(slice: PieSlice, selected: Bool) {
        if selected {
            UIView.animate(withDuration: 0.2, animations: {
                self.savedLabel.alpha = 0.0
                self.amountSavedLabel.alpha = 0.0
            })
            savedLabel.text = slice.data.model.obj as? String
            let selectedAmount = CGFloat(slice.data.model.value)
            amountSavedLabel.countFromCurrentValueTo(selectedAmount, withDuration: 0.0)
            UIView.animate(withDuration: 0.2, animations: {
                self.savedLabel.alpha = 1.0
                self.amountSavedLabel.alpha = 1.0
            })
        } else {
            UIView.animate(withDuration: 0.2, animations: {
                self.savedLabel.alpha = 0.0
                self.amountSavedLabel.alpha = 0.0
            })
            savedLabel.text = "Total Saved"
            amountSavedLabel.countFromCurrentValueTo(CGFloat(totalAmountSaved), withDuration: 0.0)
            UIView.animate(withDuration: 0.2, animations: {
                self.savedLabel.alpha = 1.0
                self.amountSavedLabel.alpha = 1.0
            })
        }
    }
}
