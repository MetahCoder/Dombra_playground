/*:
 # Dombra
 
 - Note: Please enable the "Show Rendered Markup" field(Xcode -> Editor -> Show Renderend Markup).
 
 This playground was created by **Askar Almukhametov**.
 

 ## Contents 📂:
 * Overview;
 * Application manual;
 * Resources used;
 
 
 ## Overview 🖊:
 This playground is a simulator of the Kazakh national string instrument - Dombra. 🇰🇿🎼
 
 
 ## Application Manual 📄:
 - Note: To Launch the application please run the playground and check the "Live View" field in the "Adjust Editor Options" menu. Also, please make sure the whole screen is showing and no UI elements are hidden behind the "Live View" frame.
 
 Аfter launching the application, tap anywhere on the screen to open the main one. At the top of the screen is a dombra neck, where in the place of each fret there is a button, the interaction with which will lead to the playback of the corresponding note. You can also play the sounds of the strings, either by pressing individually the vast part of the neck, or by scrolling them together, for a joint sound. You can adjust the tempo of the metronome via the + and - buttons. To turn on the metronome, click on its image. By pressing switches you can vary the look of the UI. By clicking on the question icon, you will be taken to another screen with a description of the project and the instrument.
 
 - Note: In case you are curious how real “kui” or melody would sound like in the playground, please check my [YouTube video]("https://youtu.be/7SVrfFZk6hQ"), where I play Kurmangazy’s “Balbyraun” kui using this simulator. Thank you.
 
 
 ## Resources used 📌:
 The background music - Dauletkerei's "Qosalqa";
 
 The wallpapers are taken from next resources: [wood](https://pxhere.com/en/photo/1370489), [dombra background](https://wallpapermemory.com/345967);
 
 The string texture is taken from this [website]("https://www.dlf.pt/pngs/22155/");
 
 The dombra image is taken from this [website]("https://ru.wikipedia.org/wiki/%D0%94%D0%BE%D0%BC%D0%B1%D1%80%D0%B0#/media/%D0%A4%D0%B0%D0%B9%D0%BB:Kazakh_Dombra2.png");
  
 - Note: There is a bug in my Xcode that you have to run the playground twice to be able to interact with the application. I am not sure, if it is still present at other devices, but in case you run into this problem, please, run the playground second time. Thank you.
 ## Enjoy!
*/

import UIKit
import PlaygroundSupport

// Starter View
let loadingVC = LoadingViewController()
let navVC = UINavigationController(rootViewController: loadingVC)
// Horizontal Orientation
// If you want to change the screen's size, please keep the proportion of this one:
navVC.preferredContentSize = CGSize(width: 668, height: 375)
PlaygroundPage.current.liveView = navVC
