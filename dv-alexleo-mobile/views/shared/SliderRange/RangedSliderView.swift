import SwiftUI

struct RangedSliderView: View {
    @Binding var currentValue: ClosedRange<Float>
    let sliderBounds: ClosedRange<Int>
    
    public init(value: Binding<ClosedRange<Float>>, bounds: ClosedRange<Int>) {
        self._currentValue = value
        self.sliderBounds = bounds
    }
    
    var body: some View {
        GeometryReader { geometry in
            sliderView(sliderSize: geometry.size)
        }
    }
    
    @ViewBuilder private func sliderView(sliderSize: CGSize) -> some View {
        let sliderViewYCenter = sliderSize.height / 2
        ZStack {
            RoundedRectangle(cornerRadius: 2)
                .fill(Color.gray.opacity(0.3)) // Remplacement de .nojaPrimary30
                .frame(height: 4)
            
            ZStack {
                let sliderBoundDifference = sliderBounds.count
                let stepWidthInPixel = CGFloat(sliderSize.width) / CGFloat(sliderBoundDifference)
                
                let leftThumbLocation: CGFloat = currentValue.lowerBound == Float(sliderBounds.lowerBound)
                    ? 0
                    : CGFloat(currentValue.lowerBound - Float(sliderBounds.lowerBound)) * stepWidthInPixel
                
                let rightThumbLocation = CGFloat(currentValue.upperBound) * stepWidthInPixel
                
                lineBetweenThumbs(from: .init(x: leftThumbLocation, y: sliderViewYCenter),
                                  to: .init(x: rightThumbLocation, y: sliderViewYCenter))
                
                thumbView(position: CGPoint(x: leftThumbLocation, y: sliderViewYCenter), value: currentValue.lowerBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location.x
                        let xThumbOffset = min(max(0, dragLocation), sliderSize.width)
                        let newValue = Float(sliderBounds.lowerBound) + Float(xThumbOffset / stepWidthInPixel)
                        if newValue < currentValue.upperBound {
                            currentValue = newValue...currentValue.upperBound
                        }
                    })
                
                thumbView(position: CGPoint(x: rightThumbLocation, y: sliderViewYCenter), value: currentValue.upperBound)
                    .highPriorityGesture(DragGesture().onChanged { dragValue in
                        let dragLocation = dragValue.location.x
                        let xThumbOffset = min(max(CGFloat(leftThumbLocation), dragLocation), sliderSize.width)
                        var newValue = Float(xThumbOffset / stepWidthInPixel)
                        newValue = min(newValue, Float(sliderBounds.upperBound))
                        if newValue > currentValue.lowerBound {
                            currentValue = currentValue.lowerBound...newValue
                        }
                    })
            }
        }
    }
    
    @ViewBuilder func lineBetweenThumbs(from: CGPoint, to: CGPoint) -> some View {
        Path { path in
            path.move(to: from)
            path.addLine(to: to)
        }.stroke(Color.orange, lineWidth: 4) // Remplacement de .nojaPrimary
    }
    
    @ViewBuilder func thumbView(position: CGPoint, value: Float) -> some View {
        ZStack {
            Text(String(format: "%.1f", value))
                .font(.system(size: 10, weight: .semibold)) // Remplacement de .secondaryFont
                .offset(y: -20)
            
            Circle()
                .frame(width: 24, height: 24)
                .foregroundColor(.orange) // Remplacement de .nojaPrimary
                .shadow(color: Color.black.opacity(0.16), radius: 8, x: 0, y: 2)
                .contentShape(Rectangle())
        }
        .position(x: position.x, y: position.y)
    }
}
