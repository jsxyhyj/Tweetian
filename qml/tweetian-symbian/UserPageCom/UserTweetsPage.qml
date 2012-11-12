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
import "../Delegate"
import "../Services/Twitter.js" as Twitter

AbstractUserPage{
    id: userTweetsPage

    headerText: qsTr("Tweets")
    headerNumber: userInfoData.statusesCount
    emptyText: qsTr("No tweet")
    loadMoreButtonVisible: listView.count > 0 && listView.count % 50 === 0
    delegate: TweetDelegate{}

    onReload: {
        var maxId = ""
        if(reloadType === "all") listView.model.clear()
        else maxId = listView.model.get(listView.count - 1).tweetId

        Twitter.getUserTweets(userInfoData.screenName, maxId,
        function(data){
            backButtonEnabled = false
            userTweetsParser.sendMessage({'model': listView.model, 'data': data, 'reloadType': reloadType})
        },
        function(status, statusText){
            infoBanner.showHttpError(status, statusText)
            loadingRect.visible = false
        })
        loadingRect.visible = true
    }

    WorkerScript{
        id: userTweetsParser
        source: "../WorkerScript/TimelineParser.js"
        onMessage: {
            backButtonEnabled = true
            loadingRect.visible = false
        }
    }
}
