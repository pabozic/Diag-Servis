import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.LocalStorage 2.0
import QtQuick.Controls 1.4
import QtQuick.Controls 2.5
import QtMultimedia 5.9
import QtQuick.Layouts 1.3
import QtQuick.Dialogs 1.3


Window {
    id: root
    width: 640
    height: 520
    visible: true
    title: qsTr("Device Defects")

    property var activeRNParams: 0
    property var activeDeffectParams: 0
    property var activeDeffectInputParams: 0
    property var ddUid : 1
    property var rnUid: 1
    property var ddiUid: 1
    property var activeDeviceParams: 0
    property alias tabBar: tabBar

    function activateDeviceDashboard () {
        console.log("Main::activateDeviceDashboard > function Start")
        tabBar.currentIndex = 1
        deviceDashboard.rnTableModel.clear();
        deviceDashboard.rnTableModelServis.clear();
        console.log(JSON.stringify(activeDeviceParams))
        var deviceId = activeDeviceParams["DeviceID"]
        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM RNTable WHERE Type = 'Diag' AND DeviceID = '"+deviceId+"'")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                deviceDashboard.rnTableModel.append({
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
        });

        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM RNTable WHERE Type = 'Servis' AND DeviceID = '"+deviceId+"'")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                deviceDashboard.rnTableModelServis.append({
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
        });
    }

    function activateDiagnosticServis() {
        console.log("Main::activateDiagnostic > function Start")
        console.log(JSON.stringify(activeDeviceParams))
        var rnName = "RN_DIAG_" + activeDeviceParams["Name"]
        var rnDesc = ""
        var rnDeviceID = activeDeviceParams["DeviceID"]
        var rnStatus = 1
        var rnType = "Servis"
        var rnCodeName = "RNDiagnostic"
        var rnOperID = "OP1"
        var rnParentID = ""
        var rnDateTime = ""
        var rnStartDate = ""
        var rnEndDate = ""
        rnUid++;


        db.transaction(function(tx) {
            console.log("Main::activateDiagnostic > INSERTING RECORD IN RNTABLE")
            tx.executeSql('INSERT INTO RNTable VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [rnUid, rnName, rnDesc, rnParentID, rnDeviceID, rnDateTime, rnStatus, rnType, rnCodeName, rnStartDate, rnEndDate, rnOperID]
                /*function(tx, results){
                    console.log("Main::activateDiagnostic > NEW RN TABLE RECORD CREATED")
                    console.log(lastInsertId);
                    root.activeRNParams = {"UID": "12345"}
                    var lastInsertId = results.insertId; // this is the id of the insert just performed
                    tx.executeSql('SELECT * FROM RNTable',
                                  [], function(tx, result){
                                      console.log("BROJ RECORDA" +  result.rows.lenght)
                        for (var i = 0; i < results.rows.length; i++) {
                            console.log("RESULT" + JSON.stringify(result.rows[i]))
                        }
                    }
);

            }*/)
            //tx.executeSql('INSERT INTO RNTable VALUES(Name, Desc, DeviceID, Status, Type, CodeName, OperID)', [rnName, rnDesc, rnDeviceID, rnStatus, rnType, rnCodeName, rnOperID])
        })

        updateTableViews()
        activateDiagPage()
    }

    function activateDiagnostic (selectedDiagID, selectedItem) {
        console.log("Main::activateDiagnostic > function Start")
        console.log("Main::activateDiagnostic >" + JSON.stringify(activeDeviceParams))
        console.log("Main::activateDiagnostic >")
        if (typeof(selectedDiagID != "undefined")) {
            console.log("Selected diag is defined getting existing data")
            console.log("Main::activateDiagnostic >" + JSON.stringify(selectedItem) )
            // UID":3,"Name":"RN_DIAG_Pegla","DeviceID":"000001","Status":1,"Type":"Diag","CodeName":"RNDiagnostic","OperID":"OP1"
            activeRNParams = {"UID": selectedItem["UID"],
                "Name": selectedItem["Name"],
                "Desc": 0,
                "ParentID": 0,
                "DeviceID": selectedItem["DeviceID"],
                "DateTime": 0,
                "Status": selectedItem["Status"],
                "Type": selectedItem["Type"],
                "CodeName": selectedItem["CodeName"],
                "StartDate": 0,
                "EndDate": 0,
                "OperID": selectedItem["OperID"]
            }
        } else {
            console.log("Selected diag is not defined inserting new record")
            var rnName = "RN_DIAG_" + activeDeviceParams["Name"]
            var rnDesc = ""
            var rnDeviceID = activeDeviceParams["DeviceID"]
            var rnStatus = 1
            var rnType = "Diag"
            var rnCodeName = "RNDiagnostic"
            var rnOperID = "OP1"
            var rnParentID = ""
            var rnDateTime = ""
            var rnStartDate = ""
            var rnEndDate = ""
            rnUid++;
            // UID, Name, Desc, ParentID, DeviceID, DateTime, Status, Type, CodeName, StartDate, EndDate, OperID
            activeRNParams = {"UID": rnUid,
                "Name": rnName,
                "Desc": rnDesc,
                "ParentID": rnParentID,
                "DeviceID": rnDeviceID,
                "DateTime": rnDateTime,
                "Status": rnStatus,
                "Type": rnType,
                "CodeName": rnCodeName,
                "StartDate": rnStartDate,
                "EndDate": rnEndDate,
                "OperID": rnOperID
            }


            db.transaction(function(tx) {
                console.log("Main::activateDiagnostic > INSERTING RECORD IN RNTABLE")
                tx.executeSql('INSERT INTO RNTable VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [rnUid, rnName, rnDesc, rnParentID, rnDeviceID, rnDateTime, rnStatus, rnType, rnCodeName, rnStartDate, rnEndDate, rnOperID]
                    /*function(tx, results){
                        console.log("Main::activateDiagnostic > NEW RN TABLE RECORD CREATED")
                        console.log(lastInsertId);
                        root.activeRNParams = {"UID": "12345"}
                        var lastInsertId = results.insertId; // this is the id of the insert just performed
                        tx.executeSql('SELECT * FROM RNTable',
                                      [], function(tx, result){
                                          console.log("BROJ RECORDA" +  result.rows.lenght)
                            for (var i = 0; i < results.rows.length; i++) {
                                console.log("RESULT" + JSON.stringify(result.rows[i]))
                            }
                        }
    );

                }*/)})
        }


        /*
            console.log("Main::activateDiagnostic > AFTER INSERT")
            db.transaction(function(tx) {
            tx.executeSql('SELECT * FROM RNTable',
                [], function(tx, result){
                console.log("BROJ RECORDA" +  result.rows.lenght)
                for (var i = 0; i < results.rows.length; i++) {
                console.log("RESULT" + JSON.stringify(result.rows[i]))
                        }
                    })
            })
            */
            //tx.executeSql('INSERT INTO RNTable VALUES(Name, Desc, DeviceID, Status, Type, CodeName, OperID)', [rnName, rnDesc, rnDeviceID, rnStatus, rnType, rnCodeName, rnOperID])


        updateTableViews()
        activateDiagPage()
    }

    function activateDiagPage () {
        console.log("Main::activateDiagPage > function Start")
        tabBar.currentIndex = 2
    }

    function activateDiagDeffectInputsDashboard (deffectInputParams) {
        console.log("Main::activateDiagDeffectInputsDashboard > function Start")
        console.log("Main::activateDiagDeffectInputsDashboard > Deffect Params" + JSON.stringify(deffectInputParams) )
        tabBar.currentIndex = 4
        activeDeffectInputParams = deffectInputParams

        diagDeffectInputsDashboard.refreshWidget(deffectInputParams);



        // actionsArray.push({"DefectInputName":"Text Note","DefectInputType":"Text Note","DefectInputCode":"DFI_TEXTNOTE","DefectInputLabel":"ADD_TEXT_NOTE", "bgColor": "green"});

        //actionsArray.push({"DefectName":"003","DefectType":"Oštećenje 03","DefectCode":"DF0003","DefectLabel":"Oštećenje 03", "bgColor": "green"});

    }

    function activateDiagDeffectInputsPage (selectedDeffectID, deffectParams) {
        console.log("Main::activateDiagDeffectInputsPage > function Start")
        console.log("Main::activateDiagDeffectInputsPage > Deffect Params" + JSON.stringify(deffectParams) )
        tabBar.currentIndex = 3
        if (typeof(selectedDeffectID != "undefined" ) && selectedDeffectID != 0) {

            // {"UID":"2","Type":"0001","Desc":"Desc1","ParentID":"3","DiagRN":"12345","DateTime":26.04,"Status":1,"InputType":"0"}

            activeDeffectParams =
            {   "UID": deffectParams["UID"],
                "Type": deffectParams["Type"],
                "Desc": deffectParams["Desc"],
                "ParentID": deffectParams["ParentID"],
                "RNUID": deffectParams["DiagRN"],
                "DateTime": deffectParams["DateTime"],
                "Status": deffectParams["Status"]
            }
        } else {
            ddUid += 1

            var ddType = "0001"
            var ddDesc = "Desc1"
            var ddParentID = activeRNParams["UID"]
            var ddRNUID =  "12345"
            var ddDateTime = "26.04"
            var ddStatus = "1"

            // UID, Type, Desc, ParentID, RNUID, DateTime, Status

            activeDeffectParams =
            {   "UID": ddUid,
                "Type": ddType,
                "Desc": ddDesc,
                "ParentID": ddParentID,
                "RNUID": ddRNUID,
                "DateTime": ddDateTime,
                "Status": ddStatus
            }


            db.transaction(function(tx) {
                tx.executeSql('INSERT INTO deviceDeffects VALUES(?, ?, ?, ?, ?, ?, ?, ?)', [ddUid, ddType, ddDesc, ddParentID, ddRNUID, ddDateTime, ddStatus, 0])
            })
        }

        diagDeffectInputsPage.deffectInputsModel.clear();
        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM deffectInputs WHERE ParentID = '"+activeDeffectParams["UID"]+"'")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                diagDeffectInputsPage.deffectInputsModel.append({
                    "UID": row.UID,
                    "Name": row.Name,
                    "Desc": row.Desc,
                    "ParentID": row.ParentID,
                    "DateTime": row.DateTime,
                    "Status": row.Status,
                })
            }
        });


    }

    property int clickCount: 0
    property var imageName : "IMG_" + ("00000000" + clickCount.toString()).slice(-8) + ".jpg"
    property var acitveDeviceParams : [];

    // Open local database
    property var db: LocalStorage.openDatabaseSync("myDb", "1.0", "Local database", 1000000)

    // Create deviceDefects and deffectInputs tables
    Component.onCompleted: {
        db.transaction(function(tx) {
/*
            tx.executeSql("DROP TABLE deviceDdeffects");
            tx.executeSql("DROP TABLE deffectInputs");
            tx.executeSql("DROP TABLE RNTable");
*/
            tx.executeSql("CREATE TABLE IF NOT EXISTS deviceDeffects (UID, Type, Desc, ParentID, RNUID, DateTime, Status);");
            tx.executeSql("CREATE TABLE IF NOT EXISTS deffectInputs (UID, Name, Desc, ParentID, DateTime, Status, InputType);");
            tx.executeSql("CREATE TABLE IF NOT EXISTS RNTable (UID, Name, Desc, ParentID, DeviceID, DateTime, Status, Type, CodeName, StartDate, EndDate, OperID);");
        });
    }

    TabBar {
        id: tabBar
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        TabButton {
            text: "Devices"
        }

        TabButton {
            text: "Device Dashboard"
        }

        TabButton {
            text: "DiagPage"
        }

        TabButton {
            text: "DeffectInputs Page"
        }

        TabButton {
            text: "Tablica"
        }

        TabButton {
            text: "Galerija"
        }
    }

    StackLayout {
        id: stackLayout
        anchors.fill: parent
        currentIndex: tabBar.currentIndex

        Item {
            DevicesPage {
                id: devicesPage
                anchors.fill: parent
                width: parent.width
                height: parent.height/2
                mainPageRef: root
            }
        }

        Item {
            DeviceDashboard {
                id: deviceDashboard
                anchors.fill: parent
                width: parent.width
                height: parent.height/2
                mainPageRef: root
            }
        }

        Item {
            DiagPage {
                id: diagPage
                anchors.fill: parent
                width: parent.width
                height: parent.height/2
                mainPageRef: root
            }
        }

        Item {
            DiagDeffectInputsPage {
                id: diagDeffectInputsPage
                anchors.fill: parent
                width: parent.width
                height: parent.height/2
                mainPageRef: root
            }
        }

        Item {
            DiagDeffectInputsDashboard {
                id: diagDeffectInputsDashboard
                anchors.fill: parent
                width: parent.width
                height: parent.height/2
                mainPageRef: root
                imageGalleryRef: imageGallery
                onDeffectInputCreated: function (params){
                    //updateTableViews();
                    diagDeffectInputsPage.deffectInputsModel.clear();
                    db.readTransaction(function(tx) {
                        var rs = tx.executeSql("SELECT * FROM deffectInputs WHERE ParentID = '"+activeDeffectParams["UID"]+"'")
                        for (var i = 0; i < rs.rows.length; i++) {
                            var row = rs.rows.item(i)
                            diagDeffectInputsPage.deffectInputsModel.append({
                                "UID": row.UID,
                                "Name": row.Name,
                                "Desc": row.Desc,
                                "ParentID": row.ParentID,
                                "DateTime": row.DateTime,
                                "Status": row.Status,
                            })
                        }
                    });
                }
            }
        }

        Item {
            ImageGallery {
                id: imageGallery
                anchors.fill: parent
                width: parent.width
                height: parent.height/2
                mainPageRef: root
                onImageCaptured: function (imagePath) {
                    console.log("Main::onImageCaptured" + imagePath)
                }
            }
        }


    }

    function updateTableViews() {

        diagPage.deviceDefectsModel.clear();
        diagDeffectInputsPage.deffectInputsModel.clear();
        deviceDashboard.rnTableModel.clear();
        deviceDashboard.rnTableModelServis.clear();

        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM deviceDeffects")
            for (var i = 0; i < rs.rows.length; i++) {
                console.log("main:: updateTabelsViews > READ TRANSACTION INDEX: " + i)
                var row = rs.rows.item(i)
                diagPage.deviceDefectsModel.append({
                    "UID": row.UID,
                    "Type": row.Type,
                    "Desc": row.Desc,
                    "ParentID": row.ParentID,
                    "DiagRN": row.DiagRN,
                    "DateTime": row.DateTime,
                    "Status": row.Status,
                    "InputType": row.InputType,
                })
            }
        });


        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM deffectInputs")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                diagDeffectInputsPage.deffectInputsModel.append({
                    "UID": row.UID,
                    "Name": row.Name,
                    "Desc": row.Desc,
                    "ParentID": row.ParentID,
                    "DateTime": row.DateTime,
                    "Status": row.Status,
                })
            }
        });

    //tx.executeSql("CREATE TABLE IF NOT EXISTS RNTable (UID, Name, Desc, ParentID, DeviceID, DateTime, Status, Type, CodeName, StartDate, EndDate, OperID);");


        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM RNTable WHERE Type = 'Diag'")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                deviceDashboard.rnTableModel.append({
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
        });

        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM RNTable WHERE Type = 'Servis'")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                deviceDashboard.rnTableModelServis.append({
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
        });

    }

    Component.onDestruction: {
        //clearTables();
    }

    function clearTables() {
        db.transaction(function(tx) {
            tx.executeSql("DELETE FROM deviceDeffects");
            tx.executeSql("DELETE FROM deffectInputs");
            tx.executeSql("DELETE FROM RNTable");
        });
    }
}
