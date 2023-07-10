import QtQuick 2.12
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.3
import QtQuick.Controls 1.4
//import QtQuick.Controls 2.5

Item {
    id: root
    property var mainPageRef: 0
    property alias rnTableModel: rnTableModel
    property alias rnTableModelServis: rnTableModelServis


    ListModel {
        id: rnTableModelServis

        // Retrieve data from database for deffectInputs table
        Component.onCompleted: {
            /*db.readTransaction(function(tx) {
                var rs = tx.executeSql("SELECT * FROM RNTable")
                for (var i = 0; i < rs.rows.length; i++) {
                    var row = rs.rows.item(i)
                    append({
                        "UID": row.UID,
                        "Name": row.Name,
                        "Desc": row.Desc,
                        "ParentID": row.ParentID,
                        "DeviceID": row.DeviceID,
                        "DateTime": row.DateTime,
                        "Status": row.Status,
                        "Type": row.Type,
                        "CodeName": row.CodeName,
                        "StartDate": row.StartDate,
                        "EndDate": row.EndDate,
                        "OperID": row.OperID
                    })
                }
            })*/
        }
    }

    ListModel {
        id: rnTableModel

        // Retrieve data from database for deffectInputs table
        Component.onCompleted: {
            /*db.readTransaction(function(tx) {
                var rs = tx.executeSql("SELECT * FROM RNTable")
                for (var i = 0; i < rs.rows.length; i++) {
                    var row = rs.rows.item(i)
                    append({
                        "UID": row.UID,
                        "Name": row.Name,
                        "Desc": row.Desc,
                        "ParentID": row.ParentID,
                        "DeviceID": row.DeviceID,
                        "DateTime": row.DateTime,
                        "Status": row.Status,
                        "Type": row.Type,
                        "CodeName": row.CodeName,
                        "StartDate": row.StartDate,
                        "EndDate": row.EndDate,
                        "OperID": row.OperID
                    })
                }
            })*/
        }
    }

    Item {
        id: thirdItem
        anchors.fill: parent

        TitleBlock{
        id:dialogComponentTitleBox
        width:parent.width
        height:40
        titleBlockHeight:40
        titleBlockBg:'gray'
        titleText:"Device Dashboard"
        titleTextFontSize:12
        titleTextColor:"#ffffff"
        showCloseButton:true
        showBackButton: true
        onCloseBtnClicked:{
                            root.bDialogOpened = false;
                            dialogComponent.close();
                            }
        onBackButtonClicked: {
            console.log("DiagPage:: Ulaz")
            mainPageRef.tabBar.currentIndex = 0
        }
      }


        TabBar {
            id: rnTab
            height: 40
            anchors.top:dialogComponentTitleBox.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            width: parent.width

            TabButton {
              text: "Diag"
            }

            TabButton {
              text: "Servis"
            }
        }


        StackLayout {
            id: diagStackLayout
            //anchors.fill: parent
            anchors.left: parent.left
            anchors.right: parent.right
            width: parent.width
            anchors.bottom: parent.bottom
            anchors.top: rnTab.bottom
            currentIndex: rnTab.currentIndex

            Item {

                CDButton {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    //anchors.right: parent.right
                    //anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    id: newDiagButton
                    objectName: "actionBtn"
                    height: 25
                    width:parent.width/2
                    anchors.topMargin: 2
                    txtText.text: "Nova Dijagnostika"
                    enabled: true
                    idleCol:bgColor
                    mouseArea.onClicked:{
                        console.log("Device Dahsboard New Diag Button Clicked")
                        root.mainPageRef.activateDiagnostic()
                        }
                    }

                CDButton {
                    anchors.top: parent.top
                    anchors.left: newDiagButton.right
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    id: newDiagButton2
                    objectName: "actionBtn"
                    height: 25
                    //width:parent.width/2
                    anchors.topMargin: 2
                    txtText.text: "Otvori Odabranu Dijagnostiku"
                    enabled: true
                    idleCol:bgColor
                    mouseArea.onClicked:{
                        console.log("Device Dahsboard New Diag Button Clicked")
                        console.log("deviceDashboard::" + rnView.currentRow)
                        var selectedItem = rnTableModel.get(rnView.currentRow)
                        var selectedDiagID = selectedItem["UID"]
                        console.log(JSON.stringify(selectedItem))
                        root.mainPageRef.activateDiagnostic(selectedDiagID, selectedItem)
                        }
                    }

                    TableView {
                        id: rnView
                        width: parent.width
                        height: parent.height/5
                        anchors {
                            left: parent.left
                            top: newDiagButton.bottom
                            topMargin: 5
                            //top: inputView.bottom
                            //topMargin: 20
                        }

                        // Set list model for deviceDefects table as table model
                        model: rnTableModel

                        // Define table columns for deviceDefects table
                        TableViewColumn { title: "UID";    role: "UID" }
                        TableViewColumn { title: "Name";   role: "Name" }
                        TableViewColumn { title: "Desc";   role: "Desc" }
                        TableViewColumn { title: "ParentID"; role: "ParentID" }
                        TableViewColumn { title: "DeviceID"; role: "DeviceID" }
                        TableViewColumn { title: "DateTime"; role: "DateTime" }
                        TableViewColumn { title: "Status"; role: "Status" }
                        TableViewColumn { title: "Type"; role: "Type" }
                        TableViewColumn { title: "CodeName"; role: "CodeName" }
                        TableViewColumn { title: "StartDate"; role: "StartDate" }
                        TableViewColumn { title: "EndDate"; role: "EndDate" }
                        TableViewColumn { title: "OperID"; role: "OperID" }
                    }
                }

            Item {

                CDButton {
                    anchors.top: parent.top
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.leftMargin: 5
                    id: newServisButton
                    objectName: "actionBtn"
                    height: 25
                    width:parent.width
                    anchors.topMargin: 2
                    txtText.text:"Novi Servis"
                    enabled: true
                    idleCol:bgColor
                    mouseArea.onClicked:{
                        //console.log("button clicked listIndex" + index)
                        //var device = testButtonsModel.get(index)
                        //console.log(JSON.stringify(device))
                        //selectedDeviceParams(device)
                        console.log("Device Dahsboard New Diag Button Clicked")
                        root.mainPageRef.activateDiagnosticServis()
                        }
                    }
                    TableView {
                        id: rnViewServis
                        width: parent.width
                        height: parent.height/5
                        anchors {
                            left: parent.left
                            top: newServisButton.bottom
                            topMargin: 5
                            //top: inputView.bottom
                            //topMargin: 20
                        }

                        // Set list model for deviceDefects table as table model
                        model: rnTableModelServis

                        // Define table columns for deviceDefects table
                        TableViewColumn { title: "UID";    role: "UID" }
                        TableViewColumn { title: "Name";   role: "Name" }
                        TableViewColumn { title: "Desc";   role: "Desc" }
                        TableViewColumn { title: "ParentID"; role: "ParentID" }
                        TableViewColumn { title: "DeviceID"; role: "DeviceID" }
                        TableViewColumn { title: "DateTime"; role: "DateTime" }
                        TableViewColumn { title: "Status"; role: "Status" }
                        TableViewColumn { title: "Type"; role: "Type" }
                        TableViewColumn { title: "CodeName"; role: "CodeName" }
                        TableViewColumn { title: "StartDate"; role: "StartDate" }
                        TableViewColumn { title: "EndDate"; role: "EndDate" }
                        TableViewColumn { title: "OperID"; role: "OperID" }
                    }

                }
            }
        }
}
