/**
 * Created by demon on 21.02.14.
 */


//= require audiojs.js

// check support HTML5 tag Audio
if (document.createElement('audio').play != undefined){

//    var array_audios = [];
    $(document).ready(function(){
        function getPlayer(htmlObject){
            return array_audios[$(htmlObject).parents("div.audiojs").attr('audio_id')];
        }

        $('audio').wrapAll(function(){
            var new_control_html = '\
                          <div class="play-pause"> \
                            <p class="play"></p> \
                            <p class="pause"></p> \
                            <p class="loading"></p> \
                            <p class="error"></p> \
                          </div> \
                          <div class="scrubber"> \
                            <div class="progress"></div> \
                            <div class="loaded"></div> \
                          </div> \
                          <div class="time"> \
                            <em class="played">00:00</em>/<strong class="duration">00:00</strong> \
                          </div> \
                          <div class="error-message"></div>';
            return  '<div class="audiojs" classname="audiojs" audio_id ='+ this.id +' id=div'+this.id+'>' + new_control_html+'</div>'
        })  ;

        $('audio').bind('durationchange', function(){
            var jquery_div_obj = $(this).parents('.audiojs');
            m = Math.floor(this.duration / 60),
                s = Math.floor(this.duration % 60);
            jquery_div_obj.find('.time .duration').text((m<10?'0':'')+m+':'+(s<10?'0':'')+s);
        }).bind('timeupdate', function(){
            var jquery_div_obj = $(this).parents('.audiojs');
            var player = jquery_div_obj.find('audio')[0];
            var percent = player.currentTime / player.duration;
            p = player.duration * percent,
                m = Math.floor(p / 60),
                s = Math.floor(p % 60);
            jquery_div_obj.find('.time .played').text((m<10?'0':'')+m+':'+(s<10?'0':'')+s);
            var scrubber = jquery_div_obj.find('.scrubber')[0];
            var progress = jquery_div_obj.find('.scrubber .progress')[0];
            progress.style.width = scrubber.offsetWidth*percent + 'px';
        })

        $('.play').click(function(){
            var jquery_div_obj = $(this).parents("div.audiojs");
            jquery_div_obj.find('audio')[0].play();
            $(this).hide();
            jquery_div_obj.find('.pause').show();
        });

        $('.pause').click(function(){
            var jquery_div_obj = $(this).parents("div.audiojs");
            jquery_div_obj.find('audio')[0].pause();
            $(this).hide();
            jquery_div_obj.find('.play').show();
        }) ;
    })
} else {
    // Bad IE, very very bad IE

    if (audiojs != undefined) {
        audiojs.events.ready(function() {
            var as = audiojs.createAll();
        });
    }
}

