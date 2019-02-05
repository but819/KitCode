var noop = function(){};
var share = {
    share:function(title,text,imgUrl,url,screenshot,scbf,ecbf){
        // return;
        length = length || 3000;
        cordova.exec((scbf || noop), (ecbf || noop),"SharePlugin","share",[title,text,imgUrl,url,screenshot]);
    }
}
module.exports = share;
