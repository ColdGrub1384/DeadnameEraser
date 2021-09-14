browser.runtime.onMessage.addListener((request, sender, sendResponse) => {
    browser.storage.local.get((item) => {
        var timesDeadnamed = item;
        
        if (request == "names") {
            browser.runtime.sendNativeMessage("Deadname Eraser", {}, function(response) {
                sendResponse(response);
            });
        } else if (request.deadnamed == undefined) {
            var res = { deadnamed: timesDeadnamed[request.tabID] };
            sendResponse(res);
        } else {
            timesDeadnamed[sender.tab.id] = request.deadnamed;
            browser.storage.local.set(timesDeadnamed);
            sendResponse({ ok: 2 });
        }
    });
    
    return true;
});
