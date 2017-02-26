"use strict";

$(() => {
  const SCROLL_OFFSET = 200;
  let $currentSentence = $(".sentence.active");

  function nextSentence() {
    let $nextSentence = $currentSentence.next(".sentence");

    if ($nextSentence.length <= 0) {
      $nextSentence = $(".sentence").first();
    }

    switchSentence($nextSentence);
  }

  function previousSentence() {
    let $previousSentence = $currentSentence.prev(".sentence");

    if ($previousSentence.length <= 0) {
      $previousSentence = $(".sentence").last();
    }

    switchSentence($previousSentence);
  }

  function switchSentence($sentence) {
    let $window = $(window);
    let scrollTop = $window.scrollTop;
    let scrolled = scrollTop + $window.height();

    $(".intro").addClass("disabled");
    $currentSentence.removeClass("active");
    $sentence.addClass("active");

    $(".sentence audio").each((_i, audioElement) => {
      if (!audioElement.paused) {
        audioElement.pause();
      }
    });

    if ($sentence.offset().top > (scrolled - SCROLL_OFFSET) ||
       ($sentence.offset().top + $sentence.outerHeight) < scrollTop) {
      $("html, body").animate({ scrollTop: $sentence.offset().top - 200 }, 200);
    }

    $currentSentence = $sentence;
    play();
  }

  function reveal() {
    if ($currentSentence.length > 0) {
      let $toReveal = $(".masked", $currentSentence).first();

      $toReveal.removeClass("masked");
    }
  }

  function play() {
    let $player = $("audio", $currentSentence);

    if ($player.length > 0) {
      player = $player.get(0);

      if (player.paused) {
        player.currentTime = 0.0;
        player.play();
      } else {
        player.pause();
      }
    }
  }

  $(document).keydown((event) => {
    console.log(event.which);
    switch(event.which) {
      case 40: // down
        nextSentence();
        break;
      case 38: // up
        previousSentence();
        break;
    }
  })

  $(document).keypress((event) => {
    switch(event.which) {
      case 32: // spacebar
        nextSentence();
        break;
      case 114: // R
        reveal();
        break;
      case 112:
        play(); // P
        break;

      default: return;
    }

    event.preventDefault();
  });

  $(".sentence[data-processed=false]").each((_i, sentence) => {
    let $sentence = $(sentence);
    let sentenceID = $sentence.data("sentence-id");

    App.cable.subscriptions.create({ channel: "SentenceStatusChannel", id: sentenceID }, {
      received: (data) => {
        if (data.slow_filename) {
          $sentence.attr("data-processed", true);
          $("audio", $sentence).attr("src", data.slow_filename);
          $(".processing", $sentence).remove();
        }
      }
    });
  });
});
