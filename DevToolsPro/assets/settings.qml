import bb.cascades 1.2

Page {
    property string use_dark_theme: "use_dark_theme"
    Container {

        Header {
            title: qsTr("App Theme")
        }
        Container {
            layout: DockLayout {
            }
            horizontalAlignment: HorizontalAlignment.Fill
            topPadding: 20.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            Label {
                text: qsTr("Use Dark Theme")
                horizontalAlignment: HorizontalAlignment.Left
                verticalAlignment: VerticalAlignment.Center
            }
            ToggleButton {
                horizontalAlignment: HorizontalAlignment.Right
                verticalAlignment: VerticalAlignment.Center
                checked: (_app.getValue(use_dark_theme, (Application.themeSupport.theme.colorTheme.style === VisualStyle.Bright ? "bright" : "dark")) === "dark")
                onCheckedChanged: {
                    checked ? _app.setValue(use_dark_theme, "dark") : _app.setValue(use_dark_theme, "bright")
                }
            }
        }
        Container {
            topPadding: 10.0
            leftPadding: 20.0
            rightPadding: 20.0
            bottomPadding: 20.0
            Label {
                textStyle.fontSize: FontSize.Small
                text: qsTr("Changing theme requires app restart.")
                multiline: true
            }
        }
    }
}
