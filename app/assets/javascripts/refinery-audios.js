/**
 * Created by demon on 21.02.14.
 */


//= require audiojs.js
//= require audio_load.js

// check support HTML5 tag Audio
var a = document.createElement('audio');
if (a.canPlayType && a.canPlayType('audio/mpeg;')){

    $(document).ready(function(){
        wrapAllAudio();
        wymEditoLoadAudioFalse();
    })
} else {
    // Bad IE, very very bad IE
    if (audiojs != undefined) {
        audiojs.events.ready(function() {
            var as = audiojs.createAll();
        });
    }
}
