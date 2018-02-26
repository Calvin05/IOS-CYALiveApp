//
//  SynaptopTheme.swift
//  Cya
//
//  Created by Rigo on 09/11/17.
//  Copyright © 2017 Cristopher Torres. All rights reserved.
//

import UIKit
extension UIColor {
    static let cyaMagenta = UIColor.init(hex: "#EB1060")
    static let cyaLightGrayBg = UIColor(red: 246.0/255.0, green: 246.0/255.0, blue: 246.0/255.0, alpha: 1.0)
    static let cyaDarkGrayBg = UIColor(red: 64.0/255.0, green: 64.0/255.0, blue: 64.0/255.0, alpha: 1.0)
    static let cyaDarkBg = UIColor(red: 40.0/255.0, green: 40.0/255.0, blue: 40.0/255.0, alpha: 1.0)
    
    
    static let cyaLightGrayText = UIColor(red: 117.0/255.0, green: 117.0/255.0, blue: 117.0/255.0, alpha: 1.0)
    static let cyaDarkGrayText = UIColor(red: 59.0/255.0, green: 59.0/255.0, blue: 59.0/255.0, alpha: 1.0)
    static let cyaRedText = UIColor(red: 221.0/255.0, green: 45.0/255.0, blue: 80.0/255.0, alpha: 1.0)
    
    static let cyaBarNavigationBg = UIColor(red: 224.0/255.0, green: 224.0/255.0, blue: 224.0/255.0, alpha: 1.0)
    
    static let cyaWhite = UIColor.init(hex: "#ffffff")
    /*Name Color*/
    
    /*Name color theme*/
    
     // MARK: -  Event list
     static let Cya_Event_List_Root_Color                  = UIColor.init(hex: "#f5f5f5")
     static let Cya_Event_Item_Info_Background_Color       = UIColor.init(hex: "#ffffff")
     static let Cya_Event_List_Live_Text_Color             = Cya_Primary_Color
     static let Cya_Event_List_Live_Text_Shadow_Color      = UIColor.init(hex: "#404040")
     static let Cya_Event_List_Dot_Color                   = Cya_Event_List_Live_Text_Color
     static let Cya_Event_List_Hosted_By_Text_Color        = Cya_Primary_Color
     static let Cya_Event_List_Time_Text_Color             = UIColor.init(hex: "#333333")
     static let Cya_Event_List_Event_Title_Text_Color      = UIColor.init(hex: "#000000")
     static let Cya_Placeholder_Background_Color           = UIColor.init(hex: "#f5f5f5")
     
     // MARK: -  Search bar
     static let Cya_Search_Bar_Background_Color            = UIColor.init(hex: "#550000")
     static let Cya_Search_Bar_Hint_Text_Color             = UIColor.init(hex: "#FFFFFF")
     
     // MARK: -  Action bar
     static let Cya_Action_Bar_Background                  = UIColor.init(hex: "#000000")
     static let Cya_Action_Bar_Background_Grey             = UIColor.init(hex: "#ff3232")
     static let Cya_Waiting_Room_Input_Background          = UIColor.init(hex: "#ff4545")
     static let Cya_Text_Dark                              = UIColor.init(hex: "#ff5c5c")

     
     static let Cya_Color_Accent                           = UIColor.init(hex: "#EB1060")
     
     // MARK: - Chat
     static let Cya_Chat_Input_Color                       = UIColor.init(hex: "#FF3636")
     static let Cya_Chat_Input_Text_Hint_Color             = UIColor.init(hex: "#FF5C5C")
     static let Cya_Chat_Fragment_Background               = UIColor.init(hex: "#FFEEEE")
     static let Cya_Actionbar_Background                   = UIColor.init(hex: "#313131")
     static let Cya_Synaptop_Dark                          = UIColor.init(hex: "#363636")
     static let Cya_Secondary_Pink                         = UIColor.init(hex: "#eb1060")
     static let Cya_Sender_Color                           = UIColor.init(hex: "#E1E1E1")
     static let Cya_Error_Text_Tolor                       = cyaWhite
     
     // MARK: -  buttons
     static let Cya_Button_White_Normal                    = UIColor.init(hex: "#FFFFFF")
     static let Cya_Button_White_Pressed                   = UIColor.init(hex: "#999999")
     static let Cya_Button_White_Disabled                  = Cya_Label_On_Grey
     static let Cya_Button_Text_On_White                   = UIColor.init(hex: "#FF0000")
     
     // MARK: - Waiting remove MOVE THIS OUTSIDE
     static let Cya_Waiting_Room_Chat_Background           = UIColor.init(hex: "#ff3535")
     static let Cya_Party_Input_Bg_Waiting                 = UIColor.init(hex: "#FFdddd")
     static let Cya_Party_Input_Border                     = UIColor.init(hex: "#FFaaaa")
     static let Cya_Button_Background                      = UIColor.clear
     static let Cya_Light_Grey                             = UIColor.init(hex: "#dddddd")
     
     
     // MARK: - label colours
     static let Cya_Label_On_Grey                          = UIColor.init(hex: "#FF5D5D")
     static let Cya_Value_On_Grey                          = UIColor.init(hex: "#FFDFDF")
     
     
     // MARK: - Toolbar
     static let Cya_Title_Text_Color                       = UIColor.init(hex: "#FFFFFF")
     
     
     // MARK: - party
     static let Cya_Sign_In_Background                     = UIColor.init(hex: "#44adcb")
     static let Cya_Party_Tab_Text_Color                   = UIColor.init(hex: "#FFFFFF")
     static let Cya_Tab_Background                         = UIColor.init(hex: "#FF2121")
     static let Cya_Ab_Background_Pressed_Color            = UIColor.init(hex: "#FF3535")
     
     
     // MARK: - Buttons
     static let Cya_Media_Controller_Icon_Pressed_Color    = cyaWhite
     static let Cya_Media_Controller_Icon_Normal_Color     = UIColor.init(hex: "#5d5d5d")
     
     
     // MARK: - stage colors
     static let Cya_Stage_Text_Join_Color                  = UIColor.init(hex: "#FFFFFF")
     
     // MARK: - bottom sheet
     static let Cya_Label_Text                             = UIColor.init(hex: "#FFFFFF")
     static let Cya_Stage_Interaction_Normal_Text_Color    = UIColor.init(hex: "#FFFFFF")
     static let Cya_Stage_Interaction_Reddish_Colo         = UIColor.init(hex: "#e22c6f")
     static let Cya_Stage_Overlay_Colo                     = UIColor.init(hex: "#FF4141")
     
     // MARK: - Landing page
     static let Cya_Preview_Fragment_background            = UIColor.init(hex: "#FFFFFF")
     static let Cya_Preview_Title_Text_Color               = UIColor.init(hex: "#000000")
     static let Cya_Preview_Duration_Text_Color            = UIColor.init(hex: "#5c5c5c")
     static let Cya_Preview_Time_Text_Color                = UIColor.init(hex: "#5c5c5c")
     static let Cya_Preview_Tickets_Border_Color           = UIColor.init(hex: "#FF0054")
     static let Cya_Preview_Content_Text_Color             = UIColor.init(hex: "#FF0000")
     static let Cya_Preview_Text_Color                     = UIColor.init(hex: "#5c5c5c")
     static let Cya_Preview_Buy_Button_Colour              = UIColor.init(hex: "#2595e6")
     static let Cya_Preview_Buy_Button_Colour_Pressed      = UIColor.init(hex: "#155e93")
     static let Cya_Preview_Button_Text_Color              = UIColor.init(hex: "#FFFFFF")
//     static let Cya_Count_Down_Stripe_Background           = Cya_Count_Down_Stripe_Background
     static let Cya_Count_Down_Stripe_Grey                 = UIColor.init(hex: "#660000")
     static let Cya_Dialog_Title_Light                     = UIColor.init(hex: "#FF0000")
    
     
     // MARK: - Landing page - Tabbar
     static let Cya_Pre_Event_Shadow_Color                 = UIColor.init(hex: "#550000")
     static let Cya_Buy_Button_Colour_Pressed              = UIColor.init(hex: "#155e93")
     static let Cya_Buy_Button_Colour                      = UIColor.init(hex: "#2595e6")
     static let Cya_Image_Ripple_Color                     = UIColor.init(hex: "#dad9d9")
     
     // MARK: - Landing page - Ripple color

     
     // MARK: - Landing page - Payment
     static let Cya_Payment_Background                     = UIColor.init(hex: "#665555")
     static let Cya_Payment_Charge_Background              = UIColor.init(hex: "#669999")
     
     // MARK: - Landing page - Count Down Banner
     static let Cya_Banner_Text_Color                      = UIColor.init(hex: "#FFFFFF")
     static let Cya_Banner_Event_Ended_Text_Color          = UIColor.init(hex: "#333333")
     static let Cya_Banner_Event_Ended_Background_Color    = UIColor.init(hex: "#f5f5f5")
     
     // MARK: - Colors Login
     static let Cya_Primary_Color                          = cyaMagenta
     // MARK: - Login fragment
     static let Cya_Sign_In_Clickable_Label_Text           = UIColor.init(hex: "#FFFFFF")
     static let Cya_Text_Color_Inside_Button               = UIColor.init(hex: "#FF0000")
     
     
     // MARK: - Sign up
     static let Cya_Sign_In_Button_Text                    = UIColor.init(hex: "#000000")
     static let Cya_Instruction_Text_Color                 = UIColor.init(hex: "#FFC812")
     static let Cya_Sign_In_Hint_Color                     = UIColor.init(hex: "#887777")
     static let Cya_Pre_Event_Text_Color                   = UIColor.init(hex: "#ffffff")
     static let Cya_Input_Bg_No_Highlight                  = UIColor.init(hex: "#1A0000")
     static let Cya_Input_Bg_Highlight                     = UIColor.init(hex: "#4c0000")
     static let Cya_Input_Bg_No_Highlight_White            = UIColor.init(hex: "#FFCCCC")
     static let Cya_Input_Bg_Highlight_White               = UIColor.init(hex: "#FFFFFF")
     
     // MARK: - Sign up 2
     static let Cya_No_Background                          = UIColor.init(hex: "#000000")
     
     // MARK: - Login/Sign up flow colours
     static let Cya_Facebook_Blue                          = UIColor.init(hex: "#3b5998")
     static let Cya_Facebook_Blue_Pressed                  = UIColor.init(hex: "#1b3978")
     static let Cya_Google_Red                             = UIColor.init(hex: "#dd4b39")
     static let Cya_Party_Input_Bg                         = UIColor.init(hex: "#FF3333")
     static let Cya_Sign_In_Forgot_Password_Link           = UIColor.init(hex: "#44adcb")
     static let Cya_Sign_In_Label_Text                     = UIColor.init(hex: "#FFFFFF")
     static let Cya_Sign_In_Button_Google                  = UIColor.init(hex: "#000000")
     static let Cya_Sign_In_Button_Facebook                = UIColor.init(hex: "#FFFFFF")
     static let Cya_Sign_In_Bottom_Tab_Text                = UIColor.init(hex: "#5c5c5c")
     static let Cya_Option_Highlight                       = UIColor.init(hex: "#FF0000")
     static let Cya_Radio_Stroke                           = UIColor.init(hex: "#FFFFFF")
     static let Cya_Radio_Text_Highlighted                 = UIColor.init(hex: "#000000")
     static let Cya_Login_Sign_Up_Background               = UIColor.init(hex: "#33FFFF")
     
     // MARK: - Login - Ripple
     static let Cya_Rsvp_Button_Colour_Pressed             = UIColor.init(hex: "#FF991A")
     static let Cya_Rsvp_Button_Colour                     = UIColor.init(hex: "#ff0054")
     static let Cya_Label_Pressed_Background_Color         = UIColor.init(hex: "#220000")
     
     // MARK: - Login - Walkthrough color
     static let Cya_Walkthrough_Label_Color                = UIColor.init(hex: "#FF0000")
     static let Cya_Walkthrough_Indicator_Color            = UIColor.init(hex: "#f49ac1")
     
     // MARK: - Colors Settings
     static let Cya_Event_List_Title_Text_Color            = UIColor.init(hex: "#000000")
     
     // MARK: - Root settings -->
     static let Cya_Root_Settings_Section_Text_Color       = UIColor.init(hex: "#020202")
     static let Cya_Root_Settings_Seperator_Color          = UIColor.init(hex: "#e1e1e1")
     
    // MARK: - Gral
    static let Cya_Background_Light                        = UIColor.init(hex: "#737373")

}

