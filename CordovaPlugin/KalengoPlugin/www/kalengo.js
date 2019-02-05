var kalengo = {
    showSetting:function(){
        length = length || 3000;
        cordova.exec(null, null,"KalengoPlugin","setting",[]);
    }
}
module.exports = kalengo;