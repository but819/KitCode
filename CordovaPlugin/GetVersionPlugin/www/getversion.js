var noop = function(){};
var getversion = {
    get:function(successCbf,errorCbf){
        cordova.exec(successCbf || noop, errorCbf || noop,"GetVersionPlugin","get",[]);
    }
}
module.exports = getversion;
