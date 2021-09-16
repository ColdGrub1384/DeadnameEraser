chrome.runtime.onMessage.addListener((request, sender, sendResponse) => {
    chrome.storage.local.get((item) => {
        if (request == "names") {
            var _item = item.names;
            if (_item === undefined) {
                _item = [];
            }
            sendResponse(_item);
        } else if (request.names !== undefined) {
            chrome.storage.local.set({ names: request.names });
            sendResponse({ ok: 1 });
        }
    });
    
    return true;
});
