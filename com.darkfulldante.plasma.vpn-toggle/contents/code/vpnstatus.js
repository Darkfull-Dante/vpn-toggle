
// hardcoded value, no longer used in dev, possible use for debug
var vpnStatusCommand = 'nordvpn status';

function getFullCommand(service, option) {
    return String(service) + " " + String(option) 
}

function parseStatusString(statusString) {
    
    function parseIsConnected(statusString) {
        let status = statusString.match(/VPN connection state : (\w+)/);
        return (status !== null) && (status[1] === "connected")
    }

    function parseLocation(statusString) {
        return parseStringProperty(statusString, 'Connected location   ');
    }

    function parseSessionUptime(statusString) {
        return parseStringProperty(statusString, 'Session uptime       ');
    }

    function parseStringProperty(statusString, propertyName) {
        let pattern = new RegExp(propertyName + ': (.*)')    
        let value = statusString.match(pattern);
        // value will be null if not in statusString (e.g. when disconnected), so have to check for this and return empty string instead
        return value ? value[1] : ""; 
    }

    return {
        connected: parseIsConnected(statusString),
        location: parseLocation(statusString),
        sessionUptime: parseSessionUptime(statusString),
    };
    
}


function getConnectionShortSummary(conn) {
    if (conn.connected) {
        let result = [
            i18n("Connected"), "\n", 
            i18n("Location : "), conn.location, "\n",
            i18n("Session Uptime : "), conn.sessionUptime, "\n"
        ]
 
        return result.join('');
        
    }
    else {
        return i18n("Not connected");
    }
}
