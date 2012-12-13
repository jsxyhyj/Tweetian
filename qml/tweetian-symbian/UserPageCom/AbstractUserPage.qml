/*
    Copyright (C) 2012 Dickson Leong
    This file is part of Tweetian.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 1.1
import com.nokia.symbian 1.1
import "../Component"

Page {
    id: root

    property string headerText
    property int headerNumber: 0
    property string emptyText
    property alias delegate: listView.delegate
    property string reloadType: "all"

    property bool backButtonEnabled: true
    property bool loadMoreButtonVisible: true

    property QtObject userInfoData
    property ListView listView: listView

    signal reload

    onStatusChanged: if (status === PageStatus.Deactivating) loadingRect.visible = false

    onUserInfoDataChanged: if (root.listView) reload() // Qt 4.7.4 Compatibility
    Component.onCompleted: if (userInfoData) reload()

    tools: ToolBarLayout {
        ToolButtonWithTip {
            iconSource: "toolbar-back"
            toolTipText: "Back"
            enabled: backButtonEnabled
            opacity: enabled ? 1 : 0.25
            onClicked: pageStack.pop()
        }
    }

    AbstractListView {
        id: listView
        anchors { top: header.bottom; bottom: parent.bottom; left: parent.left; right: parent.right }
        model: ListModel {}
        footer: LoadMoreButton {
            visible: loadMoreButtonVisible
            enabled: !loadingRect.visible
            onClicked: {
                reloadType = "older"
                reload()
            }
        }
        onPullDownRefresh: {
            reloadType = "all"
            reload()
        }
    }

    Text {
        anchors.centerIn: parent
        visible: listView.count == 0 && !loadingRect.visible
        font.pixelSize: constant.fontSizeXXLarge
        color: constant.colorMid
        text: root.emptyText
    }

    ScrollDecorator { flickableItem: listView }

    PageHeader {
        id: header
        headerIcon: userInfoData.profileImageUrl
        headerText: "<b>@" + userInfoData.screenName + "</b>: " + root.headerText
        countBubbleVisible: true
        countBubbleValue: root.headerNumber
        onClicked: listView.positionViewAtBeginning()
    }
}
