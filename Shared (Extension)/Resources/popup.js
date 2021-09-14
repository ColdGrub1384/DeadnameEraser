var query = { active: true, currentWindow: true };

browser.runtime.sendMessage("names").then((response) => {
    if (response.length == 0) {
        document.getElementById("message").innerText = "Open the app to configure the web extension.";
    } else {
        browser.tabs.query(query, function (tabs) {
            browser.runtime.sendMessage({tabID: tabs[0].id}).then((response) => {
                if (response.deadnamed > 0) {
                    document.getElementById("message").innerText = "You've been deadnamed " + response.deadnamed + " time(s) on this website 😔";
                }
            });
        })

    }
})
