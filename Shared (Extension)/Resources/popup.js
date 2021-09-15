var container;
var nameElement;

function load() {
    container.innerHTML = "";
    browser.runtime.sendMessage("names").then((response) => {
        var i = 0;
        response.forEach(function (name) {
            var element = nameElement.cloneNode(true);
            element.getElementsByClassName("element-left")[0].children[0].onclick = remove;
            element.getElementsByClassName("element-left")[0].children[0].id = i.toString();
            
            element.getElementsByClassName("element-left")[0].children[1].value = name.deadname;
            element.getElementsByClassName("element-left")[0].children[1].placeholder = browser.i18n.getMessage("deadname");

            element.getElementsByClassName("element-right")[0].children[0].value = name.chosenname;
            element.getElementsByClassName("element-right")[0].children[0].placeholder = browser.i18n.getMessage("chosen-name");
            container.append(element);
            i += 1;
        })
    });
}

function getNames() {

    var names = [];

    for (const element of container.children) {
        var deadname = element.getElementsByClassName("element-left")[0].children[1].value;
        var chosenname = element.getElementsByClassName("element-right")[0].children[0].value;
        names.push({ "deadname": deadname, "chosenname": chosenname })
    }

    return names;
}

function add() {
    var names = getNames();
    names.push({ "deadname": "", "chosenname": "" });
    browser.runtime.sendNativeMessage("Deadname Eraser", names).then((response) => {
        load();
    });
}

function save() {
    browser.runtime.sendNativeMessage("Deadname Eraser", getNames());
}

function remove(e) {
    var names = getNames();
    names.splice(parseInt(e.target.id), 1);
    browser.runtime.sendNativeMessage("Deadname Eraser", names).then((response) => {
        load();
    });
}


window.onload = function () {

    container = document.getElementById("names-container");
    nameElement = document.getElementsByClassName("name")[0];
    nameElement.remove();

    document.getElementById("add").innerHTML = browser.i18n.getMessage("add");
    document.getElementById("instructions").innerHTML = browser.i18n.getMessage("instructions");

    document.getElementById("add").onclick = add;

    load();
};

window.onblur = save;