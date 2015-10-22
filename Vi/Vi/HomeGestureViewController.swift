import UIKit


class HomeGestureViewController: UIViewController {
  
  var stt:SpeechToText = SpeechToText();
  var listening:Bool = false
  var editedTranscript:String = ""
  
  @IBOutlet var transcript: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let upSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    upSwipe.direction = .Up
    view.addGestureRecognizer(upSwipe)
    
    /* Configure Watson */
    let conf:STTConfiguration = STTConfiguration()
    
    conf.audioCodec = WATSONSDK_AUDIO_CODEC_TYPE_OPUS
    
    conf.basicAuthUsername = "11a2a0e4-02dd-4b14-812a-bc9ec34efc3a"
    conf.basicAuthPassword = "r5HEtX7J0tqd"
    
    self.stt = SpeechToText.init(config: conf)
    
    /* Other swip directions */
    
    //    let leftSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    //    leftSwipe.direction = .Left
    //    view.addGestureRecognizer(leftSwipe)
    //    
    //    let rightSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    //    rightSwipe.direction = .Right
    //    view.addGestureRecognizer(rightSwipe)
    //
    //    let downSwipe = UISwipeGestureRecognizer(target: self, action: Selector("handleSwipes:"))
    //    downSwipe.direction = .Down
    //    view.addGestureRecognizer(downSwipe)
  }
  
  func handleSwipes(sender:UISwipeGestureRecognizer) {
    if (sender.direction == .Up) {
      print("Swipe Up")
      listening = !listening
      print("Listening: \(listening)")
      
      self.stt.recognize({ (res: [NSObject:AnyObject]!, err: NSError!) -> Void in
        
        if err == nil {
          if self.stt.isFinalTranscript(res) {
            self.stt.endRecognize()
          }
          self.handleTranscript(self.stt.getTranscript(res))
          NSLog("@%", self.stt.getTranscript(res))
        } else {
          self.stt.endRecognize()
          NSLog("@%", err.localizedDescription)
        }
      });
      
    }
    
//    if (sender.direction == .Left) {
//      print("Swipe Left")
//    }
//    
//    if (sender.direction == .Right) {
//      print("Swipe Right")
//    }
//  
//    if (sender.direction == .Down) {
//      print("Swipe Down")
//    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func handleTranscript(transcript: String) {
    
    let totalString = self.editedTranscript
    let newTranscriptString = transcript
    
    let totalStringAsArray = totalString.characters.split{$0 == " " || $0 == ","}.map(String.init)
    let newTranscriptStringAsArray = newTranscriptString.characters.split{$0 == " " || $0 == ","}.map(String.init)
    
    var i = 0
    var temp = ""
    
    for word in newTranscriptStringAsArray {
      if i >= totalStringAsArray.count {
        temp = ""
      } else {
        temp = totalStringAsArray[i]
      }
      if ( word != temp){
        /* Not working :( */
        self.transcript.text = "\(temp)  \(word)";
      }
      ++i
    }
  }

}