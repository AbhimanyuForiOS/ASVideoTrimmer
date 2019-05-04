# ASVideoTrimmer

Android Whatsapp Video trimmer is available for iOS as well :-  

![6Vo3PMRiZP](https://user-images.githubusercontent.com/7630897/56914851-cc03fa80-6ad2-11e9-86bb-a7fb4edec03a.gif)


We made it for iOS Community. It's fully configurable (we are giving optional configuration model for user's needful modification).


Simple Integration Process:- 

1. Copy and Paste these 4  folders from ASVideoTrimmer Project to your project  :- 

```
- Configuration
- Libs
- Model
- View
```


2. Copy  & paste one demo video file as well from ASVideoTrimmer Project to your project :-

`- test.m4v`


3. Go to your ViewController from where you want to open ASVideoTrimmer  and register its delegates of ASVideoTrimmerViewDelegate:-

```
extension ViewController:ASVideoTrimmerViewDelegate{
    //MARK:- ASVideoTrimmerViewDelegate
    func cancel(message: String) {
        print(message)
    }
    //Final result
    func croped(trimedVideoUrl: URL?) {
        if let url = trimedVideoUrl {
          //play with your croped video
        }
    }
}

```


4. Set Up A UIButton and make it's action from where you can call  ASVideoTrimmer :-
```

    //MARK:- UIButton Actions
    @IBAction func btnOpenVideoTrimmerTaped(_ sender: Any) {
        //set trimmer
        if let path = Bundle.main.path(forResource: "test", ofType:"m4v")  {
            ASVideoTrimmerView.shared.setTrimmerOn(controller: self, configuration:TrimmerConfig(orignalPath:   path))
            ASVideoTrimmerView.shared.delegate = self
        }
    }
```
    
5. Take All .pngs from Assets of  ASVideoTrimmer to your porject.    
    
    
   
6. You can Play with Configuration of  ASVideoTrimmerView, all  values are optional and   you can change accroding to your need :-

Configuration files are  :-

```
 - TrimmerConfig
 - VideoQualityConfig
 - SliderConfig
```

_There are lots of properties you can change like trim **Trimming limit , UI** Changes Etc._
