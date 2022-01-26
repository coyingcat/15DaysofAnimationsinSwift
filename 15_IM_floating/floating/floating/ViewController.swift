//
//  ViewController.swift
//  floating
//
//  Created by Jz D on 2022/1/27.
//

import UIKit

class ViewController: UIViewController {

    lazy var tipsLabel = FloatingLabel()
    var index = 0
    var textArr = [["赵客缦胡缨，吴钩霜雪明。银鞍照白马，飒沓如流星。十步杀一人，千里不留行。事了拂衣去，深藏身与名。"],[ "闲过信陵饮，脱剑膝前横。将炙啖朱亥，持觞劝侯嬴。三杯吐然诺，五岳倒为轻。眼花耳热后，意气素霓生", "救赵挥金槌，邯郸先震惊。千秋二壮士，烜赫大梁城。纵死侠骨香，不惭世上英。谁能书阁下，白首太玄经"]]
    var keys = [[1] , [2, 3]]
    
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        timer = Timer.scheduledTimer(timeInterval: 25, target: self, selector: #selector(update), userInfo: nil, repeats: true)
        timer?.fire()
    }

    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        tipsLabel.frame = CGRect(x: 5, y: 50, width: UIScreen.main.bounds.size.width - 10, height: 50)
    }
    
    
    @objc func update(){
        guard index < 2 else{ return }
        tipsLabel.addTextArray(textArr[index])
        var idArr = (tipsLabel.tipIdList ?? []) as! [String]
        let idList = keys[index].map { String($0)  }
        idArr.append(contentsOf: idList)
        tipsLabel.tipIdList = NSMutableArray(array: idArr)
        index += 1
    }
}

