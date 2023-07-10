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
    property alias deffectInputsModel: deffectInputsModel

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
        actionsArray.push({"DefectInputName":"Image","DefectInputType":"Image","DefectInputCode":"DFI_IMG","DefectInputLabel":"ADD_IMAGE", "bgColor": "green"});

        actionsArray.push({"DefectInputName":"Video","DefectInputType":"Video","DefectInputCode":"DFI_VID","DefectInputLabel":"ADD_VIDEO", "bgColor": "green"});

        actionsArray.push({"DefectInputName":"Audio","DefectInputType":"Audio","DefectInputCode":"DFI_AUD","DefectInputLabel":"ADD_AUDIO", "bgColor": "green"});

        actionsArray.push({"DefectInputName":"TextNote","DefectInputType":"TextNote","DefectInputCode":"DFI_TEXTNOTE","DefectInputLabel":"ADD_TEXT_NOTE", "bgColor": "green"});
        actionsMenu.setData(actionsArray);
    }

    ListModel {
        id: deffectInputsModel

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
    titleText:"Deffect Inputs"
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
        mainPageRef.tabBar.currentIndex = 2
    }
  }


    ActionsMenu{
            id:actionsMenu
          //anchors.centerIn: parent
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.leftMargin: 10
          anchors.rightMargin: 10
          anchors.bottomMargin: 5
          width: parent.width
          height: parent.height/2
          anchors.top: dialogComponentTitleBox.bottom
          z:100000
          menuTitle:"Deffects Inputs"
          labelFieldName:"DefectInputLabel"
          listViewSpacing:2
          buttonHeight: 20
          onActionMenuSelected: function (menuItemParams) {
              console.log("DevicePage actionMenu" + JSON.stringify(menuItemParams))
              root.mainPageRef.activateDiagDeffectInputsDashboard(menuItemParams)
          }




        }

    TableView {
        id: tableView
        width: parent.width
        height: parent.height/5
        anchors {
            left: parent.left
            top: actionsMenu.bottom
        }

        // Set list model for deviceDefects table as table model
        model: deffectInputsModel

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

