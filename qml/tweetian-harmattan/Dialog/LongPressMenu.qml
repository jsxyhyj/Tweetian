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
import com.nokia.meego 1.0
import "../Component"

ContextMenu{
    id: root

    property variant model
    property bool __isClosing: false

    function getAllHashtags(text){
        if(!settings.hashtagsInReply)
            return ""

        var hashtags = ""
        var hashtagsArray = text.match(/href="#[^"\s]+/g)
        if(hashtagsArray != null)
            for(var i=0; i<hashtagsArray.length; i++) hashtags += hashtagsArray[i].substring(6) + " "

        return hashtags
    }

    content: MenuLayout{
        MenuItem{
            text: qsTr("Reply")
            onClicked: {
                var prop = {type: "Reply", tweetId: model.tweetId, placedText: "@"+model.screenName+" "+getAllHashtags(model.displayTweetText)}
                pageStack.push(Qt.resolvedUrl("../NewTweetPage.qml"), prop)
            }
        }
        MenuItem{
            text: qsTr("Retweet")
            onClicked: {
                var text = model.retweetId == model.tweetId ? "RT @"+model.screenName+": "+model.tweetText
                                                : "RT @"+model.screenName+": RT @"+model.displayScreenName+": "+model.tweetText
                pageStack.push(Qt.resolvedUrl("../NewTweetPage.qml"), {type: "RT", placedText: text, tweetId: model.retweetId})
            }
        }
        MenuItem{
            text: qsTr("%1 Profile").arg("<font color=\"LightSeaGreen\">@" + model.screenName + "</font>")
            onClicked: pageStack.push(Qt.resolvedUrl("../UserPage.qml"), {screenName: model.screenName})
            platformStyle: MenuItemStyle{ position: rtScreenName.visible ? "vertical-center" : "vertical-bottom" }
        }
        MenuItem{
            id: rtScreenName
            text: qsTr("%1 Profile").arg("<font color=\"LightSeaGreen\">@" + model.displayScreenName + "</font>")
            visible: model.displayScreenName != model.screenName
            onClicked: pageStack.push(Qt.resolvedUrl("../UserPage.qml"), {screenName: model.displayScreenName})
        }
    }

    Component.onCompleted: {
        open()
        basicHapticEffect.play()
    }

    onStatusChanged: {
        if(status === DialogStatus.Closing) __isClosing = true
        else if(status === DialogStatus.Closed && __isClosing) root.destroy(250)
    }
}
