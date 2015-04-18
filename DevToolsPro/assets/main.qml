/*
 * Copyright (c) 2011-2014 BlackBerry Limited.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import bb.cascades 1.0
import bb.device 1.2

NavigationPane {
    property int widthNow: DisplayInfo.width
    onCreationCompleted: {
        Application.menuEnabled = true;
    }
    id: nav
    Menu.definition: MenuDefinition {
        helpAction: HelpActionItem {
            onTriggered: {
                nav.push(Qt.createComponent("about.qml").createObject(nav))
            }
        }

        settingsAction: SettingsActionItem {
            onTriggered: {
                nav.push(Qt.createComponent("settings.qml").createObject(nav))
            }
        }
    }
    Page {
        titleBar: TitleBar {
            title: qsTr("Dev Tools Pro")
            appearance: TitleBarAppearance.Branded

        }
        Container {
            ListView {
                id: mainlist
                dataModel: XmlDataModel {
                    source: qsTr("features.xml")
                }
                onTriggered: {
                    var item = dataModel.data(indexPath);
                    console.log("Pushing:" + item.target)
                    var t = Qt.createComponent(item.target).createObject(nav);
                    nav.push(t)
                    Application.menuEnabled = false;
                }
                listItemComponents: [
                    ListItemComponent {
                        type: "item"
                        Container {
                            horizontalAlignment: HorizontalAlignment.Center
                            verticalAlignment: VerticalAlignment.Center
                            ImageView {
                                imageSource: ListItemData.icon
                                preferredWidth: 120.0
                                preferredHeight: 120.0
                                horizontalAlignment: HorizontalAlignment.Center

                            }
                            Label {
                                text: ListItemData.title
                                horizontalAlignment: HorizontalAlignment.Center
                                multiline: true
                                textStyle.textAlign: TextAlign.Center
                            }
                        }
                        //                        StandardListItem {
                        //                            title: ListItemData.title
                        //                            //                            status: ListItemData.version
                        //                            imageSource: ListItemData.icon
                        //                            imageSpaceReserved: true
                        //                        }
                    }
                ]
                layout: GridListLayout {
                    id: grid
                    headerMode: ListHeaderMode.Standard
                    columnCount: (widthNow <= 768) ? 2 : 3

                    cellAspectRatio: 1.5

                }
            }

        }
    }
    onPopTransitionEnded: {
        page.destroy();
        Application.menuEnabled = true;
    }
    attachedObjects: [
        OrientationHandler {
            onOrientationChanged: {
                if (orientation == UIOrientation.Landscape) {
                    widthNow = DisplayInfo.height
                } else {
                    widthNow = DisplayInfo.width
                }
            }
        }
    ]
}
