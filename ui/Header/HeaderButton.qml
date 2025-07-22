import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0
RoundButton {
    id: customButton    
    property string buttonText: "D"

    text: buttonText
    Layout.preferredWidth: headerWidget.buttonSize
    Layout.preferredHeight: headerWidget.buttonSize
    Layout.maximumWidth: 60  // Cap maximum size
    Layout.maximumHeight: 60
    Layout.minimumWidth: 30  // Ensure minimum usability
    Layout.minimumHeight: 30
    
    background: Rectangle {
        color: "transparent"
        border.color: Colors.primaryColor  // Using your primary color
        border.width: Math.max(1, headerWidget.buttonSize * 0.025)
        radius: headerWidget.buttonSize * 0.5
    }
    
    contentItem: Text {
        id: buttonTextItem
        text: customButton.text
        color: Colors.textColor  // Using your text color
        font.pixelSize: headerWidget.buttonSize * 0.35
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
    }
    
    
    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        onClicked: parent.clicked()

        onEntered: {
            parent.background.color = Colors.backgroundColor
        }
        onExited: {
            parent.background.color = "transparent"
        }
        onPressed: {
            parent.background.color = Colors.primaryColor
            buttonTextItem.color = Colors.backgroundColor
        }
        onReleased: {
            buttonTextItem.color = Colors.textColor
            parent.background.color = customButton.containsMouse ? Colors.highLightColor : "transparent"
        }
    }
}