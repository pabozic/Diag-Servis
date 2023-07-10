import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.5
import QtMultimedia 5.9

import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

//import "Base"

Item {
    id: root

    signal selectedDeviceParams (var deviceParams)
    property var mainPageRef: 0
    property var imageGalleryRef: 0
    signal deffectInputCreated(var deffectInputParams);

    property var menuTitle: "DIAG FOR DEVICE"
    property var actionsArray:0
    property var labelFieldName:0
    property var listViewSpacing:0

    Timer {
        id: timer
        interval: 1000 // 3 seconds
        onTriggered: {
            imageGalleryRef.slider.model.append({image: "file:///C:/Users/Patrik/Pictures/" + imageName});
            imageGalleryRef.imageCaptured("file:///C:/Users/Patrik/Pictures/" + imageName)
        }
    }


    ListModel {
        id: testButtonsModel
    }

    //__setData
    function setData(_actions_array)
    {
        console.log("NdAriadneRightSidebar::setData  ");
         actionsArray = _actions_array;
        testButtonsModel.clear();
        for(var i=0;i<actionsArray.length;i++)
        {
            console.log("NdAriadneRightSidebar:: init adding new button");


            actionsArray[i]["txtLabel"] = actionsArray[i][labelFieldName];

            testButtonsModel.append(actionsArray[i]);
        }
    }

    function refreshWidget (params) {
        console.log("DiagDeffectInputDashboard::refreshWidget > function Start" + JSON.stringify(params))
        var DefectInputType = params["DefectInputType"];

        if (DefectInputType == "Image") {
            stackLayout.currentIndex = 0
        }

        if (DefectInputType == "Video") {
            stackLayout.currentIndex = 1
        }

        if (DefectInputType == "Audio") {
            stackLayout.currentIndex = 2
        }

        if (DefectInputType == "TextNote") {
            stackLayout.currentIndex = 3
        }
    }

    function init () {
        var actionsArray = [];
        actionsArray.push({"DefectInputName":"Image","DefectInputType":"Image","DefectInputCode":"DFI_IMG","DefectInputLabel":"ADD_IMAGE", "bgColor": "green"});

        actionsArray.push({"DefectInputName":"Video","DefectInputType":"Video","DefectInputCode":"DFI_VID","DefectInputLabel":"ADD_VIDEO", "bgColor": "green"});

        actionsArray.push({"DefectInputName":"Audio","DefectInputType":"Audio","DefectInputCode":"DFI_AUD","DefectInputLabel":"ADD_AUDIO", "bgColor": "green"});

        actionsArray.push({"DefectInputName":"TextNote","DefectInputType":"Text Note","DefectInputCode":"DFI_TEXTNOTE","DefectInputLabel":"ADD_TEXT_NOTE", "bgColor": "green"});
        actionsMenu.setData(actionsArray);
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent

        Item {
            id: firstItem

            Camera {
                id: camera
            }

            Button {
                z: 1
                text: "Capture"
                anchors.verticalCenter: parent.verticalCenter
                anchors.horizontalCenter: parent.horizontalCenter
                width: 80
                height: 40

                MouseArea {

                    anchors.fill: parent
                    z: 1

                onClicked: {

                    clickCount++
                    camera.imageCapture.capture()

                    var imageName = "IMG_" + ("00000000" + clickCount.toString()).slice(-8) + ".jpg" // generate the image name

                    timer.start()

                    //var imageObject = { image: "file:///C:/Users/Patrik/Pictures/" + imageName };

                    // Save image to database
                    //var uid = clickCount.toString();
                    var uid = mainPageRef.ddiUid
                    mainPageRef.ddiUid++
                    var desc = "Captured image " + imageName
                    var parentID = mainPageRef.activeDeffectParams["UID"]
                    var dateTime = new Date().toISOString()
                    var status = 0

                    // UID, Name, Desc, ParentID, DateTime, Status, InputType



                    db.transaction(function(tx) {
                        tx.executeSql('INSERT INTO deffectInputs VALUES(?, ?, ?, ?, ?, ?)', [uid, imageName, desc, parentID, dateTime, status])
                    })

                    //updateTableViews();
                    // UID, Name, Desc, ParentID, DateTime, Status, InputType
                    var params = {"UID": "12345", "Name": "Name1", "Desc": "Desc1", "ParentID": "12345", "DateTime": "26.03", "Status": "1", "InputType":"image"}
                    deffectInputCreated(params)
                }
            }
        }



            VideoOutput {

                id: viewfinder
                source: camera
                anchors {
                    left: parent.left
                    right: parent.right
                    top: parent.top
                    bottom: parent.bottom
                    bottomMargin: 100
                }
            }
        }

        Item {
            TextInput {
                text: "VideoNote"
            }
        }

        Item {
            TextInput {
                text: "SoundNote"
            }
        }

        Item {
            TextInput {
                text: "TextNote"
            }
        }
    }



    Component.onCompleted: {
        init();
    }



}

