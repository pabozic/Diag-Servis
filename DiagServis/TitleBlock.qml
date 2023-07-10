import QtQuick 2.0
//import "../baseComponents"

Item {
    id: root
    height:30


    property var titleBlockHeight:30
    property var titleBlockBg:'gray'
    property var titleText:'No text'
    property var titleTextFontSize:12
    property var titleTextColor:"#ffffff"
    property var showCloseButton:false
    property var showBackButton: false
    property var fontBold:false

    signal closeBtnClicked(var currentIndex);
    signal backButtonClicked();

    CDButton {
                  id: backButton
                       height: titleBlockHeight
                       width: (showBackButton)? parent.width * 0.2: 0
                       anchors.left: parent.left
                       //anchors.right: parent.right
//                     anchors.top: tabBarElement.bottom
                       anchors.topMargin: 0
                       txtText.text:"Back"
                       enabled: showBackButton
                       visible:showBackButton
                       idleCol:"blue"
                       mouseArea.onClicked: {
                           console.log("TitleBlock:: TEST")
                           /*
                           showDebugMsg({"deviceName": "Client","msg":">>>>>>>>>>>>>> close cameraHistoryDialog <<<<<<<<<<<<<<<   " });
                           root.bDialogOpened = false;
                           root.bExpectingCalibrationImg = false;
                           cameraHistoryDialog.close();
                           */
                           backButtonClicked();
                       }

              }

    Rectangle {
        id:titleBlock
        width:(showCloseButton)?root.width*0.70:root.width
        height: parent.height
        color: titleBlockBg
        anchors.top: root.top
        anchors.left: backButton.right;

        border.color: "#9fcced"
        border.width: 0

      //  anchors.bottomMargin: 50
       // anchors.bottomMargin: 50
        Text {
            id:titleBlockText
            text: titleText
            anchors.fill: parent
           // anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: titleTextFontSize
                        font.bold:fontBold

            color:titleTextColor
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            wrapMode: Text.WordWrap
            z:1
        }
        Rectangle {
            id: rGradient
            z: 0
//            color: "#77404040"
            color: titleBlockBg

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

    CDButton {
                  id: camHistorydialogCloseBtn
                       height: titleBlockHeight
                       anchors.left: titleBlock.right
                       anchors.right: parent.right
//                       anchors.top: tabBarElement.bottom
                       anchors.topMargin: 0
                       txtText.text:"X"
                       enabled: showCloseButton
                       visible:showCloseButton
                       idleCol:"#990000"
                       mouseArea.onClicked: {
                           /*
                           showDebugMsg({"deviceName": "Client","msg":">>>>>>>>>>>>>> close cameraHistoryDialog <<<<<<<<<<<<<<<   " });
                           root.bDialogOpened = false;
                           root.bExpectingCalibrationImg = false;
                           cameraHistoryDialog.close();
                           */
                           closeBtnClicked(1);
                       }

              }

    states: [
              State{
              name: "Visible"
              PropertyChanges {
                                target: root;
                                height:titleBlockHeight
                                visible:true
                              }
              },
                State{
                name: "Hidden"
                PropertyChanges {
                                    target: root;
                                    height:0
                                    visible:false
                                }
                }
    ]
}
