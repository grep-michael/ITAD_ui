pragma Singleton
import QtQuick 2.15

Item {
    id: colors

    readonly property color textColor: "#F7F7F2"
    readonly property color primaryColor: "#899878"
    readonly property color highLightColor: "#E4E6C3"
    readonly property color backgroundColor: "#222725"
    readonly property color backgroundHighlightColor: "#121113"

    // Additional semantic color names for better readability
    //readonly property color text: textColor
    //readonly property color primary: primaryColor
    //readonly property color highlight: highLightColor
    //readonly property color background: backgroundColor
    //readonly property color backgroundHighlight: backgroundHighlightColor

    // UI-specific color aliases
    //readonly property color surface: backgroundColor
    //readonly property color surfaceVariant: backgroundHighlightColor
    //readonly property color onSurface: textColor
    //readonly property color onPrimary: textColor
}
