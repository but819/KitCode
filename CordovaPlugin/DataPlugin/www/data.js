var noop = function(){};
var data = {
    save:function(key,val,scbf,ecbf){
        length = length || 3000;
        cordova.exec((scbf || noop), (ecbf || noop),"DataPlugin","save",[key,val]);
    },
    get:function(key,scbf,ecbf){
        length = length || 3000;
        cordova.exec((scbf || noop), (ecbf || noop),"DataPlugin","get",[key]);
    }
}
module.exports = data;
