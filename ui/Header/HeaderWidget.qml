import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0
import Utils 1.0

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
    
    


    signal helpClicked()
    signal settingsClicked()
    signal reportIssueClicked()
    signal shutdownClicked()
    Stroke{
        strokeBottom: 10
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
            onClicked: headerWidget.helpClicked()
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