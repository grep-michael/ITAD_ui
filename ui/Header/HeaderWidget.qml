import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0
import Utils 1.0
import MessageSystem 1.0
import CustomTypes 1.0

Rectangle{
    id: headerWidget
    property string logoText: "ʕ•̫͡•ʔ ITAD Platform"
    property string logoTextRich: "ʕ•̫͡•ʔ <b>ITAD Platform</b>"

    property real buttonSize: Math.min(height * 0.6, width * 0.04)
    property real fontSize: Math.min(height * 0.25, 16)
    property real spacing: width * 0.02

    width: parent.width
    height: parent.height * 0.18

    color: Colors.backgroundHighlightColor
    
    function sendQuickMessage() {
        let message = MessageManager.createMessage("test","test","test",{"data":headerWidget.logoText})
        MessageManager.emitMessage(message)
        //MessageManager.sendMessage(
        //    "info",
        //    "Quick Message", 
        //    "Created and sent in one call",
        //    {"source": "QML Button"}
        //)
    }

    signal settingsClicked()
    signal reportIssueClicked()
    signal shutdownClicked()

    Stroke{
        strokeBottom: 2
        strokeColor: Colors.primaryColor
    }
    RowLayout{
        id: headerLayout
        anchors.fill: parent
        anchors.leftMargin: parent.width * 0.02  // 2% of width
        anchors.rightMargin: parent.width * 0.02
        anchors.topMargin: parent.height * 0.1   // 10% of height
        anchors.bottomMargin: parent.height * 0.1
        spacing: headerWidget.spacing


        Text{
            id: logoLabel
            text: headerWidget.logoTextRich
            textFormat: Text.RichText
            color: Colors.textColor
            font.pixelSize: headerWidget.fontSize
            Layout.preferredWidth: parent.width * 0.15  // 15% of header width
            Layout.fillHeight: true
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight  // Handle overflow gracefully
        }

        Item {//spaceer
            Layout.fillWidth: true
            Layout.fillHeight: true
        }
        HeaderButton{
            buttonText: "?"
            onClicked: headerWidget.sendQuickMessage()
        }
        HeaderButton {
            text: "⚠"
            onClicked: headerWidget.reportIssueClicked()
        }
        HeaderButton {
            text: "⏻"
            onClicked: headerWidget.shutdownClicked()
        }


    }
    

}