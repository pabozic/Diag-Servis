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

    function activateDeviceDashboard () {
        console.log("Main::activateDeviceDashboard > function Start")
        tabBar.currentIndex = 1
    }

    function activateDiagnostic () {
        console.log("Main::activateDiagnostic > function Start")
        var rnName = "RN_DIAG_" + acitveDeviceParams["Name"]
        var rnDesc = ""
        var rnDeviceID = acitveDeviceParams["DeviceID"]
        var rnStatus = 1
        var rnType = "Diag"
        var rnCodeName = "RNDiagnostic"
        var rnOperID = "OP1"
        var rnParentID = ""
        var rnDateTime = ""
        var rnStartDate = ""
        var rnEndDate = ""


        db.transaction(function(tx) {
            console.log("Main::activateDiagnostic > INSERTING RECORD IN RNTABLE")
            tx.executeSql('INSERT INTO RNTable VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)', [0, rnName, rnDesc, rnParentID, rnDeviceID, rnDateTime, rnStatus, rnType, rnCodeName, rnStartDate, rnEndDate, rnOperID],
                function(tx, results){
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
                    });
            })
            //tx.executeSql('INSERT INTO RNTable VALUES(Name, Desc, DeviceID, Status, Type, CodeName, OperID)', [rnName, rnDesc, rnDeviceID, rnStatus, rnType, rnCodeName, rnOperID])
        })

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

    function activateDiagDeffectInputsPage (deffectParams) {
        console.log("Main::activateDiagDeffectInputsPage > function Start")
        console.log("Main::activateDiagDeffectInputsPage > Deffect Params" + JSON.stringify(deffectParams) )
        tabBar.currentIndex = 3
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
            text: "Kamera"
        }

        TabButton {
            text: "RNTable"
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
            }
        }


    }

    function updateTableViews() {
        deviceDefectsModel.clear();
        deffectInputsModel.clear();
        rnTableModel.clear();

        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM deviceDeffects")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                deviceDefectsModel.append({
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
                deffectInputsModel.append({
                    "UID": row.UID,
                    "Name": row.Name,
                    "Desc": row.Desc,
                    "ParentID": row.ParentID,
                    "DateTime": row.DateTime,
                    "Status": row.Status,
                })
            }
        });

        db.readTransaction(function(tx) {
            var rs = tx.executeSql("SELECT * FROM RNTable")
            for (var i = 0; i < rs.rows.length; i++) {
                var row = rs.rows.item(i)
                deffectInputsModel.append({
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
        clearTables();
    }

    function clearTables() {
        db.transaction(function(tx) {
            tx.executeSql("DELETE FROM deviceDeffects");
            tx.executeSql("DELETE FROM deffectInputs");
            tx.executeSql("DELETE FROM RNTable");
        });
    }
}
