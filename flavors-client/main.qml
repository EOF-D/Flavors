import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15

import "components" as Components

ApplicationWindow {
    id : window
    width : 300
    height : 400
    visible : true
    title : qsTr("Flavors")

    header : ToolBar {
        id : toolbar
        Material.elevation : 1
        Material.background : Material.primaryColor
        RowLayout {
            height : 15
            width : parent.width
            anchors.fill : parent
            anchors.margins : 16
        }
    }

    StackLayout {
        id : stackLayout
        anchors.top : toolbar.bottom
        anchors.bottom : parent.bottom
        anchors.left : parent.left
        anchors.right : parent.right
        currentIndex : apiClient.isLoggedIn
            ? 1
            : 0

        Components.LoginPage {
            id : loginPage
            onLoginClicked : {
                apiClient.login(username, password)
            }
        }

        Components.UserPage {
            id : userPage
        }
    }

    Connections {
        target : apiClient
        function onLoginChange() {
            stackLayout.currentIndex = apiClient.isLoggedIn
                ? 1
                : 0
        }
    }
}
