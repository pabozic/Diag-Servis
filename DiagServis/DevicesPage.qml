import QtQuick 2.12

Item {
    id: root

    property var mainPageRef: 0

    function init () {
        var actionsArray = [];
        actionsArray.push({"UID":"001","DeviceID":"000001","Type":"","Desc":"","ParentID":"","DateTime":"","Status":"","Name":"Pegla","CodeName":"","Group":"","ClassType":"","bgColor":"green"});

        actionsArray.push({"UID":"002","DeviceID":"000002","Type":"","Desc":"","ParentID":"","DateTime":"","Status":"","Name":"Mikser","CodeName":"","Group":"","ClassType":"","bgColor":"green"});
        actionsMenu.setData(actionsArray);
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
          anchors.top: root.top
          anchors.topMargin: 5
          z:100000
          menuTitle:"Devices list"
          labelFieldName:"Name"
          listViewSpacing:2
          onActionMenuSelected: function (menuItemParams) {
              console.log("DevicePage actionMenu" + JSON.stringify(menuItemParams))
              root.mainPageRef.activeDeviceParams = menuItemParams
              root.mainPageRef.activateDeviceDashboard()
          }




        }

    Component.onCompleted: {
        root.init()
    }
}
