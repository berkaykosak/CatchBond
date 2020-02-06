//
//  ViewController.swift
//  FotografiYakala
//
//  Created by Berkay Kosak on 4.02.2020.
//  Copyright © 2020 Berkay Kosak. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //variables.
    var score = 0 //Her yerden ulaşmak için buraya yazdık.
    var timer = Timer()
    var counter = 0
    var bondArray = [UIImageView]() // UIImageView lardan oluşan dizimizi tanıttık.
    var hideTimer = Timer ()
    var rekorSkor = 0
    
    
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var skorLabel: UILabel!
    @IBOutlet weak var rekorLabel: UILabel!
    @IBOutlet weak var bond1: UIImageView!
    @IBOutlet weak var bond2: UIImageView!
    @IBOutlet weak var bond3: UIImageView!
    @IBOutlet weak var bond4: UIImageView!
    @IBOutlet weak var bond5: UIImageView!
    @IBOutlet weak var bond6: UIImageView!
    @IBOutlet weak var bond7: UIImageView!
    @IBOutlet weak var bond8: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        skorLabel.text = "Skor: \(score)"
        
        //high score , rekor kontrol..
        let storedRekor = UserDefaults.standard.object(forKey: "rekor")
        
        if storedRekor == nil {
            rekorSkor = 0
            rekorLabel.text = "Rekor: \(rekorSkor)"
        }
        
        if let newSkor = storedRekor as? Int {
            rekorSkor = newSkor
            skorLabel.text = "Rekor : \(rekorSkor)"
        }
        
        //Images
        bond1.isUserInteractionEnabled = true // görselin üzerine tıklanmasını etkin hale getiriyor.
        bond2.isUserInteractionEnabled = true
        bond3.isUserInteractionEnabled = true
        bond4.isUserInteractionEnabled = true
        bond5.isUserInteractionEnabled = true
        bond6.isUserInteractionEnabled = true
        bond7.isUserInteractionEnabled = true
        bond8.isUserInteractionEnabled = true
        
        
        
        let recognizer1 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer2 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer3 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer4 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer5 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer6 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer7 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
        let recognizer8 = UITapGestureRecognizer(target: self, action: #selector(increaseScore))
    
        //BU ALANDA HER GÖRSELE BASILINCA YAPILACAK İŞLEM BELİRTİLDİ ( increaseScore fonksiyonu çağırıldı...
        
       

        bond1.addGestureRecognizer(recognizer1) //HER GÖRSEL İÇİN DOKUNMATİK KISIM OLUŞTURULDU.
        bond2.addGestureRecognizer(recognizer2)
        bond3.addGestureRecognizer(recognizer3)
        bond4.addGestureRecognizer(recognizer4)
        bond5.addGestureRecognizer(recognizer5)
        bond6.addGestureRecognizer(recognizer6)
        bond7.addGestureRecognizer(recognizer7)
        bond8.addGestureRecognizer(recognizer8)
        
        //en yukarıda tanıttığımız dizinin içerisini doldurduk.
        bondArray = [bond1, bond2, bond3, bond4, bond5, bond6, bond7, bond8]
        
        
        //Timers
        counter = 10
        timeLabel.text = String(counter)
        
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(countDown), userInfo: nil, repeats: true)
        
        hideTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(resmiSakla), userInfo: nil, repeats: true)
        
        resmiSakla()
    }
    
    @objc func resmiSakla(){ // Görselleir sakladığımız fonksiyon
        
        for bond in bondArray { //bond dizisi içindeki tüm görselleri sırayla sakla..
            bond.isHidden = true
        }
        
        let random = Int (arc4random_uniform(UInt32(bondArray.count - 1))) //dizimizin içindeki görsel sayısı kadar ( o yüzden -1 yaptık) random üretiyor... Int döndürmesi için Int içinde yazdık.
        bondArray[random].isHidden = false // en başta hepsini saklamıştık. burada üretilen random sayıdaki bond resmini açıyoruz.
    }

    @objc func increaseScore(){ //skor işlemlerini yapan fonk.
        score += 1
        skorLabel.text = "Skor: \(score)"
        
    }

    @objc func countDown(){  // sayaç işlemlerini yapan fonksiyon
        counter -= 1
        timeLabel.text = String(counter)
        
        if counter == 0 {
            timer.invalidate() //timer ı durduran fonksiyon
            hideTimer.invalidate()
            
            for bond in bondArray { //süre bittiği için tekrar tüm görselleri sakla.
                bond.isHidden = true
            }
            // Yüksek skor-Rekor Kısmı
            
            if self.score > self.rekorSkor {
                self.rekorSkor = self.score
                rekorLabel.text = "Rekor : \(self.rekorSkor)"
                UserDefaults.standard.set(self.rekorSkor, forKey: "rekor")
            }
            
            
            //Alert
            
            let alert = UIAlertController(title: "Süre Doldu", message: "Tekrar oynamak ister misin ?", preferredStyle: UIAlertController.Style.alert)
        
            let okButton = UIAlertAction(title: "OK", style: UIAlertAction.Style.cancel, handler: nil)
            
            // Sourcetree deneme
            
            let tekrarOyna = UIAlertAction(title: "Tekrar Oyna", style: UIAlertAction.Style.default) { (UIAlertAction) in
                self.score = 0
                self.skorLabel.text = "Skor: \(self.score)"
                self.counter = 10
                self.timeLabel.text = String(self.counter)
                
                self.timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.countDown), userInfo: nil, repeats: true)
                     
                self.hideTimer = Timer.scheduledTimer(timeInterval: 0.6, target: self, selector: #selector(self.resmiSakla), userInfo: nil, repeats: true)
            }
        
            alert.addAction(okButton)
            alert.addAction(tekrarOyna)
            self.present(alert, animated: true, completion: nil)
        }
    }
}

