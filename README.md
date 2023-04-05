# Breaker 

![120](https://user-images.githubusercontent.com/113778995/230164795-95051e09-6fe7-4f2d-98df-2f89a587a91c.png)

## Introduction

Breaker is an app that sends you notifications at a specified duration on repeat until you cancel. Soon to be on the App Store. Breaker was created as a way for me to test how to use push notifications and a break timer felt like a very fitting app to make to implement that feature.

## Skills used

* SwiftUI
* Local notifications (using repeat)
* Lots of math

## Process and challengers

Because I had used UIKit in all my other projects (aside from widgets), I wanted to try my hand at creating something entirely with SwiftUI. Because I didn't know how to use most of it, a large, ambitious project requiring a complex design wasn't in the cards. By keeping the concept simple with few elements, it allowed me to focus on learning how SwiftUI works while implementing a few other things I didn't know before, namely push notifications.

Starting with the UI, I wanted a circular slider instead of just picking the time. This was the main factor in choosing SwiftUI for the app because almost all the examples and tutorials I saw creating one used SwiftUI and not UIKit. Creating the slider itself was rather simple. However, having the slider adjust and display the correct length of time for the notification duration based on its angle was another matter. Being that it was math over my head (or atleast that I don't remember), I needed help in getting all the calculations correct. But after finding a different tutorial going through exactly what I needed, I was able to then display the time in hours and minutes in the center of the circular slider to indicate how long between notifications it would be. 

<img src="https://user-images.githubusercontent.com/113778995/230167579-c9a986eb-f95f-4c47-aacc-ea67fcb740f7.png" width="200">


After getting the UI down, I needed to implement the notifications themselves. I had tested out the code in a dummy project earlier so it was pretty easy to them copy them and put them into Breaker. I had tested around with the repeat option and found it worked better to simply have it repeat until users manually cancel them instead of having an specific end date involved. That way users can just let notifications come until they don't want them anymore. They don't need to know a specific end time.

<img src="https://user-images.githubusercontent.com/113778995/230167733-9cb35a30-b36f-4474-82e6-10be33d3512a.png" width="200"> <img src="https://user-images.githubusercontent.com/113778995/230167737-f99fecad-3431-45c7-8533-f51f8f2ead72.png" width="200">

After those two aspects were completed, the app was finished with how it was originally intented.

## Reflection

Using SwiftUI for the project was a good choice as it was an opportunity to learn something new, as well as being what I think as the best way to create this type of UI design. I'm not sure if UIKit would've gotten the same results or not. But I prefer using SwiftUI for interactive designs like the circular slider.

Now I just need to imporve my math skills...

