import bb.cascades 1.2
import bb.cascades.pickers 1.0
import bb.system 1.2
import bb.device 1.2
Page {
    actionBarVisibility: ChromeVisibility.Visible
    actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
    actions: [
        ActionItem {
            title: qsTr("Clear Output")
            imageSource: "asset:///icon/ic_clear.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                result.text = "";
            }
        },
        ActionItem {
            title: qsTr("Return")
            imageSource: "asset:///icon/ic_previous.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                blockedit = false
            }
            enabled: blockedit
        },
        ActionItem {
            title: qsTr("Run")
            imageSource: "asset:///icon/ic_play.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {
                if (blockedit) {
                    if (binp.text === ":clear") {
                        result.text = "";
                    } else if (binp.text === ":help") {
                        result.text = result.text + (qsTr("help") + Retranslate.onLocaleOrLanguageChanged) + "\n"
                    } else if (binp.text.length > 0) {
                        webview.postMessage(binp.text)
                    }
                    blockedit = false;
                } else {
                    submit()
                }
            }

        },
        ActionItem {
            id: actionClearCodes
            title: qsTr("Clear Codes")
            imageSource: "asset:///icon/ic_delete.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            enabled: binp.text.length > 0 || inp.text.length > 0
            onTriggered: {
                if (blockedit) {
                    binp.text = ""
                } else {
                    inp.text = ""
                }
            }
        },
        ActionItem {
            title: webview.visible ? qsTr("ConsoleView") : qsTr("WebView")
            imageSource: "asset:///icon/ic_browse.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                webview.visible = ! webview.visible
                resultScroll.visible = ! webview.visible
            }
            enabled: ! blockedit
        },
        ActionItem {
            id: actionimport
            title: qsTr("Import")
            imageSource: "asset:///icon/ic_open.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            enabled: blockedit
            onTriggered: {
                filePicker.open();
            }
            attachedObjects: [
                FilePicker {
                    id: filePicker
                    type: FileType.Other
                    title: qsTr("Import Javascript")
                    onFileSelected: {
                        console.log("FileSelected signal received : " + JSON.stringify(selectedFiles));
                        binp.text = _app.readTextFile(selectedFiles[0]);
                    }
                    viewMode: FilePickerViewMode.ListView
                }
            ]
        },
        ActionItem {
            id: actionexport
            title: qsTr("Export")
            imageSource: "asset:///icon/ic_save_as.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            enabled: blockedit & binp.text.length > 0
            onTriggered: {
                fileopPicker.open();
            }
            attachedObjects: [
                FilePicker {
                    id: fileopPicker
                    type: FileType.Other
                    title: "Export Javascript"
                    onFileSelected: {
                        console.log("FileSelected signal received : " + JSON.stringify(selectedFiles));
                        var filepath = selectedFiles[0] + ".js";
                        if (_app.writeTextFile(filepath, binp.text)) {
                            savesuccess.show();
                        } else {
                            savefailed.show();
                        }

                    }
                    viewMode: FilePickerViewMode.ListView
                    mode: FilePickerMode.Saver
                },
                SystemToast {
                    id: savesuccess
                    body: qsTr("Exported Successfully.")
                },
                SystemToast {
                    id: savefailed
                    body: qsTr("Export Failed.")
                }
            ]
        },
        ActionItem {
            id: actiontoggle
            title: qsTr("Toggle Block Editor")
            imageSource: "asset:///icon/ic_notes.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                blockedit = ! blockedit
                blocktoast.show();
            }
            attachedObjects: [
                SystemToast {
                    id: blocktoast
                    body: qsTr("Next time, try Double Tap to switch between modes.")
                }
            ]
        },
        ActionItem {
            id: actiontutorial
            title: qsTr("Tutorial")
            imageSource: "asset:///icon/ic_browser.png"
            ActionBar.placement: ActionBarPlacement.InOverflow
            onTriggered: {
                Qt.openUrlExternally(qsTr("http://www.w3schools.com/js/default.asp"))
            }
        }
    ]
    property bool blockedit: false
    function submit() {
        if (inp.text === ":clear") {
            result.text = "";
        } else if (inp.text === ":help") {
            result.text = result.text + (qsTr("help") + Retranslate.onLocaleOrLanguageChanged) + "\n"
        } else if (inp.text.length > 0) {
            webview.postMessage(inp.text)
        }
        inp.text = "";
    }
    function loadFile(path) {

    }
    Container {
        layout: DockLayout {

        }

        Container {
            visible: ! blockedit
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            Header {
                title: qsTr("Javascript Console(with jQuery)") + Retranslate.onLocaleOrLanguageChanged
            }
            WebView {
                id: webview
                visible: false
                onMessageReceived: {
                    result.text += (message.data + "\n");
                    resultScroll.scrollToPoint(resultScroll.content.maxWidth, resultScroll.content.maxHeight);
                }
                url: "local:///assets/jsConsole/sandbox.html"
                horizontalAlignment: HorizontalAlignment.Fill
                settings.zoomToFitEnabled: true

            }
            ScrollView {
                id: resultScroll
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                layoutProperties: StackLayoutProperties {
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
                contextActions: [
                    ActionSet {
                        actions: [
                            ActionItem {
                                title: qsTr("Block Editor")
                                imageSource: "asset:///icon/ic_notes.png"
                                onTriggered: {
                                    blockedit = true
                                }
                            }
                        ]
                    }
                ]
                verticalAlignment: VerticalAlignment.Bottom
                layoutProperties: StackLayoutProperties {
                }
                horizontalAlignment: HorizontalAlignment.Fill
                hintText: qsTr("Type Javascript Here")
                textFormat: TextFormat.Plain
                keyListeners: KeyListener {
                    onKeyPressed: {
                        if (event.key === 13) {
                            submit();
                        }
                    }
                }
                input.submitKey: SubmitKey.Send
                input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff | TextInputFlag.AutoPeriodOff

            }
            gestureHandlers: [
                DoubleTapHandler {
                    onDoubleTapped: {
                        blockedit = true;
                    }
                }
            ]
        }
        Container {
            visible: blockedit
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            Header {
                title: qsTr("Block Edit Mode")
            }
            TextArea {
                input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff | TextInputFlag.AutoPeriodOff | TextInputFlag.PredictionOff
                id: binp
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                backgroundVisible: true
                visible: true
                preferredHeight: Infinity
                hintText: qsTr("Type / Import / Paste Javascript Here.")
                inputMode: TextAreaInputMode.Text
                textFormat: TextFormat.Plain
                gestureHandlers: [
                    DoubleTapHandler {
                        onDoubleTapped: {
                            blockedit = false;
                        }
                    }
                ]
                contextActions: [
                    ActionSet {
                        actions: [
                            ActionItem {
                                title: qsTr("Toggle Block Editor")
                                imageSource: "asset:///icon/ic_notes.png"
                                ActionBar.placement: ActionBarPlacement.InOverflow
                                onTriggered: {
                                    blockedit = ! blockedit
                                    blocktoast.show();
                                }
                            }
                        ]
                    }

                ]
            }
        }
    }
}