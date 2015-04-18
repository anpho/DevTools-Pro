import bb.cascades 1.2
import bb.system 1.2
import bb.cascades.pickers 1.0

Page {
    attachedObjects: [
        TextStyleDefinition {
            id: tips
            fontSize: FontSize.Small
        },
        WebView {
            id: webv
            url: "local:///assets/regexp/regexp.html"
            onMessageReceived: {
                var i = parseInt(message.data);
                console.log(i);
                if (i > 0) {
                    docheader.subtitle = i + " " + qsTr("Matches");
                } else {
                    docheader.subtitle = notfound;
                }
            }
            settings.webInspectorEnabled: true
        },
        Sheet {
            id: detailsMatch
            attachedObjects: [
                WebView {
                    id: webdetails
                    url: "local:///assets/regexp/regexp.html"
                    onMessageReceived: {
                        var i = JSON.parse(message.data);
                        console.log(message.data);
                        adm.clear();
                        adm.insert(0, i);
                        matchessub.subtitle = i.length + " " + qsTr("Matches")
                    }
                    settings.webInspectorEnabled: true
                }
            ]
            function run(pattern, modifier, text) {
                re.text = "/" + pattern + "/" + modifier;
                webdetails.postMessage(JSON.stringify({
                            p: pattern,
                            m: modifier,
                            t: encodeURI(text),
                            f: true
                        }))
            }
            Page {
                actions: [
                    ActionItem {
                        title: qsTr("Back")
                        imageSource: "asset:///icon/ic_previous.png"
                        onTriggered: {
                            detailsMatch.close();
                        }
                        ActionBar.placement: ActionBarPlacement.OnBar
                    }
                ]
                Container {
                    Header {
                        title: qsTr("RegExp")
                    }
                    Label {
                        id: re
                    }
                    Header {
                        title: qsTr("Matches")
                        id: matchessub
                    }
                    ListView {
                        id: lv
                        dataModel: ArrayDataModel {
                            id: adm
                        }
                    }
                }
            }
        }
    ]
    /*
     * Functions
     */
    property string notfound: qsTr("Match Not Found")

    function opencheatsheet() {
        Qt.openUrlExternally(qsTr("http://www.w3schools.com/jsref/jsref_obj_regexp.asp"))
    }

    function genRegexp() {
        var modifiers = "";
        if (tbg.checked) modifiers += "g";
        if (tbi.checked) modifiers += "i";
        if (tbm.checked) modifiers += "m";
        var pattern = rpattern.text;
        if (pattern.length == 0) {
            return;
        }
        if (rtext.text.length == 0) {
            return;
        }
        webv.postMessage(JSON.stringify({
                    p: pattern,
                    m: modifiers,
                    t: encodeURI(rtext.text)
                }))

    }

    actions: [
        ActionItem {
            title: qsTr("Match")
            enabled: rpattern.text.length > 0 && rtext.text.length > 0
            imageSource: "asset:///icon/ic_check_spelling.png"
            ActionBar.placement: ActionBarPlacement.OnBar
            onTriggered: {

                var modifiers = "";
                if (tbg.checked) modifiers += "g";
                if (tbi.checked) modifiers += "i";
                if (tbm.checked) modifiers += "m";
                var pattern = rpattern.text;
                detailsMatch.open();
                detailsMatch.run(pattern, modifiers, rtext.text);
            }
        },
        ActionItem {
            title: qsTr("RegExp Reference")
            imageSource: "asset:///icon/ic_browser.png"
            onTriggered: {
                opencheatsheet()
            }
        }
    ]
    ScrollView {

        Container {
            leftPadding: 10.0
            rightPadding: 10.0
            Header {
                title: qsTr("Regular Expression Tool")
            }
            Label {
                text: qsTr("Your Regular Expresson Pattern:")
                textStyle.base: tips.style
                multiline: true
            }
            Container {
                layout: StackLayout {
                    orientation: LayoutOrientation.LeftToRight

                }
                Label {
                    text: "/"
                    verticalAlignment: VerticalAlignment.Center
                }
                TextField {
                    id: rpattern
                    textFormat: TextFormat.Plain
                    inputMode: TextFieldInputMode.Text
                    input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Lose
                    input.submitKey: SubmitKey.Done
                    verticalAlignment: VerticalAlignment.Center
                    layoutProperties: StackLayoutProperties {
                        spaceQuota: 1.0
                    }
                    hintText: qsTr("RegExp Pattern")
                    onTextChanged: {

                    }
                    onTextChanging: {
                        genRegexp()
                    }
                }
                Label {
                    text: "/"
                    verticalAlignment: VerticalAlignment.Center

                }
                ImageButton {
                    defaultImageSource: "asset:///icon/ic_help.png"
                    verticalAlignment: VerticalAlignment.Center
                    onClicked: {
                        opencheatsheet()
                    }
                }
            }
            Label {
                text: qsTr("Regular Expression Attributes:")
                multiline: true
                textStyle.base: tips.style
            }
            Container {
                layout: DockLayout {

                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                Label {
                    text: qsTr("Case-insensitive matching")
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Left

                }
                ToggleButton {
                    id: tbi
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Right
                    onCheckedChanged: {
                        genRegexp()
                    }
                }

            }
            Container {
                layout: DockLayout {

                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                Label {
                    text: qsTr("Global matching")
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Left

                }
                ToggleButton {
                    id: tbg
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Right
                    onCheckedChanged: {
                        genRegexp()
                    }
                }

            }
            Container {
                layout: DockLayout {

                }
                horizontalAlignment: HorizontalAlignment.Fill
                verticalAlignment: VerticalAlignment.Center
                Label {
                    text: qsTr("Multiline matching")
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Left

                }
                ToggleButton {
                    id: tbm
                    verticalAlignment: VerticalAlignment.Center
                    horizontalAlignment: HorizontalAlignment.Right
                    onCheckedChanged: {
                        genRegexp()
                    }
                }

            }
            Header {
                title: qsTr("Text")
                id: docheader
                subtitle: notfound
            }
            TextArea {
                id: rtext
                hintText: qsTr("Type, paste, or import text by long press.")
                contextActions: [
                    ActionSet {
                        actions: [
                            ActionItem {
                                title: qsTr("Load from URL")
                                imageSource: "asset:///icon/ic_map.png"
                                onTriggered: {
                                    //TODO load from url
                                    prom.show();
                                }
                                attachedObjects: [
                                    SystemPrompt {
                                        id: prom
                                        title: qsTr("Load From URL")
                                        returnKeyAction: SystemUiReturnKeyAction.Submit
                                        dismissAutomatically: true
                                        includeRememberMe: false
                                        body: qsTr("This will load the content of the URL you specified here:")
                                        onFinished: {
                                            if (value == SystemUiResult.ConfirmButtonSelection) {
                                                var v = inputFieldTextEntry();
                                                if (v.indexOf("http://") == 0 || v.indexOf("https://") == 0) {
                                                    ajax.ajax("GET", v, [], function(e) {
                                                            if (e.success) {
                                                                rtext.text = e.data
                                                            } else {
                                                                sst.body = qsTr("Failed to Load, reason is: " + e.data);
                                                                sst.show();
                                                            }
                                                        })
                                                } else {
                                                    sst.body = qsTr("Invalid URL, Request dismissed.");
                                                    sst.show();
                                                }
                                            }
                                        }
                                        inputField.inputMode: SystemUiInputMode.Url
                                        inputField.defaultText: "http://"
                                        customButton.enabled: false
                                    },
                                    SystemToast {
                                        id: sst
                                    },
                                    QtObject {
                                        id: ajax
                                        function ajax(m, p, paramsArray, callback, customheader) {
                                            var request = new XMLHttpRequest();
                                            request.onreadystatechange = function() {
                                                if (request.readyState === XMLHttpRequest.DONE) {
                                                    if (request.status === 200) {
                                                        console.log("Response = " + request.responseText);
                                                        callback({
                                                                "success": true,
                                                                "data": request.responseText
                                                            });
                                                    } else {
                                                        console.log("Status: " + request.status + ", Status Text: " + request.statusText);
                                                        callback({
                                                                "success": false,
                                                                "data": request.statusText
                                                            });
                                                    }
                                                }
                                            };
                                            var params = paramsArray.join("&");
                                            var url = p;
                                            if (m == "GET" && params.length > 0) {
                                                url = url + "?" + params;
                                            }
                                            request.open(m, url, true);
                                            if (customheader) {
                                                for (var i = 0; i < customheader.length; i ++) {
                                                    request.setRequestHeader(customheader[i].k, customheader[i].v);
                                                }
                                            }
                                            if (m == "GET") {
                                                request.send();
                                            } else {
                                                request.send(params);
                                            }

                                        }
                                    }
                                ]
                            },
                            ActionItem {
                                title: qsTr("Load from File")
                                imageSource: "asset:///icon/ic_doctype_generic.png"
                                onTriggered: {
                                    fp.open();
                                }
                                attachedObjects: [
                                    FilePicker {
                                        id: fp
                                        title: "Import Text"
                                        type: FileType.Document
                                        defaultType: FileType.Document
                                        viewMode: FilePickerViewMode.ListView
                                        onFileSelected: {
                                            var filepath = selectedFiles[0];
                                            rtext.text = _app.readTextFile(filepath);
                                        }
                                    }
                                ]
                            },
                            ActionItem {
                                title: qsTr("Clear")
                                imageSource: "asset:///icon/ic_clear.png"
                                onTriggered: {
                                    rtext.text = "";
                                }
                            }
                        ]
                    }
                ]
                onTextChanging: {
                    genRegexp()
                }
            }

        }
    }
}