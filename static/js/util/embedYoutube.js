/* global console */
/* global alert */
/* global confirm */
/* jshint esversion:11 */


// 2. This code loads the IFrame Player API code asynchronously.
const tag = document.createElement('script');
tag.src = "https://www.youtube.com/iframe_api";
const firstScriptTag = document.getElementsByTagName('script')[0];
firstScriptTag.parentNode.insertBefore(tag, firstScriptTag);

// 3. This function creates an <iframe> (and YouTube player)
//    after the API code downloads.
let player;

function onYouTubeIframeAPIReady() {
    "use strict";
    const videoElements = document.querySelectorAll(".media-video");
    for (const videoElement of videoElements) {
        let long_url = videoElement.getAttribute("url");
        let url = long_url.substring(long_url.indexOf("=") + 1)

        player = new YT.Player(long_url, {
            width: '720',
            videoId: url,
            playerVars: {
                'playsinline': 1
            },
            events: {
                'onStateChange': onPlayerStateChange
            }
        });
    }
}

// 5. The API calls this function when the player's state changes.
//    The function indicates that when playing a video (state=1),
//    the player should play for six seconds and then stop.
let done = false;

function onPlayerStateChange(event) {
    if (event.data === YT.PlayerState.PLAYING && !done) {
        setTimeout(stopVideo, 6000);
        done = true;
    }
}

function stopVideo() {
    player.stopVideo();
}
