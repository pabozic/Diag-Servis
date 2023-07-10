import QtQuick 2.0
import QtQuick.Window 2.12
import QtQuick.Controls 1.4
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.5

import QtQuick.Controls 2.2
import QtQuick.Controls.Styles 1.4

//import "Base"

Item {
    id: root
    property var mainPageRef: 0
    property alias slider: slider
    signal imageCaptured(var imagePath)



    SwipeView {
        id: slider
        anchors.top: parent.top
        anchors.topMargin: 150
        height: parent.height/4
        width: height
        x:(parent.width-width)/2//make item horizontally center
        property var model: ListModel{}
        clip:true
        Repeater {
            model: slider.model
            Image {
                width: slider.width
                height: slider.height
                source: image
                fillMode: Image.Stretch

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        fileDialog.visible = true
                    }
                }
            }
        }
    }


    PageIndicator {
        anchors.top: slider.bottom
        anchors.topMargin: verticalMargin
        x:(parent.width-width)/2
        currentIndex: slider.currentIndex
        count: slider.count
    }

    Dialog {
        id: fileDialog
        title: "Open Image"
        visible: false

        Image {
            anchors.fill: parent
            width: slider.width*2
            height: slider.height*2
            source: slider.currentItem.source
            fillMode: Image.Stretch
        }
    }




    // Create list models for both tables
    ListModel {
        id: deviceDefectsModel

        // Retrieve data from database for deviceDefects table
        Component.onCompleted: {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql("SELECT * FROM deviceDeffects")
                for (var i = 0; i < rs.rows.length; i++) {
                    var row = rs.rows.item(i)
                    append({
                        "UID": row.UID,
                        "Type": row.Type,
                        "Desc": row.Desc,
                        "ParentID": row.ParentID,
                        "RNUID": row.RNUID,
                        "DateTime": row.DateTime,
                        "Status": row.Status,
                        "InputType": row.InputType,
                    })
                }
            })
        }
    }
/*
    TableView {
        id: tableView
        width: parent.width
        height: parent.height/5
        anchors {
            left: parent.left
            top: parent.top
        }

        // Set list model for deviceDefects table as table model
        model: deviceDefectsModel

        // Define table columns for deviceDefects table
        TableViewColumn { title: "UID";    role: "UID" }
        TableViewColumn { title: "Type";   role: "Type" }
        TableViewColumn { title: "Desc";   role: "Desc" }
        TableViewColumn { title: "ParentID"; role: "ParentID" }
        TableViewColumn { title: "RNUID"; role: "RNUID" }
        TableViewColumn { title: "DateTime"; role: "DateTime" }
        TableViewColumn { title: "Status"; role: "Status" }
        TableViewColumn { title: "InputType"; role: "InputType" }
    }
*/
    ListModel {
        id: deffectInputsModel

        // Retrieve data from database for deffectInputs table
        Component.onCompleted: {
            db.readTransaction(function(tx) {
                var rs = tx.executeSql("SELECT * FROM deffectInputs")
                for (var i = 0; i < rs.rows.length; i++) {
                    var row = rs.rows.item(i)
                    append({
                        "UID": row.UID,
                        "Name": row.Name,
                        "Desc": row.Desc,
                        "ParentID": row.ParentID,
                        "DateTime": row.DateTime,
                        "Status": row.Status,
                    })
                }
            })
        }
    }
/*
    TableView {
        id: inputView
        width: parent.width
        height: parent.height/5
        anchors {
            left: parent.left
            top: tableView.bottom
            topMargin: 20
        }

        // Set list model for deviceDefects table as table model
        model: deffectInputsModel

        // Define table columns for deviceDefects table
        TableViewColumn { title: "UID";    role: "UID" }
        TableViewColumn { title: "Name";   role: "Name" }
        TableViewColumn { title: "Desc";   role: "Desc" }
        TableViewColumn { title: "ParentID"; role: "ParentID" }
        TableViewColumn { title: "DateTime"; role: "DateTime" }
        TableViewColumn { title: "Status"; role: "Status" }
    }
    */
}





