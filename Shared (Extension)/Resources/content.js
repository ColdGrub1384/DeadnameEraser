var timesDeadnamed = 0;

String.prototype.replaceAll = function(strReplace, strWith) {
    // See http://stackoverflow.com/a/3561711/556609
    var esc = strReplace.replace(/[-\/\\^$*+?.()|[\]{}]/g, '\\$&');
    var reg = new RegExp(esc, 'ig');
    return this.replace(reg, strWith);
};

function walkText(node, names) {
    
    if (node.nodeType == 3) {
        var newText = node.data;
        
        names.forEach(function (name) {

            if (name.deadname.replace(" ", "").replace("\t", "") != "") {
                newText = newText.replace(name.deadname.toUpperCase(), name.chosenname.toUpperCase());
                newText = newText.replace(name.deadname.toLowerCase(), name.chosenname.toLowerCase());
                newText = newText.replaceAll(name.deadname, name.chosenname);
            }
        })
        
        if (newText != node.data) {
            timesDeadnamed += 1;
        }
        node.data = newText;
    }
    if (node.nodeType == 1 && node.nodeName != "SCRIPT") {
        for (var i = 0; i < node.childNodes.length; i++) {
            walkText(node.childNodes[i], names);
        }
    }
}

function replaceDeadname() {
    chrome.runtime.sendMessage("names", function (response) {
        
        walkText(document.body, response);
    });
}

replaceDeadname();

var observeDOM = (function() {
  var MutationObserver = window.MutationObserver || window.WebKitMutationObserver;

  return function( obj, callback ){
    if( !obj || obj.nodeType !== 1 ) return;

    if( MutationObserver ){
      // define a new observer
      var mutationObserver = new MutationObserver(callback)

      // have the observer observe foo for changes in children
      mutationObserver.observe( obj, { childList:true, subtree:true })
      return mutationObserver
    }
    
    // browser support fallback
    else if( window.addEventListener ){
      obj.addEventListener('DOMNodeInserted', callback, false)
      obj.addEventListener('DOMNodeRemoved', callback, false)
      obj.addEventListener('DOMAttrModified', callback, false)
        
    }
  }
})()

observeDOM(document.getElementsByTagName("html")[0], function(m){
    
    replaceDeadname();
});

