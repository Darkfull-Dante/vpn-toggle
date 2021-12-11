import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtGraphicalEffects 1.12

import QtQml.Models 2.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.plasmoid 2.0
import org.kde.kirigami 2.4 as Kirigami

import '../code/vpnstatus.js' as VpnStatus

Item {
    
    QtObject {
        id: dataModel
        property var status: ({
            connected: false,
            country: "",
        })
        property var raw: ""        
    }
        
    // Always display the compact view.
    // Never show the full popup view even if there is space for it.
    Plasmoid.preferredRepresentation: Plasmoid.compactRepresentation

    Plasmoid.toolTipMainText: i18n("VPN Status");
    Plasmoid.toolTipSubText: i18n(dataModel.raw);
    //Plasmoid.toolTipSubText: VpnStatus.getConnectionShortSummary(dataModel.status)
            
    Plasmoid.compactRepresentation: MouseArea {        
        PlasmaCore.IconItem {
            id: vpnIcon
            anchors.centerIn: parent
            width: Math.round(parent.width * 0.9)
            height: width
            source: plasmoid.file('', 'icons/network-vpn.svg')
        }

        onClicked: {
            plasmoid.expanded = !plasmoid.expanded
        }
        
        ColorOverlay {
            anchors.fill: vpnIcon
            source: vpnIcon
            color: dataModel.status.connected ? theme.positiveColor : theme.textColor
        }
        
       
    }

    Plasmoid.fullRepresentation: Item {
        id: popupView

        Layout.preferredHeight: column.height + 10
        Layout.preferredWidth: column.width + 10
        Plasmoid.hideOnWindowDeactivate: true

        ColumnLayout {
            id: column
            anchors.centerIn: parent
            Kirigami.Heading {
                text: "VPN Status"
                level: 1
            }
            PlasmaComponents.Label {
                text: i18n(dataModel.raw)
            }
            PlasmaComponents.Button {
                Layout.alignment: Qt.AlignHCenter
                text: {
                    if(dataModel.status.connected) {
                        i18ndc("libplasma5","This is longer text","Disconnect")
                    }
                    else {
                        i18ndc("libplasma5","This is longer text","Connect")
                    }
                }
                onClicked: {
                    if (dataModel.status.connected) {
                        toggle.exec(VpnStatus.getFullCommand(plasmoid.configuration.serviceText, plasmoid.configuration.disconnectText))
                    }
                    else {
                        toggle.exec(VpnStatus.getFullCommand(plasmoid.configuration.serviceText, plasmoid.configuration.connectText))
                    }
                }
            }
        }
    }
        
    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: [VpnStatus.getFullCommand(plasmoid.configuration.serviceText, plasmoid.configuration.statusText)]
        onNewData: {
            var exitCode = data["exit code"]
            var exitStatus = data["exit status"]
            var stdout = data["stdout"]
            var stderr = data["stderr"]
            dataModel.status = VpnStatus.parseStatusString(stdout)
            dataModel.raw = data["stdout"]
        }
        
        interval: 1000
    }

    PlasmaCore.DataSource {
        id: toggle
        engine: "executable"
        connectedSources: []

        function exec(cmd) {
            connectSource(cmd)
        }
    }
}
