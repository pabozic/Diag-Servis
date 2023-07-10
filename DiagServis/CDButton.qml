import QtQuick 2.0

Item {
    id: root
    width: 200
    height: 75

    property alias mouseArea: mouseArea
    property alias txtText: txtText
    property alias rBg: rBg



    property bool isClicked;
    property var cornerRad;

    property var idleCol;
    property var clickedCol;
    idleCol: "#000000"
    clickedCol: "#77000000"

    cornerRad: 0;
    isClicked: false;

    Rectangle {
        id: rBg
        color: root.isClicked ? clickedCol : idleCol // #101030
        border.color: "#9fcced"
        border.width: 0
        anchors.fill: parent
        radius: root.cornerRad


        Text {
            id: txtText
            z: 1
            width: 250
            color: root.isClicked ? "#ffffff" : "#ffffff" // #101030
            text: qsTr("Text")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            anchors.fill: parent
            font.pixelSize: 16

            MouseArea {
                id: mouseArea
                objectName: "mouseArea"
                anchors.fill: parent
                onClicked: {console.log("CDButton clicked!");}
                onPressed: {root.isClicked = !root.isClicked;}
                onReleased: {root.isClicked = !root.isClicked;}
            }
        }

        Rectangle {
            id: rGradient
            z: 0
            color: "#77404040"
            opacity: root.isClicked ? 1 : 1
            radius: root.cornerRad

            gradient: Gradient {

                GradientStop {
                    position: 0
                    color: "#77595959"
                }

                GradientStop {
                    position: 1
                    color: "#77000000"
                }
            }
            anchors.fill: parent
        }
    }

}
