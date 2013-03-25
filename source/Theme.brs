' Copyright 2013 Henning Saul
'
' This file is part of Rokhue.

' Rokhue is free software: you can redistribute it and/or modify
' it under the terms of the GNU General Public License as published by
' the Free Software Foundation, either version 3 of the License, or
' (at your option) any later version.

' Rokhue is distributed in the hope that it will be useful,
' but WITHOUT ANY WARRANTY; without even the implied warranty of
' MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
' GNU General Public License for more details.

' You should have received a copy of the GNU General Public License
' along with Rokhue.  If not, see <http://www.gnu.org/licenses/>.
'
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