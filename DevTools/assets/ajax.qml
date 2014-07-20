import bb.cascades 1.2
Page {

    property string method
    property string endpoint
    property string parameters
    function buildLine(status, text) {
        //        var str = "[" + status + "]";
        //        if (text.length > 0) {
        //            str += "Result:\n" + text
        //        }
        //        str += "\n";
        return text;
    }
    function run() {
        var request = new XMLHttpRequest();

        request.onreadystatechange = function() {
            if (request.readyState === XMLHttpRequest.DONE) {
                if (request.status === 200) {
                    console.log("Response = " + request.responseText);
                    ajaxresult.text = buildLine(request.status, request.responseText);
                } else {
                    ajaxresult.text = ("Status: " + request.status + ", Status Text: " + request.statusText);
                    console.log("Status: " + request.status + ", Status Text: " + request.statusText);
                }
            }
        }
        // Make sure whatever you post is URI encoded
        var encodedString = encodeURIComponent(parameters);
        if (method === "GET") {
            if (encodedString.length > 0) {
                request.open(method, endpoint + "&" + encodedString, true);
            } else {
                request.open(method, endpoint, true);
            }
            request.send();
        } else {
            request.open(method, endpoint, true);
            request.setRequestHeader("Content-type", "application/x-www-form-urlencoded");
            request.send(encodedString);
        }
        //request.setRequestHeader("Authorization", "Bearer " + yourAccessToken);
    }

    id: ajaxresultpage
    Container {
        verticalAlignment: VerticalAlignment.Fill
        horizontalAlignment: HorizontalAlignment.Fill
        Header {
            title: endpoint
        }
        ScrollView {
            verticalAlignment: VerticalAlignment.Fill
            horizontalAlignment: HorizontalAlignment.Fill
            scrollViewProperties.pinchToZoomEnabled: false
            TextArea {
                id: ajaxresult
                content.flags: TextContentFlag.ActiveTextOff | TextContentFlag.EmoticonsOff
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
            title: qsTr("Format")
            imageSource: "asset:///icon/format.png"
            onTriggered: {
                var text = ajaxresult.text
                tidy.postMessage(JSON.stringify({
                            text: encodeURI(text),
                            tabsize: 2
                        }))
            }
            ActionBar.placement: ActionBarPlacement.OnBar
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
