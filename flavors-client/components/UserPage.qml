import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.15

Item {
    id: userPage
    width: 300
    height: 400

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 20

        TabBar {
            id: tabBar
            Layout.fillWidth: true

            TabButton {
                text: "Recipes"
            }

            TabButton {
                text: "Favorites"
            }
        }

        StackLayout {
            id: stackLayout
            currentIndex: tabBar.currentIndex
            Layout.fillWidth: true
            Layout.fillHeight: true

            // Recipes tab
            Item {
                ColumnLayout {
                    anchors.fill: parent

                    TextField {
                        id: searchField
                        Layout.fillWidth: true
                        placeholderText: "Search recipes..."
                        Material.accent: Material.Orange
                        onTextChanged: console.log(text);
                    }

                    ListView {
                        id: recipeListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: apiClient.placeholder
                        delegate: recipeDelegate
                    }
                }
            }

            // Favorites tab
            Item {
                ColumnLayout {
                    anchors.fill: parent

                    TextField {
                        id: favoritesSearchField
                        Layout.fillWidth: true
                        placeholderText: "Search favorites..."
                        Material.accent: Material.Orange
                    }

                    ListView {
                        id: favoritesListView
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: apiClient.plceholder
                        delegate: recipeDelegate
                    }
                }
            }
        }
    }

    // Recipe delegate component
    Component {
      id: recipeDelegate

      ItemDelegate {
          width: parent.width
          height: 80
          padding: 10

          RowLayout {
              anchors.fill: parent
              spacing: 10

              ColumnLayout {
                  Layout.fillWidth: true
                  spacing: 5

                  Text {
                      text: model.name
                      font.bold: true
                      color: Material.foreground
                      elide: Text.ElideRight
                      Layout.fillWidth: true
                  }

                  Text {
                      text: model.description
                      color: Material.foreground
                      elide: Text.ElideRight
                      maximumLineCount: 2
                      Layout.fillWidth: true
                  }
              }
          }
      }
  }
}
