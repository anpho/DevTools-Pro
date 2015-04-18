import bb.cascades 1.2
import bb.platform 1.2
import bb 1.0
Page {
    attachedObjects: [
        PlatformInfo {
            id: pi
        },
        ApplicationInfo {
            id: app
        }
    ]
    titleBar: TitleBar {
        appearance: TitleBarAppearance.Branded
        title: qsTr("about")
    }
    actions: [
        InvokeActionItem {
            title: qsTr("Email Me")
            imageSource: "asset:///icon/ic_email.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            query.invokeTargetId: "sys.pim.uib.email.hybridcomposer"
            query.invokeActionId: "bb.action.SENDEMAIL"
            query.uri: "mailto:anphorea@gmail.com"
        }
    ]
    Container {
        Header {
            title: qsTr("App Version")
        }
        ImageView {
            verticalAlignment: VerticalAlignment.Center
            horizontalAlignment: HorizontalAlignment.Center
            topMargin: 150.0
            bottomMargin: 50.0
            imageSource: "asset:///icon.png"
        }
        Label {
            text: qsTr("DevTools Pro") + "  " + app.version
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            topMargin: 20.0
            bottomMargin: 20.0
        }
        Label {
            text: qsTr("BlackBerry OS: ") + pi.osVersion
            horizontalAlignment: HorizontalAlignment.Center
            verticalAlignment: VerticalAlignment.Center
            topMargin: 20.0
            bottomMargin: 20.0
        }
    }
}
