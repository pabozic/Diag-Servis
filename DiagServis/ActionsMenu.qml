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

    signal actionMenuSelected (var deviceParams)

    property var menuTitle:0
    property var actionsArray:0
    property var labelFieldName:0
    property var listViewSpacing:0
    property var buttonHeight: 35

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

    //__init
    function init()
    {

        console.log("main::init > init 1");

    }



      TitleBlock{
      id:dialogComponentTitleBox
      width:parent.width
      height:40
      titleBlockHeight:40
      titleBlockBg:'gray'
      titleText:menuTitle
      titleTextFontSize:12
      titleTextColor:"#ffffff"
      showCloseButton:false
      onCloseBtnClicked:{
                          root.bDialogOpened = false;
                          dialogComponent.close();
                          }
    }

    Rectangle {
        id: dialogBtnBlock
        width: parent.width
        anchors.top:dialogComponentTitleBox.bottom
        anchors.left:parent.left
        anchors.topMargin: 5
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 5
        color:"white"

        Rectangle {
                 id:rectangleBlock
                 visible: true
                 width:parent.width
                 height:parent.height
                 anchors.left: parent.left
                 anchors.right: parent.right
                 anchors.top: parent.top
                 ListView {
                     id:paramsSetValuesEditList
                     model: testButtonsModel
                     anchors.left:parent.left
                     anchors.right:parent.right
                     height:parent.height
                     anchors.top:parent.top
                     boundsBehavior: Flickable.StopAtBounds
                     spacing: listViewSpacing

                     property var textFieldMap:0
                     cacheBuffer:1000
                     delegate:
                                CDButton {
                                        id: actionBtn
                                        objectName: "actionBtn"
                                         height: buttonHeight
                                         width:parent.width
                                         anchors.topMargin: 2

                                         txtText.text:txtLabel
                                         enabled: true
                                         idleCol:bgColor
                                         mouseArea.onClicked:{
                                            console.log("button clicked listIndex" + index)
                                             var device = testButtonsModel.get(index)
                                            console.log(JSON.stringify(device))
                                             actionMenuSelected(device)
                                         }

                                       }

                 }
        }
    }



}
