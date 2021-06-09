var timesDeadnamed = {};

browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    
    console.log("Received request: ", request);
    
    if (request == "names") {
        browser.runtime.sendNativeMessage("Deadname Remover", {}, function(response) {
            sendResponse(response);
        });
        return true;
    } else if (request.deadnamed == undefined) {
        var res = { deadnamed: timesDeadnamed[request.tabID] };
        sendResponse(res);
    } else {
        timesDeadnamed[sender.tab.id] = request.deadnamed;
        sendResponse({ ok: 2 });
    }
});
