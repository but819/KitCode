var noop = function(){};
var login = {
    login:function(content,length,scbf,ecbf){
        length = length || 3000;
        cordova.exec(scbf || noop,ecbf || noop,"LoginPlugin","login",[content,length]);
    },
    finish:function(content,length,scbf,ecbf){
        length = length || 3000;
        cordova.exec(scbf || noop,ecbf || noop,"LoginPlugin","finish",[content,length]);
    }
}
module.exports = login;
