import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

Rectangle {
    id : loginPage
    color : "#f3f3f3"
    Layout.fillWidth : true
    Layout.fillHeight : true
    property string username
    property string password
    signal loginClicked(string username, string password)
    Keys.onPressed : {
        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
            loginClicked(username, password)
        }
    }

    ColumnLayout {
        anchors.centerIn : parent
        spacing : 15

        Text {
            text : "Flavors - Login"
            font.italic : true
            font.pointSize : 24
            Layout.alignment : Qt.AlignHCenter
        }

        TextField {
            id : usernameField
            placeholderText : "Username"
            onTextChanged : username = text
            Layout.fillWidth : true
            Keys.onPressed : {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    loginClicked(username, password)
                }
            }
        }

        TextField {
            id : passwordField
            placeholderText : "Password"
            echoMode : TextInput.Password
            onTextChanged : password = text
            Layout.fillWidth : true
            Keys.onPressed : {
                if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                    loginClicked(username, password)
                }
            }
        }

        Button {
            text : "Login"
            onClicked : loginClicked(username, password)
            Layout.fillWidth : true
        }

        Text {
            color : "#007aff"
            Layout.alignment : Qt.AlignHCenter
            text : "Forgot password?"
            MouseArea {
                anchors.fill : parent
                onClicked : {
                    console.log("Forgot password clicked")
                }
            }
        }
    }
}
