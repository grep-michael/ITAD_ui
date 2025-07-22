import QtQuick 2.15
import QtQuick.Controls.Material 2.15
import QtQuick.Layouts 1.15
import Theme 1.0

Rectangle {
    property int strokeLeft
    property int strokeTop
    property int strokeRight
    property int strokeBottom
    property var strokeColor

    anchors.fill: parent
    color: parent.color
    
    Rectangle {
        visible: strokeLeft
        width: strokeLeft
        anchors {
            left: parent.left
            top: parent.top
            bottom: parent.bottom
        }
        color: strokeColor
    }

    Rectangle {
        visible: strokeTop
        height: strokeTop
        anchors {
            left: parent.left
            top: parent.top
            right: parent.right
        }
        color: strokeColor
    }

    Rectangle {
        visible: strokeRight
        width: strokeRight
        anchors {
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }
        color: strokeColor
    }

    Rectangle {
        visible: strokeBottom
        height: strokeBottom
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }
        color: strokeColor
    }
}