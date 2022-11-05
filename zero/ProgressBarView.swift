//
//  ProgressBarView.swift
//  localmeal
//
//  Created by Giacomo Pessotto on 15/10/2022.
//

import SwiftUI

func getCurrentTime() -> String {
    
    let formatter = DateFormatter()
    
    formatter.dateFormat = "HH:mm"
    
    let dateString = formatter.string(from: Date())
    
    return dateString
    
}


@available(iOS 14.0, *)
struct ProgressBarView: View {
    
    
    var width: CGFloat = 40
    var width2: CGFloat = 20
    var height: CGFloat = 650
    var percent: CGFloat = 40
    var color1 = Color(#colorLiteral(red: 0.008723784238, green: 0.003757854225, blue: 0.06711191684, alpha: 1))
    var color2 = Color(#colorLiteral(red: 0.2274479568, green: 0.2274533808, blue: 0.3249559999, alpha: 1))
    var color3 = Color(#colorLiteral(red: 0.3638103604, green: 0.3687961102, blue: 0.5504899621, alpha: 1))
    var color4 = Color(#colorLiteral(red: 0.7054255605, green: 0.685606122, blue: 0.7843497992, alpha: 1))
    var color5 = Color(#colorLiteral(red: 0.6547746658, green: 0.8968927264, blue: 0.9998813272, alpha: 1))
    var color6 = Color(#colorLiteral(red: 0.3954110742, green: 0.7576047182, blue: 0.9056802988, alpha: 1))
    var color7 = Color(#colorLiteral(red: 0.1486490965, green: 0.4533722401, blue: 0.6686558127, alpha: 1))
    var color8 = Color(#colorLiteral(red: 0.147798866, green: 0.3456805944, blue: 0.536555469, alpha: 1))
    var color9 = Color(#colorLiteral(red: 0.597016871, green: 0.4034359157, blue: 0.2148686647, alpha: 1))
    var color10 = Color(#colorLiteral(red: 0.03490232304, green: 0.0150257526, blue: 0.002458022442, alpha: 1))
    var colorbar = Color(#colorLiteral(red: 0.9372549653, green: 0.9372549057, blue: 0.9372549057, alpha: 1))
    var colortik = Color(#colorLiteral(red: 0.3028197885, green: 0.2489978969, blue: 0.7736282945, alpha: 1))
    
    private var sArray = ["1", "2", "3", "4", "5", "6","7", "8", "9", "10", "11", "12","13", "14", "15", "16", "17", "18","19", "20", "21", "23", "24", "25","26"]
    private var sArray2 = ["00:00","23:00","22:00","21:00","20:00","19:00","18:00","17:00","16:00","15:00","14:00","13:00","12:00","11:00","10:00","09:00","08:00","07:00","06:00","05:00","04:00","03:00","02:00","01:00","00:00"]
    
    @State var isShowPopup: Bool = false
    @State private var dragPosition = CGPoint.zero
    @State private var rects = [Int: CGRect]()
    @State private var selected = -1
    
    @State var currentTime = getCurrentTime()
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    var dateFormatter: DateFormatter {
            let fmtr = DateFormatter()
            fmtr.dateFormat = "HH:mm"
            return fmtr
        
    }
    
    @State var startsize: CGFloat = 20
    var body: some View {
        
        ZStack{
            
            colorbar
                            .ignoresSafeArea()
            
            
            VStack(alignment: .center){
                
                
                
                Text(currentTime)
                    .padding()
                    .frame(width: 170,height: 20)
                    .font(.system(size: 30))
                    .padding(4)
                    .onReceive(timer) { _ in
                        self.currentTime = dateFormatter.string(from: Date())
                    }
                
                
                let stripped = String(currentTime.dropFirst(3))
                let stripped2 = String(currentTime.dropLast(3))
                let mins =  Int(stripped)
                let hours = Int(stripped2)
                
                let percentage =  1 - (((Double((mins ?? 0)) + Double((hours ?? 0))*60) / 1440) )
                let coversize  = 650*percentage
                
                ZStack(alignment: .top)  {
                    
                    
                    Rectangle()
                        .frame(width: 60, height: 650)
                        .foregroundColor(.clear)
                        .background(colorbar)
                        .shadow(radius: 0)
                        .offset(x: 30)
                        .padding(1)
                        .gesture(DragGesture(minimumDistance: 0, coordinateSpace: .global)
                            .onChanged { dragGesture in
                                self.dragPosition = dragGesture.location
                                if let (id, _) = self.rects.first(where: { (_, value) -> Bool in
                                    value.minY < dragGesture.location.y && value.maxY > dragGesture.location.y
                                }) { self.selected = id }}
                                 
                            .onEnded{ DragGesture in
                                self.dragPosition = DragGesture.location
                                if let (id, _) = self.rects.first(where: {(_, value) ->
                                    Bool in
                                    value.maxY < DragGesture.location.y && value.minY >
                                    DragGesture.location.y
                                    
                                }) {self.selected = -1}
                                
                            })
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .frame(width: width, height: height)
                        .background(LinearGradient(colors: [color1,color2,color3,color4,color5,color6,color7,color8,color9,color10], startPoint: .bottom, endPoint: .top).clipShape(RoundedRectangle(cornerRadius: 15,style: .continuous)))
                            .foregroundColor(.clear)
                    
                    RoundedRectangle(cornerRadius: 15, style: .continuous)
                        .frame(width: width,height: coversize)
                        .foregroundColor(colorbar)
                    
                    VStack(alignment: .leading, spacing: 11){
                        
                        ForEach(0..<sArray2.count) { id in
                            Label {
                                Text("\(self.sArray2[id])")
                                    .foregroundColor(id == self.selected ? Color(#colorLiteral(red: 0.3028197885, green: 0.2489978969, blue: 0.7736282945, alpha: 1)) : .clear)
                                    .font(.footnote)
                                    .background(self.rectReader(for: id))
                                    .clipShape(Capsule())
                                    .animation(.easeIn(duration: 0.1))
                                    .offset(x: id == self.selected ? -70: -60)
                                
                            } icon: {
                                RoundedRectangle(cornerRadius: 0)
                                    .fill(Color(#colorLiteral(red: 0.3028197885, green: 0.2489978969, blue: 0.7736282945, alpha: 1)))
                                    .background(self.rectReader(for: id))
                                    .animation(.easeIn(duration: 0.2))
                                    .frame(width: 20, height: 2)
                                    .offset(x: id == self.selected ? 80 : 60)
                                
                            }
                        }
                    }
                }
            }
        }
    }
    
    func rectReader(for key: Int) -> some View {
        return GeometryReader { gp -> AnyView in
            let rect = gp.frame(in: .global)
            DispatchQueue.main.async {
                self.rects[key] = rect
            }
            return AnyView(Rectangle().fill(Color.clear))
        }
    }
}

@available(iOS 14.0, *)
struct ProgressBarView_Previews: PreviewProvider {
    static var previews: some View {
        ProgressBarView()
    }
}
