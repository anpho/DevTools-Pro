import bb.cascades 1.2
import bb.system 1.0
TabbedPane {
    property int tabcount;
    
    Menu.definition: MenuDefinition {
        actions: ActionItem {
            imageSource: "asset:///icon/ic_clear.png"
            title: qsTr("Clear")
            onTriggered: {
                result.text="";
            }
            enabled: (tabcount===1)
        }
    }
    tabs: [
        Tab {
            onTriggered: {
                tabcount=1;
                //jsconsoletab.newContentAvailable = false;
            }
            id: jsconsoletab
            title: qsTr("JS Console")
            imageSource: "asset:///icon/console.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            newContentAvailable: false
            Page {
                Container {
                    onTouch: {
                        jsconsoletab.newContentAvailable = false;
                    }
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    Header {
                        title: qsTr("JS Console") + Retranslate.onLocaleOrLanguageChanged
                    }
                    ScrollView {
                        id: resultScroll
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0

                        }
                        Container {
                            Label {

                                id: result
                                multiline: true
                                verticalAlignment: VerticalAlignment.Fill
                                horizontalAlignment: HorizontalAlignment.Fill
                            }
                        }
                    }

                    TextField {
                        id: inp
                        verticalAlignment: VerticalAlignment.Bottom
                        layoutProperties: StackLayoutProperties {
                            spaceQuota: 1.0
                        }
                        horizontalAlignment: HorizontalAlignment.Fill
                        hintText: qsTr("Type Javascript Here")
                        textFormat: TextFormat.Plain
                        inputMode: TextFieldInputMode.Text
                        keyListeners: KeyListener {
                            onKeyPressed: {
                                if (event.key === 13) {
                                    if (inp.text === ":clear") {
                                        result.text = "";
                                    } else if (inp.text === ":help") {
                                        result.text = result.text + (qsTr("help") + Retranslate.onLocaleOrLanguageChanged) + "\n"
                                    } else if (inp.text.length > 0) {
                                        webview.postMessage(inp.text)
                                    }
                                    inp.text = "";
                                }
                            }
                        }
                        input.submitKey: SubmitKey.Send
                        input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff | TextInputFlag.AutoPeriodOff
                    }
                    attachedObjects: [
                        WebView {
                            id: webview
                            visible: false
                            onMessageReceived: {
                                result.text += (message.data + "\n");
                                resultScroll.scrollToPoint(resultScroll.content.maxWidth, resultScroll.content.maxHeight);
                                //jsconsoletab.newContentAvailable=true;
                            }
                            url: "local:///assets/jsConsole/sandbox.html"
                            //settings.webInspectorEnabled: true
                        }
                    ]
                }
            }
        },
        Tab {
            onTriggered: {
                tabcount=2;
            }
            id: ajaxtab
            title: qsTr("Ajax Tool")
            imageSource: "asset:///icon/ajax.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            NavigationPane {
                id: navpane
                onPopTransitionEnded: {
                    page.destroy();
                }
                Page {
                    Container {
                        verticalAlignment: VerticalAlignment.Top
                        horizontalAlignment: HorizontalAlignment.Fill
                        ScrollView {
                            Container {

                                Header {
                                    title: qsTr("Endpoint")
                                }
                                TextField {
                                    hintText: qsTr("Enter you endpoint here,start with http://")
                                    inputMode: TextFieldInputMode.Url
                                    horizontalAlignment: HorizontalAlignment.Fill
                                    id: endpoint
                                    focusPolicy: FocusPolicy.KeyAndTouch
                                    maximumLength: 200
                                    textFormat: TextFormat.Plain
                                    input.submitKey: SubmitKey.Next
                                    input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Next
                                    text: "http://"
                                    input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff
                                }
                                Header {
                                    title: qsTr("Method")
                                }
                                DropDown {
                                    id: method
                                    options: [
                                        Option {
                                            text: "GET"
                                            value: "GET"
                                            id: method_get
                                            selected: true
                                        },
                                        Option {
                                            text: "POST"
                                            value: "POST"
                                            id: method_post
                                        }
                                    ]
                                }
                                Header {
                                    title: qsTr("Parameters (optional)")
                                }
                                TextField {
                                    hintText: qsTr("eg. a=1&b=2")
                                    id: parameters
                                    horizontalAlignment: HorizontalAlignment.Fill
                                }
                                Button {
                                    text: qsTr("Go!")
                                    onClicked: {
                                        var ap = ajaxPageDifinition.createObject();
                                        ap.method = method.selectedValue
                                        ap.parameters = parameters.text
                                        ap.endpoint = endpoint.text
                                        navpane.push(ap);
                                        ap.run();
                                    }
                                    horizontalAlignment: HorizontalAlignment.Center
                                }
                            }
                        }
                    }
                }
            }
        }
    ]
    showTabsOnActionBar: true
    attachedObjects: [
        ComponentDefinition {
            id: ajaxPageDifinition
            source: "ajax.qml"
        },
        SystemDialog {
            id: helpdialog
            modality: SystemUiModality.Application

            body: qsTr("about")

            includeRememberMe: false
            rememberMeChecked: false
            customButton.enabled: false
            cancelButton.enabled: false
        }
    ]
    onCreationCompleted: {
        tabcount=1;
    }
}
