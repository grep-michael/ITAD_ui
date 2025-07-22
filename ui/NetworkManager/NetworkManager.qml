import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import Theme 1.0
import NetworkMonitor 1.0

Rectangle {
    id: networkManager
    NetworkMonitor{
        id: networkMonitor
        Component.onDestruction: monitor.cleanup()
    }
    Rectangle {
        anchors.fill: parent
        gradient: Gradient {
            GradientStop { position: 0.0; color: "#f8f9fa" }
            GradientStop { position: 1.0; color: "#e9ecef" }
        }

        ColumnLayout {
            anchors.centerIn: parent
            spacing: 25

            // Header
            Text {
                text: "Network Status"
                font.pixelSize: 24
                font.weight: Font.Bold
                color: "#343a40"
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }

            // Status indicator circle
            Rectangle {
                width: 80
                height: 80
                radius: 40
                color: networkMonitor.connected ? "#28a745" : "#dc3545"
                border.width: 3
                border.color: networkMonitor.connected ? "#1e7e34" : "#bd2130"
                Layout.alignment: Qt.AlignHCenter
                
                // Animated pulse effect when connected
                SequentialAnimation on scale {
                    running: networkMonitor.connected
                    loops: Animation.Infinite
                    NumberAnimation { to: 1.1; duration: 1000; easing.type: Easing.InOutQuad }
                    NumberAnimation { to: 1.0; duration: 1000; easing.type: Easing.InOutQuad }
                }
                
                Text {
                    anchors.centerIn: parent
                    text: networkMonitor.connected ? "●" : "●"
                    color: "white"
                    font.pixelSize: 32
                }
            }

            // Status message
            Rectangle {
                width: 320
                height: 50
                radius: 8
                color: "white"
                border.width: 1
                border.color: "#dee2e6"
                Layout.alignment: Qt.AlignHCenter
                
                Text {
                    anchors.centerIn: parent
                    text: networkMonitor.statusMessage
                    font.pixelSize: 16
                    color: "#495057"
                    horizontalAlignment: Text.AlignHCenter
                }
            }

            // Latency information
            Rectangle {
                visible: networkMonitor.connected
                width: 320
                height: 80
                radius: 8
                color: "white"
                border.width: 1
                border.color: "#dee2e6"
                Layout.alignment: Qt.AlignHCenter
                
                ColumnLayout {
                    anchors.centerIn: parent
                    spacing: 8
                    
                    Text {
                        text: "Latency: " + networkMonitor.latency.toFixed(1) + " ms"
                        font.pixelSize: 18
                        font.weight: Font.Medium
                        color: {
                            if (networkMonitor.latency < 50) return "#28a745"
                            else if (networkMonitor.latency < 150) return "#ffc107"
                            else return "#dc3545"
                        }
                        horizontalAlignment: Text.AlignHCenter
                        Layout.fillWidth: true
                    }
                    
                    // Connection quality bar
                    Rectangle {
                        width: 250
                        height: 12
                        radius: 6
                        color: "#e9ecef"
                        Layout.alignment: Qt.AlignHCenter
                        
                        Rectangle {
                            width: {
                                var quality = Math.max(0, Math.min(1, (300 - networkMonitor.latency) / 300))
                                return parent.width * quality
                            }
                            height: parent.height
                            radius: parent.radius
                            color: {
                                if (networkMonitor.latency < 50) return "#28a745"
                                else if (networkMonitor.latency < 100) return "#20c997"
                                else if (networkMonitor.latency < 200) return "#ffc107"
                                else return "#dc3545"
                            }
                            
                            Behavior on width {
                                NumberAnimation { duration: 400; easing.type: Easing.OutQuart }
                            }
                        }
                    }
                }
            }

            // Quality indicator text
            Text {
                visible: networkMonitor.connected
                text: {
                    if (networkMonitor.latency < 50) return "Excellent"
                    else if (networkMonitor.latency < 100) return "Good"
                    else if (networkMonitor.latency < 200) return "Fair"
                    else return "Poor"
                }
                font.pixelSize: 14
                color: {
                    if (networkMonitor.latency < 50) return "#28a745"
                    else if (networkMonitor.latency < 100) return "#20c997"
                    else if (networkMonitor.latency < 200) return "#ffc107"
                    else return "#dc3545"
                }
                horizontalAlignment: Text.AlignHCenter
                Layout.fillWidth: true
            }
        }
    }
}