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

    signal selectedDeviceParams (var deviceParams)
    property var mainPageRef: 0
    property alias deviceDefectsModel: deviceDefectsModel

    property var menuTitle: "DIAG FOR DEVICE"
    property var actionsArray:0
    property var labelFieldName:0
    property var listViewSpacing:0


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

    function init () {
        var actionsArray = [];
        actionsArray.push({"DefectName":"001","DefectType":"Oštećenje 01","DefectCode":"DF0001","DefectLabel":"Oštećenje 01", "bgColor": "green"});

        actionsArray.push({"DefectName":"002","DefectType":"Oštećenje 02","DefectCode":"DF0002","DefectLabel":"Oštećenje 02", "bgColor": "green"});

        actionsArray.push({"DefectName":"003","DefectType":"Oštećenje 03","DefectCode":"DF0003","DefectLabel":"Oštećenje 03", "bgColor": "green"});
        actionsMenu.setData(actionsArray);
    }

    ListModel {
        id: deviceDefectsModel

        // Retrieve data from database for deviceDefects table
        Component.onCompleted: {
            /*db.readTransaction(function(tx) {
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
                        //"InputType": row.InputType,
                    })
                }
            })*/
        }
    }





    TitleBlock{
    id:dialogComponentTitleBox
    width:parent.width
    height:40
    titleBlockHeight:40
    titleBlockBg:'gray'
    titleText:"Diag Page"
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
        mainPageRef.tabBar.currentIndex = 1
    }
  }

    ActionsMenu{
            id:actionsMenu
          //anchors.centerIn: parent
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: 10
          anchors.rightMargin: 10
          width: parent.width
          height: parent.height/2
          anchors.top: dialogComponentTitleBox.bottom
          z:100000
          menuTitle:"Deffects Category"
          labelFieldName:"DefectLabel"
          listViewSpacing:2
          buttonHeight: 20
          onActionMenuSelected: function (menuItemParams) {
              console.log("DevicePage actionMenu" + JSON.stringify(menuItemParams))
              root.mainPageRef.activateDiagDeffectInputsPage(0,menuItemParams)
          }




        }

    CDButton {
        anchors.top: actionsMenu.bottom
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        id: newDiagButton2
        objectName: "actionBtn"
        height: 25
        //width:parent.width/2
        anchors.topMargin: 2
        txtText.text: "Prikaži Inpute Odabranog Defekta"
        enabled: true
        idleCol:bgColor
        mouseArea.onClicked:{
            console.log("Device Dahsboard New Diag Button Clicked")
            console.log("deviceDashboard::" + tableView.currentRow)
            var selectedItem = deviceDefectsModel.get(tableView.currentRow)
            var selectedDeffectID = selectedItem["UID"]
            console.log(JSON.stringify(selectedItem))
            root.mainPageRef.activateDiagDeffectInputsPage(selectedDeffectID, selectedItem)
            }
        }

    TableView {
        id: tableView
        width: parent.width
        height: parent.height/5
        anchors {
            left: parent.left
            top: newDiagButton2.bottom
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
        //TableViewColumn { title: "InputType"; role: "InputType" }
    }

    Component.onCompleted: {
        init();
    }



}

