import QtQuick 2.0
import QtQuick.Controls 2.5
import QtQuick.Layouts 1.12
import org.kde.kirigami 2.4 as Kirigami

Kirigami.FormLayout {
    id: generalPage
  
    property alias cfg_serviceText: serviceText.text
    property alias cfg_statusText: statusText.text
    property alias cfg_connectText: connectText.text
    property alias cfg_disconnectText: disconnectText.text

    TextField {
        id: serviceText
        Kirigami.FormData.label: i18n("Service:")
        placeholderText: i18n("Service Name")
    }

    TextField {
        id: statusText
        Kirigami.FormData.label: i18n("Status:")
        placeholderText: i18n("Status command")
    }

    TextField {
        id: connectText
        Kirigami.FormData.label: i18n("Connect:")
        placeholderText: i18n("Connect command")
    }

    TextField {
        id: disconnectText
        Kirigami.FormData.label: i18n("Disconnect:")
        placeholderText: i18n("Disconnect command")
    }
}