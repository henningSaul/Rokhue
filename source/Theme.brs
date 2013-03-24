Sub initTheme()
    app = CreateObject("roAppManager")
    theme = getTheme()  
    app.SetTheme(theme)
End Sub

Function getTheme() As Object 
    theme = CreateObject("roAssociativeArray")
    ' General Colors
    theme.BackgroundColor = "#101010"
    theme.ParagraphHeaderText = "#EBEBEB"
    theme.ParagraphBodyText = "#8BABEB"
    ' PosterScreen colors
    theme.PosterScreenLine1Text = "#EB4060"
    theme.PosterScreenLine2Text = "#8BABEB"
    ' FilterBanner colors and images
    theme.FilterBannerActiveColor = "#EBCB00"
    theme.FilterBannerInactiveColor = "#AB9B00"
    'theme.FilterBannerSideColor = "#EB0000"
    'theme.FilterBannerSliceSD = "pkg:/images/FilterBanner_Slice_SD.png"
    'theme.FilterBannerActiveSD = "pkg:/images/FilterBanner_Active_SD.png"
    'theme.FilterBannerSliceHD = "pkg:/images/FilterBanner_Slice_HD.png"
    'theme.FilterBannerActiveHD = "pkg:/images/FilterBanner_Active_HD.png"
    ' SD Overhang
    theme.OverhangOffsetSD_X = "10"
    theme.OverhangOffsetSD_Y = "14"
    theme.OverhangLogoSD  = "pkg:/images/Logo_Overhang_SD.png"
    ' HD Overhang
    theme.OverhangOffsetHD_X = "0"
    theme.OverhangOffsetHD_Y = "11"
    theme.OverhangLogoHD  = "pkg:/images/Logo_Overhang_HD.png"
    return theme
End Function