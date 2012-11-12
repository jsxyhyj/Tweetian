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

Item{
    id: root

    property string accountName
    property bool signedIn
    property bool infoButtonVisible: false
    signal buttonClicked
    signal infoClicked

    anchors { left: parent.left; right: parent.right }
    height: accountNameText.height + signedInText.height

    Text{
        id: accountNameText
        anchors {
            left: parent.left
            top: parent.top
            right: infoButtonVisible ? infoIconLoader.left : signInButton.left
            leftMargin: constant.paddingMedium
        }
        color: constant.colorLight
        font.pixelSize: constant.fontSizeLarge
        text: accountName
        elide: Text.ElideRight
    }

    Text{
        id: signedInText
        anchors { left: parent.left; top: accountNameText.bottom; leftMargin: constant.paddingMedium }
        color: signedIn ? "Green" : "Red"
        font.pixelSize: constant.fontSizeSmall
        text: signedIn ? qsTr("Signed in") : qsTr("Not signed in")
        font.italic: true
    }

    Loader{
        id: infoIconLoader
        anchors.right: signInButton.left
        anchors.rightMargin: constant.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        sourceComponent: infoButtonVisible ? infoIcon : undefined

        MouseArea{
            anchors.fill: parent
            onClicked: root.infoClicked()
        }
    }

    Component{
        id: infoIcon

        Image{
            source: settings.invertedTheme ? "../Image/info_inverse.png" : "../Image/info.png"
            sourceSize.width: constant.graphicSizeSmall + constant.paddingMedium
            sourceSize.height: constant.graphicSizeSmall + constant.paddingMedium
            cache: false
        }
    }

    Button{
        id: signInButton
        anchors.right: parent.right
        anchors.rightMargin: constant.paddingMedium
        anchors.verticalCenter: parent.verticalCenter
        platformInverted: settings.invertedTheme
        width: parent.width / 3
        text: signedIn ? qsTr("Sign Out") : qsTr("Sign In")
        onClicked: root.buttonClicked()
    }
}
