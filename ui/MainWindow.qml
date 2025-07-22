import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import Theme 1.0
import Header 1.0
import Utils 1.0
import NetworkManager 1.0

Window{
    id: mainWindow
    title: "ITAD Platform"
    width: Screen.width * 0.8   // 80% of screen width
    height: Screen.height * 0.8 // 80% of screen height
    minimumWidth: 600    // Minimum usable size
    minimumHeight: 450
    color: Colors.backgroundColor
    visible: true

    property real headerHeight: height * 0.12        // 12% of window height
    property real menuHeight: height * 0.08          // 8% of window height  
    property real statusBarHeight: height * 0.04     // 4% of window height
    property real baseFontSize: Math.min(width * 0.015, height * 0.025)  // Responsive font
    property real marginSize: Math.min(width * 0.02, height * 0.03)      // Responsive margins

    ColumnLayout{
        id: verticalLayout
        anchors.fill: parent
        spacing: 0

        HeaderWidget{
            id: headerWidget
            Layout.fillWidth: true
            Layout.preferredHeight: mainWindow.headerHeight
            Layout.minimumHeight: 60

            width: mainWindow.width
            height: mainWindow.headerHeight
        }
        NetworkManager{
            Layout.preferredHeight: mainWindow.menuHeight
            Layout.minimumHeight: 60

            width: mainWindow.width
            height: mainWindow.headerHeight
        }
        
        
    }

}