var toast = {
    ShowToast:function(content,length){
        cordova.exec(null, null,"ToastPlugin","toast",[content,length]);
    }
}
module.exports = toast;
