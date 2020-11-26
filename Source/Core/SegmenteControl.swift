//
//  SegmentedControl.swift
//  ArgoKit
//
//  Created by Bruce on 2020/10/27.
//

import Foundation
open class SegmenteControl:View{
    private let pSegment:UISegmentedControl
    private let pNode:ArgoKitNode
    public var node: ArgoKitNode?{
        pNode
    }
    /// Initializes the segmented control with the given items. Items may be NSStrings, UIImages, or (as of iOS 14.0) UIActions. When constructing from a UIAction segments will prefer images over titles when both are provided. The segmented control is automatically sized to fit content.
    public init(onSegmentedChange:@escaping(_ segmentIndex:Int)->Void,@ArgoKitViewBuilder _ builder:()->View){
        var items:Array<Any> = [];
        let container = builder()
        if let nodes = container.type.viewNodes() {
            for node in nodes {
                if let itemTitle = node.text(){
                    items.append(itemTitle)
                    continue
                }
                if let image = node.image(){
                    items.append(image)
                    continue
                }
               
            }
        }
        pSegment = UISegmentedControl(items: items)
        pNode = ArgoKitNode(view: pSegment)
        
        pNode.addAction({ (obj, paramter) -> Any? in
            if let segmentedControl = obj as? UISegmentedControl {
                onSegmentedChange(segmentedControl.selectedSegmentIndex)
            }
            return nil
        }, for: UIControl.Event.touchUpInside)
    }
}

extension SegmenteControl{
    /// Insert a segment with the given action at the given index. Segments will prefer images over titles when both are provided. When the segment is selected UIAction.actionHandler is called. If a segment already exists with the action's identifier that segment will either be updated (if the index is the same) or it will be removed (if different).
    @available(iOS 14.0, *)
    public func insertSegment(action: UIAction, at segment: Int, animated: Bool)->Self{
        pSegment.insertSegment(action: action, at: segment, animated: animated)
        return self
    }

    /// Reconfigures the given segment with this action. Segments will prefer images over titles when both are provided. When the segment is selected UIAction.actionHandler is called. UIAction.identifier must either match the action of the existing segment at this index, or be unique within all actions associated with the segmented control, or this method will assert.
    @available(iOS 14.0, *)
    public func setAction(_ action: UIAction, forSegmentAt segment: Int)->Self{
        pSegment.setAction(action, forSegmentAt: segment)
        return self
    }

    // if set, then we don't keep showing selected state after tracking ends. default is NO
    public func isMomentary(_ value:Bool)->Self{
        pSegment.isMomentary = value
        return self
    }
    
    // For segments whose width value is 0, setting this property to YES attempts to adjust segment widths based on their content widths. Default is NO.
    @available(iOS 5.0, *)
    public func apportionsSegmentWidthsByContent(_ value:Bool)->Self{
        pSegment.apportionsSegmentWidthsByContent = value
        return self
    }

    // insert before segment number. 0..#segments. value pinned
    public func insertSegment(withTitle title: String?, at segment: Int, animated: Bool)->Self{
        pSegment.insertSegment(withTitle: title, at: segment, animated: animated)
        return self
    }

    public func insertSegment(with image: UIImage?, at segment: Int, animated: Bool)->Self{
        pSegment.insertSegment(with: image, at: segment, animated: animated)
        return self
    }

    public func removeSegment(at segment: Int, animated: Bool)->Self{
        pSegment.removeSegment(at: segment, animated: animated)
        return self
    }

    public func removeAllSegments()->Self{
        pSegment.removeAllSegments()
        return self
    }

    // can only have image or title, not both. must be 0..#segments - 1 (or ignored). default is nil
    public func setTitle(_ title: String?, forSegmentAt segment: Int)->Self{
        pSegment.setTitle(title,forSegmentAt: segment)
        return self
    }

    // can only have image or title, not both. must be 0..#segments - 1 (or ignored). default is nil
    public func setImage(_ image: UIImage?, forSegmentAt segment: Int)->Self{
        pSegment.setImage(image,forSegmentAt: segment)
        return self
    }

    // set to 0.0 width to autosize. default is 0.0
    public func setWidth(_ width: CGFloat, forSegmentAt segment: Int)->Self{
        pSegment.setWidth(width,forSegmentAt: segment)
        return self
    }

    // adjust offset of image or text inside the segment. default is (0,0)
    public func setContentOffset(_ offset: CGSize, forSegmentAt segment: Int)->Self{
        pSegment.setContentOffset(offset,forSegmentAt: segment)
        return self
    }

    // default is YES
    public func setEnabled(_ enabled: Bool, forSegmentAt segment: Int)->Self{
        pSegment.setEnabled(enabled,forSegmentAt: segment)
        return self
    }

    // ignored in momentary mode. returns last segment pressed. default is UISegmentedControlNoSegment until a segment is pressed
    // the UIControlEventValueChanged action is invoked when the segment changes via a user event. set to UISegmentedControlNoSegment to turn off selection
    public func selectedSegmentIndex(_ value:Int)->Self{
        pSegment.selectedSegmentIndex = value
        return self
    }

    // The color to use for highlighting the currently selected segment.
    @available(iOS 13.0, *)
    public func selectedSegmentTintColor(_ value:UIColor?)->Self{
        pSegment.selectedSegmentTintColor = value
        return self
    }

    /* If backgroundImage is an image returned from -[UIImage resizableImageWithCapInsets:] the cap widths will be calculated from that information, otherwise, the cap width will be calculated by subtracting one from the image's width then dividing by 2. The cap widths will also be used as the margins for text placement. To adjust the margin use the margin adjustment methods.
     
     In general, you should specify a value for the normal state to be used by other states which don't have a custom value set.
     
     Similarly, when a property is dependent on the bar metrics, be sure to specify a value for UIBarMetricsDefault.
     In the case of the segmented control, appearance properties for UIBarMetricsCompact are only respected for segmented controls in the smaller navigation and toolbars.
     */
    @available(iOS 5.0, *)
    public func setBackgroundImage(_ backgroundImage: UIImage?, for state: UIControl.State, barMetrics: UIBarMetrics)->Self{
        pSegment.setBackgroundImage(backgroundImage,for: state,barMetrics: barMetrics)
        return self
    }

    /* To customize the segmented control appearance you will need to provide divider images to go between two unselected segments (leftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal), selected on the left and unselected on the right (leftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal), and unselected on the left and selected on the right (leftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected).
     */
    @available(iOS 5.0, *)
    public func setDividerImage(_ dividerImage: UIImage?, forLeftSegmentState leftState: UIControl.State, rightSegmentState rightState: UIControl.State, barMetrics: UIBarMetrics)->Self{
        pSegment.setDividerImage(dividerImage,forLeftSegmentState: leftState,rightSegmentState: rightState,barMetrics: barMetrics)
        return self
    }
    
    /* You may specify the font, text color, and shadow properties for the title in the text attributes dictionary, using the keys found in NSAttributedString.h.
     */
    @available(iOS 5.0, *)
    public func setTitleTextAttributes(_ attributes: [NSAttributedString.Key : Any]?, for state: UIControl.State)->Self{
        pSegment.setTitleTextAttributes(attributes,for: state)
        return self
    }

    /* For adjusting the position of a title or image within the given segment of a segmented control.
     */
    @available(iOS 5.0, *)
    public func setContentPositionAdjustment(_ adjustment: UIOffset, forSegmentType leftCenterRightOrAlone: UISegmentedControl.Segment, barMetrics: UIBarMetrics)->Self{
        pSegment.setContentPositionAdjustment(adjustment,forSegmentType: leftCenterRightOrAlone,barMetrics:barMetrics)
        return self
    }

}
