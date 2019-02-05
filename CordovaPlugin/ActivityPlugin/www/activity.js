var activity = {
    open:function(url,flag,title,state,style){
        length = length || 3000;
        style = style || 0;
        state = state || 0;
        cordova.exec(null, null,"ActivityPlugin","open",[url,flag,title,state,style]);
    }
}
module.exports = activity;