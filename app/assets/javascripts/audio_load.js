/**
 * Created by demon on 24.02.14.
 */

function leftPos(elem) {
    var curleft = 0;
    if (elem.offsetParent) {
        do { curleft += elem.offsetLeft; } while (elem = elem.offsetParent);
    }
    return curleft;
};


function wrapAllAudio() {
    $('audio').wrapAll(function(){
        var new_control_html = '\
                          <div class="play-pause"> \
                            <p class="play"></p> \
                            <p class="pause"></p> \
                            <p class="loading"></p> \
                            <p class="error"></p> \
                          </div> \
                          <span class="scrubber"> \
                            <div class="progress"></div> \
                            <div class="loaded"></div> \
                          </span> \
                          <div class="time"> \
                            <em class="played">00:00</em>/<strong class="duration">00:00</strong> \
                          </div> \
                          <div class="error-message"></div>';
        var style_width  = this.getAttribute('width') ? ' style=width:'+this.getAttribute('width') : ''
        return  '<div class="audiojs" classname="audiojs" audio_id ='+ this.id +' id=div'+this.id+style_width+'>' + new_control_html+'</div>'
    })  ;

    $('audio').bind('error', function(){
        var jquery_div_obj = $(this).parents('.audiojs');
        jquery_div_obj.find('.play-pause p').hide();
        jquery_div_obj.find('.loading').show();
    }).bind('progress', function(){
        var jquery_div_obj = $(this).parents('.audiojs');
        var player = jquery_div_obj.find('audio')[0];
        if(player.duration && player.buffered.end(0)) {
            load_progress = (player.buffered.end(0) / player.duration) * 100 ;

            var loaded = jquery_div_obj.find('.scrubber .loaded')[0];
            loaded.style.width = load_progress + '%';
        }
    }).bind('durationchange', function(){
        var jquery_div_obj = $(this).parents('.audiojs');
        m = Math.floor(this.duration / 60),
            s = Math.floor(this.duration % 60);
        jquery_div_obj.find('.duration').text((m<10?'0':'')+m+':'+(s<10?'0':'')+s);
        jquery_div_obj.find('.play-pause p').hide();
        jquery_div_obj.find('.play').show();
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
    }).bind('pause', function(){
        var jquery_div_obj = $(this).parents('.audiojs');
        jquery_div_obj.find('.play-pause p').hide();
        jquery_div_obj.find('.play').show();
    }).bind('play', function(){
        var jquery_div_obj = $(this).parents('.audiojs');
        jquery_div_obj.find('.play-pause p').hide();
        jquery_div_obj.find('.pause').show();
    })

    $('.play').click(function(){
        var jquery_div_obj = $(this).parents("div.audiojs");
        var audio_obj = jquery_div_obj.find('audio')[0];
        $.each($('audio'), function(i, a_obj){
            if (a_obj.id != audio_obj.id) a_obj.pause();
        });
        audio_obj.play();
    });

    $('.pause').click(function(){
        var jquery_div_obj = $(this).parents("div.audiojs");
        jquery_div_obj.find('audio')[0].pause();
    }) ;

    $('.scrubber').click(function(e){
        var jquery_div_obj = $(this).parents("div.audiojs");
        var player = jquery_div_obj.find('audio')[0];
        player.currentTime = player.duration * ((e.clientX - leftPos(this))/this.offsetWidth);
    })

    $.each($('audio'), function(i, obj){
        if(obj.preload == 'none') {obj.load();obj.preload='auto'; };
    })

}


if ( (window!=window.top) && ($('.audio-js').length > 0) ) {
    parent.$('.ui-dialog').find('button[title=close]').bind('click', function(){
        parent.$('iframe.ui-dialog-content').remove();
    })
}


function wymEditoLoadAudioFalse(){
    $(document).ready(function(){
        if(window.frames['WYMeditor_0']) {
            $(window.frames['WYMeditor_0'].document).ready(function(){
                $.each(window.frames['WYMeditor_0'].document.getElementsByTagName('audio'), function(i, obj){
                    obj.preload = 'none';
                })
            })
        }
    })
}