//
//  ContentView.swift
//  Breaker
//
//  Created by Ben Gauger on 4/1/23.
//

import SwiftUI

struct ContentView: View {
    
    //MARK: - properties
    @State var startAngle: Double = 0
    @State var toAngle: Double = 180
    
    @State var startProgress: CGFloat = 0
    @State var toProgress: CGFloat = 0.5
    
    @State private var selectedDate = Date()
    @State private var textFieldNumber = 0.0
    let notify = NotificationHandler()
    
    @State private var timeAlert = false
    @State private var successAlert = false
    @State private var cancelAlert = false
    
//    @State var timeCount = timeLeft
    
    @State private var startedReminders = false
    
    
    
    
    var body: some View {
        
        
        
        let hoursInSeconds = getTimeDifference().0 * 3600
        let minutesInSeconds = getTimeDifference().1 * 300
        
        @State var timeInSeconds = hoursInSeconds + minutesInSeconds
        
        @State var timeLeft = hoursInSeconds + minutesInSeconds
     
        @State var pause = false
        
        let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
        
        
        var nextReminder = Date().addingTimeInterval(TimeInterval(timeInSeconds))
        
        var nextReminderTimer = Timer.publish(every: TimeInterval(timeInSeconds), on: .main, in: .common)
        
        
        VStack {
            HStack{
                VStack(spacing: 8){
                    Text("\(Date(), style: .date)"
                    )
                        .font(.title.bold())
                }
                .frame(maxWidth:.infinity, alignment: .center)
            }
            Text ("How long between reminders?")
                .foregroundColor(.black)
//                .scaledToFit()
                .font(.system(size: 40))
                .minimumScaleFactor(0.5)
                .bold()
                .padding(.top, 20)
                .multilineTextAlignment(.center)
                Spacer()
            CircularSlider()
                .padding(.top, 50)
            HStack{
                Button("Start new reminders"){
                    notify.sendNotification(
                        date: Date(),
                        type: "time",
                        timeInterval: Double(timeInSeconds),
                        title: "Take a break!",
                        body: "This is your reminder to do something else.")
                    if timeInSeconds < 3599 {
                        timeAlert = true
                    }
                    if timeInSeconds > 3599 {
                        successAlert = true
                        startedReminders = true
                    }
                    
                    print("\(timeInSeconds) time")
                    print(startedReminders)
                }
            
    
                
                .alert("Too short!", isPresented: $timeAlert, actions: {
                    
                }, message: {
                    Text("Your reminders must be at least 60 minutes apart.")
                })
                .alert("Reminder set!", isPresented: $successAlert, actions: {
                    
                }, message: {
                    Text("You will be reminder to take a break every \(getTimeDifference().0) hrs, \(getTimeDifference().1 * 5) min. Don't forget to stop reminders when you're done needing them.")
                })
//                .font(.system(size: 25))
                .padding (.trailing, 35)
                Button("Stop all reminders"){
                    notify.cancelNotifications()
                    cancelAlert = true
                    timer.upstream.connect().cancel()
                }
                .alert("Reminders stopped!", isPresented: $cancelAlert, actions: {
                    
                }, message: {
                    Text("You will no longer receieve reminders until you start new ones.")
                })
                .foregroundColor(.red)
                
                .padding (.leading, 35)
            }
            .font(.system(size: 25))
            .minimumScaleFactor(0.4)
            .padding(.top, 45)
            .padding(.bottom, 15)
            Spacer()

            VStack{
                Text("Next reminder at:")
                    .font(.system(size: 28))
                    .minimumScaleFactor(0.4)
                    .bold()
                    .padding(.bottom, 3)
                Text("\(nextReminder, style: .time)")
                    .font(.system(size: 20))
                Text("\(nextReminder, style: .date)")
            }
        }
        
        
        
        .padding()
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    //MARK: - Circular Slider
    @ViewBuilder
    func CircularSlider() -> some View{
        
        GeometryReader{proxy in
            
            let width = proxy.size.width
            
            
            ZStack{
                //MARK: - clock design
                ZStack{
                    ForEach(1...60, id: \.self){index in
                        Rectangle()
                            .fill(index % 5 == 0 ? .black : .gray)
                            .frame(width: 2, height: index % 5 == 0 ? 10 : 3)
                            .offset(y: (width - 60) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 6))
                    }
                    
                    let texts = [6, 7, 8, 9, 10, 11, 0, 1, 2, 3, 4, 5]
                    ForEach(texts.indices, id: \.self){index in
                        Text("\(texts[index])")
                            .font(.system(size: 15).bold())
                            .foregroundColor(.black)
                            .rotationEffect(.init(degrees: Double(index) * -30))
                            .offset(y: (width - 100) / 2)
                            .rotationEffect(.init(degrees: Double(index) * 30))
                    }
                }
                Circle()
                    .stroke(.black.opacity(0.06), lineWidth: 40)
                
                Circle()
                    .trim(from: startProgress, to: toProgress)
                    .stroke(Color(.cyan), style: StrokeStyle(
                        lineWidth: 40,
                        lineCap: .round,
                        lineJoin: .round))
                    .rotationEffect(.init(degrees: -90))
                
                Circle()
                    .stroke(.gray.opacity(0.06), lineWidth: 5)
                    .font(.callout)
                    .frame(width: 35, height: 35)
                    .background(.white, in: Circle())
                    .offset(x: width / 2)
                
                    .rotationEffect(.init(degrees: toAngle))
                
                    .gesture(
                        DragGesture()
                            .onChanged({ value in
                                onDrag(value: value)
                            })
                    )
                    .rotationEffect(.init(degrees: -90))
                
                //MARK: - Time Text
                VStack(spacing: 8){
                    Text("\(getTimeDifference().0) hrs")
                        .font(.title.bold())
                    
                    Text("\(getTimeDifference().1 * 5) min")
                        .foregroundColor(.gray)
                }
                .scaleEffect(1.1)
            }
        }
        .frame(width: screenBounds().width / 1.6, height: screenBounds().width / 1.6)
    }
    
    func onDrag(value: DragGesture.Value, fromSlider: Bool = false) {
        
        let vector = CGVector(dx: value.location.x, dy: value.location.y)
        
        let radians = atan2(vector.dy - 15, vector.dx - 15)
        
        var angle = radians * 180 / .pi
        if angle < 0{angle = 360 + angle}
        
        let progress = angle / 360
        
        if fromSlider{
            self.startAngle = angle
            self.startProgress = progress
        }else{
            self.toAngle = angle
            self.toProgress = progress
        }
        
    }
    
    func getTime(angle: Double) -> Date {
        
        let progress = angle / 30
        
        let hour = Int(progress)
        let remainder = (progress.truncatingRemainder(dividingBy: 1) * 12).rounded()
        
        var minute = remainder * 5
        minute = (minute > 55 ? 55 : minute)
        
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss"
        
        if let date = formatter.date(from: "\(hour):\(Int(remainder)):00"){
            return date
        }
        return .init()
    }
    
    func getTimeDifference() -> (Int, Int) {
        let calendar = Calendar.current
        
        let result = calendar.dateComponents([.hour, .minute], from:  getTime(angle: startAngle), to: getTime(angle: toAngle))
        
        return (result.hour ?? 0, result.minute ?? 0)
    }
    

    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//MARK: - Extensions

extension View {
    
    func screenBounds() -> CGRect {
        return UIScreen.main.bounds
    }
}
