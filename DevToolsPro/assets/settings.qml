import bb.cascades 1.2
import bb.platform 1.2

Page {
    property string use_dark_theme: "use_dark_theme"
    attachedObjects: [
        PlatformInfo {
            id: pi
        }
    ]
    Container {
        leftPadding: 10.0
        rightPadding: 10.0
        Header {
            title: qsTr("Theme Settings")
        }
        CheckBox {
            visible: pi.osVersion > "10.3.0"
            text: qsTr("Use Dark Theme")
            checked: Application.themeSupport.theme.colorTheme.style === VisualStyle.Dark
            onCheckedChanged: {
                checked ? _app.setValue(use_dark_theme, "dark") : _app.setValue(use_dark_theme, "bright")
                console.log(pi.osVersion);
                Application.themeSupport.setVisualStyle(checked ? VisualStyle.Dark : VisualStyle.Bright);
            }
        }
        CheckBox {
            visible: pi.osVersion < "10.3.0"
            text: qsTr("Use Dark Theme")
            checked: _app.getValue(use_dark_theme, "dark") == "dark"
            onCheckedChanged: {
                checked ? _app.setValue(use_dark_theme, "dark") : _app.setValue(use_dark_theme, "bright")
                console.log(pi.osVersion);
            }
        }
        Label {
            text: qsTr("This will apply immediately on BlackBerry OS 10.3 and above.")
            multiline: true
            visible: pi.osVersion > "10.3.0"
            textStyle.fontSize: FontSize.XSmall
        }
        Label {
            text: qsTr("This will apply when app restarts.")
            multiline: true
            visible: pi.osVersion < "10.3.0"
            textStyle.fontSize: FontSize.XSmall
        }
    }
}
