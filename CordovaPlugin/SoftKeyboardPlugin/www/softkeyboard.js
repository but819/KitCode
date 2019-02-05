var noop = function(){};
var softKeyboard = {
    show:function(successCbf,errorCbf){
        return cordova.exec(successCbf || noop, errorCbf || noop,"SoftKeyboard","show",[]);
    },
    hide:function(successCbf,errorCbf){
    	return cordova.exec(successCbf || noop, errorCbf || noop,"SoftKeyboard","hide",[]);
    },
    isShowing:function(successCbf,errorCbf){
    	//successCbf args ->isShowing 'true',eg:isShowing = isShowing === 'true' ? true : false
    	return cordova.exec(successCbf || noop, errorCbf || noop,"SoftKeyboard","isShowing",[]);
    }
}
module.exports = softKeyboard;
