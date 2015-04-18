import bb.cascades 1.2
import bb.cascades.pickers 1.0
import bb.system 1.0

Page {
    actionBarVisibility: ChromeVisibility.Visible
    actions: [
        ActionItem {
            ActionBar.placement:  ActionBarPlacement.OnBar
            imageSource: "asset:///icon/ic_play.png"
            title: qsTr("Send")
            onTriggered: {
                ajaxsheet.open();
                ajaxpage.endpoint_ = endpoint.text;
                ajaxpage.method_ = meth.selectedValue;
                ajaxpage.parametersArray = parameters.text.length > 3 ? parameters.text.split('&') : null;
                var h = headers.text.trim().split("\n");
                var headerArray = [];
                for (var i = 0; i < h.length; i ++) {
                    var pos = h[i].indexOf('=');
                    if (pos > 0) {
                        headerArray.push({
                                k: h[i].substr(0, pos),
                                v: h[i].substr(pos + 1)
                            })
                    }
                }
                ajaxpage.headersArray = headerArray.length > 0 ? headerArray : null;
                ajaxpage.run();
            }
        }
    ]
    Container {
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        leftPadding: 10.0
        rightPadding: 10.0
        ScrollView {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            Container {
                verticalAlignment: VerticalAlignment.Fill
                horizontalAlignment: HorizontalAlignment.Fill
                Header {
                    title: qsTr("Endpoint")
                }
                TextField {
                    hintText: qsTr("Enter you endpoint here,start with http://")
                    inputMode: TextFieldInputMode.Url
                    horizontalAlignment: HorizontalAlignment.Fill
                    id: endpoint
                    focusPolicy: FocusPolicy.KeyAndTouch
                    textFormat: TextFormat.Plain
                    input.submitKey: SubmitKey.Next
                    input.submitKeyFocusBehavior: SubmitKeyFocusBehavior.Next
                    input.flags: TextInputFlag.AutoCapitalizationOff | TextInputFlag.AutoCorrectionOff | TextInputFlag.PredictionOff
                    onFocusedChanged: {
                        if (focused) {
                            if (text.length == 0) {
                                text = "http://"
                            }
                        }
                    }
                }
                Label {
                    visible: endpoint.focused
                    multiline: true
                    textStyle.base: tips.style
                    text: qsTr("Endpoint is the target URI that you intend to send your request, currently only http & https protocols supported.")

                }

                Header {
                    title: qsTr("Method")
                }
                DropDown {
                    id: meth
                    options: [
                        Option {
                            text: "GET"
                            value: "GET"
                            id: method_get
                            selected: true
                            description: qsTr("Requests data from an URI")
                        },
                        Option {
                            text: "POST"
                            value: "POST"
                            id: method_post
                            description: qsTr("Submits data to be processed to an URI")
                        }
                    ]
                    selectedOption: method_get
                    horizontalAlignment: HorizontalAlignment.Left
                    verticalAlignment: VerticalAlignment.Center
                    accessibilityMode: A11yMode.Collapsed
                }
                Label {
                    visible: meth.focused
                    multiline: true
                    text: qsTr("Query strings (name/value pairs) is sent in the URL of a GET request, while is sent in the HTTP message body of a POST request, thus POST requests have no restrictions on data length.")
                    textStyle.base: tips.style
                }
                Header {
                    title: qsTr("Parameters")
                    subtitle: qsTr("Optional")
                }
                Label {
                    textStyle.base: tips.style
                    multiline: true
                    visible: parameters.focused
                    text: qsTr("Keep all parameters in one line, Format:a=1&b=2&c=3")
                }
                TextArea {
                    hintText: qsTr("For example: a=1&b=2")
                    id: parameters
                    horizontalAlignment: HorizontalAlignment.Fill
                    textFormat: TextFormat.Plain
                    inputMode: TextAreaInputMode.Text
                }

                Header {
                    title: qsTr("HTTP Headers")
                    subtitle: qsTr("Optional")
                }
                Label {
                    textStyle.base: tips.style
                    multiline: true
                    text: qsTr("Seperate each name/value pairs in lines, one pair per line, Format:name=value")
                    visible: headers.focused
                }
                TextArea {
                    hintText: qsTr("name=value, seperate in lines.")
                    onFocusedChanged: {
                        if (focused && text.length == 0) {
                            editor.insertPlainText("Content-type=application/x-www-form-urlencoded\r\n")
                        }
                    }
                    id: headers
                }

            }
        }
    }
    attachedObjects: [
        Sheet {
            id: ajaxsheet
            onClosed: {
                ajaxresult.text = qsTr("Loading");
            }
            peekEnabled: false
            Page {
                id: ajaxpage
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

                property string method_
                property string endpoint_
                property variant parametersArray
                property variant headersArray

                function run() {
                    ajax(method_, endpoint_, parametersArray ? parametersArray : [], function(e) {
                            console.log(JSON.stringify(e));
                            ajaxresult.text = e.data;
                        }, headersArray ? headersArray : null);
                }

                Container {
                    verticalAlignment: VerticalAlignment.Fill
                    horizontalAlignment: HorizontalAlignment.Fill
                    Header {
                        title: ajaxpage.endpoint_
                    }
                    ScrollView {
                        verticalAlignment: VerticalAlignment.Fill
                        horizontalAlignment: HorizontalAlignment.Fill
                        scrollViewProperties.pinchToZoomEnabled: false
                        TextArea {
                            id: ajaxresult
                            editable: false
                            verticalAlignment: VerticalAlignment.Fill
                            horizontalAlignment: HorizontalAlignment.Fill
                            text: qsTr("Loading")
                        }
                    }

                }
                onCreationCompleted: {

                }
                actions: [
                    ActionItem {
                        title: qsTr("Back")
                        imageSource: "asset:///icon/ic_previous.png"
                        ActionBar.placement: ActionBarPlacement.OnBar
                        onTriggered: {
                            ajaxsheet.close();
                        }

                    },
                    ActionItem {
                        title: qsTr("Format")
                        imageSource: "asset:///icon/format.png"
                        onTriggered: {
                            var text = ajaxresult.text
                            tidy.postMessage(JSON.stringify({
                                        text: encodeURI(text),
                                        tabsize: 2
                                    }))
                        }
                        ActionBar.placement:  ActionBarPlacement.OnBar
                    },
                    ActionItem {
                        title: qsTr("Export")
                        imageSource: "asset:///icon/ic_save.png"
                        ActionBar.placement: ActionBarPlacement.OnBar
                        onTriggered: {
                            fileopPicker.open();
                        }
                        attachedObjects: [
                            FilePicker {
                                id: fileopPicker
                                type: FileType.Other
                                title: "Export Ajax Result"
                                onFileSelected: {
                                    console.log("FileSelected signal received : " + JSON.stringify(selectedFiles));
                                    var filepath = selectedFiles[0] + ".txt";
                                    if (_app.writeTextFile(filepath, ajaxresult.text)) {
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
                    }
                ]
                attachedObjects: [
                    WebView {
                        visible: false
                        id: tidy
                        url: "local:///assets/formatter/formatter.html"
                        onMessageReceived: {
                            ajaxresult.text = decodeURI(message.data)
                        }
                    }
                ]
                actionBarAutoHideBehavior: ActionBarAutoHideBehavior.HideOnScroll
            }
        },
        TextStyleDefinition {
            id: tips
            fontSize: FontSize.Small
        }
    ]
}