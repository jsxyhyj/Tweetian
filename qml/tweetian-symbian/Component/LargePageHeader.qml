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

Item{
    id: root

    property string primaryText: ""
    property string secondaryText: ""
    property url imageSource: ""
    property bool showProtectedIcon: false
    signal clicked

    anchors { left: parent.left; right: parent.right; top: parent.top }
    height: profileImage.height + 2 * constant.paddingMedium

    Image {
        id: background
        anchors.fill: parent
        source: mouseArea.pressed ? "../Image/header-pressed.png" : "../Image/header.png"
    }

    Image{
        anchors { top: parent.top; left: parent.left }
        source: "../Image/meegoTLCorner.png"
    }

    Image{
        anchors { top: parent.top; right: parent.right }
        source: "../Image/meegoTRCorner.png"
    }

    Text{
        id: firstLineText
        anchors{ left: profileImage.right; top: parent.top; right: protectedIcon.left; margins: constant.paddingMedium }
        font.pixelSize: constant.fontSizeLarge
        color: "white"
        text: primaryText
        font.bold: true
        elide: Text.ElideRight
    }

    Text{
        id: secondLineText
        anchors{ left: profileImage.right; top: firstLineText.bottom; right: protectedIcon.left; leftMargin: constant.paddingMedium }
        font.pixelSize: constant.fontSizeMedium
        color: "white"
        text: secondaryText
        elide: Text.ElideRight
    }

    Image{
        id: protectedIcon
        anchors.right: parent.right
        anchors.rightMargin: constant.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        source: showProtectedIcon ? "../Image/lock.svg" : ""
        sourceSize.height: constant.graphicSizeSmall
        sourceSize.width: constant.graphicSizeSmall
    }

    MouseArea{
        id: mouseArea
        anchors.fill: parent
        onClicked: root.clicked()
    }

    Image{
        id: profileImage
        anchors {top: parent.top; left: parent.left; margins: constant.paddingMedium}
        height: 50
        width: 50
        source: root.imageSource
        cache: false

        MouseArea{
            id: imageClicked
            anchors.fill: parent
            enabled: profileImage.status == Image.Ready
            onClicked: {
                pageStack.push(Qt.resolvedUrl("../TweetImage.qml"),
                               {"imageUrl": profileImage.source.toString().replace("_normal", "")})
            }
        }

        Rectangle{
            anchors.fill: parent
            color: imageClicked.pressed ? "black" : "transparent"
            opacity: 0.75

            Behavior on color { ColorAnimation { duration: 100 } }
        }
    }
}
