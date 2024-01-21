// ==UserScript==
// @name        Devin’s script #2 - 3playmedia.com
// @namespace   Violentmonkey Scripts
// @match       https://shared.3playmedia.com/stoe/v5*
// @grant       none
// @version     2.0
// @author      Devin
// @description 19/7/2023, 23:57:19
// ==/UserScript==

// Type your JavaScript code here.

keypress_timeout = 1; //this is how long between keypresses/mouse movement before it stops counting you as working

midnight_offset = 0; //this is when a new day starts for record keeping purposesin hours. 0 is midnight, 1 is 1 AM, -1 is 11 PM, etc

previousSpeed = 1.5; //this sets the default speed you start a file at when you open it

// I like f12 as my macro key which is F12
context_sensitive_macro_keys = [123]; // [123, 192]; //these are the keycodes for backtick (`) and F12. These trigger a context sensitive macro
                                           //for a different key, go to keycode.io, hit it, and then add it to the array
spelling_shortcut = 80;  //if you want a different shortcut other than Ctrl-P for shortcut, change this as above

should_not_advance = true; //if you want the cell to not advance after adding a period, comma,
                            //or using Shift-Period to capitalize a word, set this to true

should_capitalize_hyphenated_words = false; //If set to true, capitalizing a hyphenated word will iteratively capitalize
//each word in the phrase one by one

switch_to_low_quality = false;  //For people having stuttering issues with regular quality files, this automatically
                                //switches to either low-quality video or HTML5 audio, if available

// my ideal max and min speeds
max_speed = 2.0;
min_speed = 0.5;

// z leader state
z_leader = false;
z_leader_timeout = 2000;

hasFocus = ele => (ele === document.activeElement);


//to do list
//1. fix reverse slurp 

// Read
/**
 * Minified by jsDelivr using UglifyJS v3.1.10.
 * Original file: /npm/js-cookie@2.2.0/src/js.cookie.js
 *
 * Do NOT use SRI with dynamically generated files! More information: https://www.jsdelivr.com/using-sri-with-dynamic-files
 */
! function(e) {
  var n = !1;
  if ("function" == typeof define && define.amd && (define(e), n = !0), "object" == typeof exports && (module.exports = e(), n = !0), !n) {
    var o = window.Cookies,
      t = window.Cookies = e();
    t.noConflict = function() {
      return window.Cookies = o, t
    }
  }

}(function() {
  function e() {
    for (var e = 0, n = {}; e < arguments.length; e++) {
      var o = arguments[e];
      for (var t in o) n[t] = o[t]
    }
    return n
  }

  function n(o) {
    function t(n, r, i) {
      var c;
      if ("undefined" != typeof document) {
        if (arguments.length > 1) {
          if ("number" == typeof(i = e({
              path: "/"
            }, t.defaults, i)).expires) {
            var a = new Date;
            a.setMilliseconds(a.getMilliseconds() + 864e5 * i.expires), i.expires = a
          }
          i.expires = i.expires ? i.expires.toUTCString() : "";
          try {
            c = JSON.stringify(r), /^[\{\[]/.test(c) && (r = c)
          } catch (e) {}
          r = o.write ? o.write(r, n) : encodeURIComponent(String(r)).replace(/%(23|24|26|2B|3A|3C|3E|3D|2F|3F|40|5B|5D|5E|60|7B|7D|7C)/g, decodeURIComponent), n = (n = (n = encodeURIComponent(String(n))).replace(/%(23|24|26|2B|5E|60|7C)/g, decodeURIComponent)).replace(/[\(\)]/g, escape);
          var s = "";
          for (var f in i) i[f] && (s += "; " + f, !0 !== i[f] && (s += "=" + i[f]));
          return document.cookie = n + "=" + r + s
        }
        n || (c = {});
        for (var p = document.cookie ? document.cookie.split("; ") : [], d = /(%[0-9A-Z]{2})+/g, u = 0; u < p.length; u++) {
          var l = p[u].split("="),
            C = l.slice(1).join("=");
          this.json || '"' !== C.charAt(0) || (C = C.slice(1, -1));
          try {
            var g = l[0].replace(d, decodeURIComponent);
            if (C = o.read ? o.read(C, g) : o(C, g) || C.replace(d, decodeURIComponent), this.json) try {
              C = JSON.parse(C)
            } catch (e) {}
            if (n === g) {
              c = C;
              break
            }
            n || (c[g] = C)
          } catch (e) {}
        }
        return c
      }
    }
    return t.set = t, t.get = function(e) {
      return t.call(t, e)
    }, t.getJSON = function() {
      return t.apply({
        json: !0
      }, [].slice.call(arguments))
    }, t.defaults = {}, t.remove = function(n, o) {
      t(n, "", e(o, {
        expires: -1
      }))
    }, t.withConverter = n, t
  }
  return n(function() {})
});

scope = function() {
  return angular.element($(".user-selected")).scope() || angular.element($(".active-cell")).scope();
}

//Adds the following functunality to within a job
// Ctr + [ decreases playback speed by 0.1
// Ctr + ] increases playback speed by 0.1
// Double tapping Shift + Space will toggle between a speed of 1.0 and your previous non-1.0 speed


//Speed functions
speed = function(){
  speed_dom = $("*[ng-model='ctrl.userSetting.video_playback_rate']");
  return speed_dom;
}

finished = 0;

updateDisplay = function() {

  if ($("#speed-display").length === 0)
  {
    $(".btn-group:last").after("<div class = 'btn-group' id = 'speed-display'></div>")
    setTimeout(updateDisplay, 100);
  }

  working_time = parseInt(Cookies.get('working_time'));
  daily_hours = Math.floor(working_time / 1000 / 3600);
  daily_minutes = Math.floor((working_time - daily_hours * 1000 * 3600) / 60 / 1000);
  daily_seconds = Math.floor((working_time - daily_hours * 1000 * 3600 - daily_minutes * 1000 * 60) / 1000);
  daily_text = "Daily clocked: " + daily_hours + "h, " + daily_minutes + "m";

  file_working_hours = parseInt(getFilesData()[parseID()].working_time)/1000/3600;
  file_hours = Math.floor(file_working_hours);
  file_minutes = Math.floor(file_working_hours*60-file_hours*60);
  file_seconds = Math.floor(file_working_hours*3600 -file_minutes*60 - file_hours*3600);
  file_text = "File clocked: " + (file_hours ? file_hours + "h, " + file_minutes + "m" : file_minutes + "m, " + file_seconds + "s");
  times = $(".tp-transcript-controls div span").eq(3).text();
  current_time = times.split("/")[0].trim().split(":");
  max_time = times.split("/")[1].trim().split(":");
  current_seconds = parseFloat(current_time[0])*3600 + parseFloat(current_time[1])*60 + parseFloat(current_time[2]);
  max_seconds = parseFloat(max_time[0])*3600 + parseFloat(max_time[1])*60 + parseFloat(max_time[2]);
  percentage = finished || current_seconds/max_seconds;
  pay_rate = parsePay()/file_working_hours*percentage;
  pay_text = "Pay rate: $" + pay_rate.toLocaleString(undefined, {minimumFractionDigits: 2, maximumFractionDigits: 2});
    speed_text = "Speed: " + speed().val();
//  $("#speed-display").text(speed_text + " | " + daily_text + " | " + file_text + " | " + pay_text);
//I only want to see playback speed
    $("#speed-display").text(speed_text + "x"); // + daily_text + " | " + file_text + " | " + pay_text);
}

setTimeout(function()
{
  $(".fa-check").parent().click(function()
  {
    finished = 1.0;
  });
}, 5000);

changeSpeed = function(changeBy, updatePrev = true)
{
    speed().val(parseFloat(speed().val()) + changeBy);
    angular.element(speed()).triggerHandler("input");
    if (updatePrev)
    {
	previousSpeed = parseFloat(speed().val());
    }
    updateDisplay();
}

toggleSpeed = function() {

  currentSpeed = parseFloat(speed().val());
  if (currentSpeed != 1.0)
  {
    previousSpeed = currentSpeed;
    setSpeed(1.0, false);
  }
  else
  {
    setSpeed(previousSpeed);
  }
}

cycleSpeedForward  = function() {
var speed1 = 1.0;
var speed2 = 1.3;
var speed3 = 1.5;
var speed4 = 2.0;

currentSpeed = parseFloat(speed().val());
if (currentSpeed >= speed1 && currentSpeed < speed2) {
    setSpeed(speed2, true);
}
else if (currentSpeed >= speed2 && currentSpeed < speed3) {
    setSpeed(speed3, true);
}
else if (currentSpeed >= speed3 && currentSpeed < speed4) {
    setSpeed(speed4, true);
}
else {
    setSpeed(speed1, true);
}
}

cycleSpeedBackward  = function() {
var speed1 = 1.0;
var speed2 = 1.3;
var speed3 = 1.5;
var speed4 = 2.0;

currentSpeed = parseFloat(speed().val());
if (currentSpeed > speed1 && currentSpeed <= speed2) {
    setSpeed(speed1, true);
}
else if (currentSpeed > speed2 && currentSpeed <= speed3) {
    setSpeed(speed2, true);
}
else if (currentSpeed > speed3 && currentSpeed <= speed4) {
    setSpeed(speed3, true);
}
else {
    setSpeed(speed4, true);
}
}

setSpeed = function(newSpeed, updatePrev = true)
{
  currentSpeed = parseFloat(speed().val());
  changeSpeed(newSpeed - currentSpeed, updatePrev);
}

increaseSpeed = function() {
  currentSpeed = parseFloat(speed().val());
    if (currentSpeed >= max_speed) {
	setSpeed(min_speed, true);
    }
    else {
	setSpeed(currentSpeed + 0.1, true);
    }
}

$("body").keydown(function(e)
{
  if (e.altKey && e.which == 221) //alt + ]
  {
      increaseSpeed();
      e.stopPropagation();
      e.preventDefault();
  }
});

decreaseSpeed = function() {
    currentSpeed = parseFloat(speed().val());
    if (currentSpeed <= min_speed) {
	setSpeed(max_speed);
    }
    else {
	setSpeed(currentSpeed - 0.1);
    }
}

$("body").keydown(function(e)
{
  if (e.altKey && e.which == 219) //alt + [
  {
      decreaseSpeed();
      e.stopPropagation();
      e.preventDefault();
  }
});

// control+] cycles speed forward
$("body").keydown(function(e){
    if (e.ctrlKey && e.which == 221) { //ctrl + ]
	cycleSpeedForward();
    }
  }
);

// control+[ cycles speed backward
$("body").keydown(function(e) {
    if (e.ctrlKey && e.which == 219) { //ctrl + [
	cycleSpeedBackward();
    }
  }
);

last_keypress = new Date().getTime();
updateTimeWorked = function()
{
  now = new Date();
  if(!scope() || now.getTime() - last_keypress < 1000)
  {
    return;
  }

  midnight = new Date(now);
  midnight.setHours(24, 0, midnight_offset*60*60, 0);

  if(midnight.getTime() - now.getTime() > 24*60*60*1000)
  {
    midnight.setDate(midnight.getDate() - 1);
  }
  else if(midnight.getTime() - now.getTime() < 0)
  {
    midnight.setDate(midnight.getDate() + 1);
  }

  if (!Cookies.get('working_time'))
  {
    Cookies.set ('working_time', 0, {expires: midnight});
  }

  last_keypress = parseInt(Cookies.get('last_keypress') || now.getTime());

  Cookies.set('last_keypress', (new Date()).getTime(), {
    expires: new Date(now.getTime() + keypress_timeout*1000*60)
  });
  elapsed_time = now.getTime() - last_keypress;

  working_time = parseInt(Cookies.get('working_time'));
  Cookies.set('working_time', working_time + elapsed_time, {expires: midnight});
  updateFileWorkingTime(elapsed_time);
  updateDisplay();
}

updateFileWorkingTime = function(ellapsed_time)
{
  files_data = getFilesData();
  files_data[parseID()].working_time += ellapsed_time;
  localStorage.setItem("files_data",  JSON.stringify(files_data));
}

setMacro = function(word, isSpeaker, index) {
  macroWords = $("[ng-model='macroData.words']");
  macroSpeakers = $("[ng-click='ctrl.toggleMacroSpeakerLabel(macroData.id)']");
  macroWords[index].value = word;
  macroWords[index].dispatchEvent(new Event('input', {bubbles: true}));
  speakerChecked = macroSpeakers[index].value == "true";
  if (speakerChecked != isSpeaker) {
    $(macroSpeakers[index]).click();
  }
}

numberTriggered = function()
{
  single_digit_numbers = {"0":"zero", "1":"one", "2": "two", "3": "three", "4":"four", "5":"five", "6":"six", "7":"seven", "8":"eight", "9":"nine",
  "zero":"0", "one":"1", "two":"2", "three":"3", "four":"4", "five":"5", "six":"6", "seven":"7", "eight":"8", "nine":"9"};
  word = scope().cell.words.trim();

  //Flips between words/digits for single digit numbers
  if(single_digit_numbers[word.toLowerCase()])
  {
    scope().cell.setWords(single_digit_numbers[word.toLowerCase()]);
    scope().$apply();
    return;
  }

  unit_abbreviations = {"in" : "inches", "ft":"feet", "mph":"miles per hour", "f":"Fahrenheit", "c":"Celsius", "m":"meters",
  "k": "kilometers", "km" : "kilometers", "g":"grams", "l":"liters", "lbs": "pounds", "lb":"pounds", "s":"seconds", "oz":"ounces",
  "mm":"millimeters"
  };
  for(u in unit_abbreviations)
  {
    unabbreviated_word = word.toLowerCase().replace(u, "");
    //treat as decades before seconds
    if(!isNaN(unabbreviated_word) && unabbreviated_word % 10 == 0 && unabbreviated_word < 100)
    {
      break;
    }
    //convert decades to seconds next
    if(unabbreviated_word[0] == "'" && u == "s")
    {
      unabbreviated_word = unabbreviated_word.substr(1);
    }
    if(word.length > u.length && word.toLowerCase().indexOf(u) == word.length - u.length && !isNaN(unabbreviated_word))
    {
      scope().cell.setWords(unabbreviated_word + " " + unit_abbreviations[u]);
      scope().$apply();
      return;
    }
  }

  //Removes leading apostrophe from numbers
  if(word[0] == "'" && !isNaN(word.substr(1, 2)))
  {
    scope().cell.setWords(word.substr(1));
    scope().$apply();
    return;
  }

  //Adds comma to years/decades
  if(!isNaN(word.substr(0, 2)) && (word.length == 2 || (word.length == 3 && word[2] == "s")))
  {
    scope().cell.setWords("'" + word);
    scope().$apply();
    return;
  }

  //Removes leading ?
  if(word[0] == "?")
  {
    scope().cell.setWords(word.substr(1));
    scope().$apply();
    return;
  }

  //Inserts/removes commas into four digit numbers
  if(!isNaN(word))
  {
    decimal = word.split(".");
    wholenumber = parseInt(decimal[0]).toLocaleString("en-us");
    decimal = decimal[1] ? "." + decimal[1] : "";
    scope().cell.setWords(wholenumber + decimal);
    scope().$apply();
    return;
  }
  if(!isNaN(word.split(",").join("")))
  {
    scope().cell.setWords(word.split(",").join(""));
    scope().$apply();
    return;
  }
}

macroTriggered = function(e)
{
  index = e.which > 57 ? e.which - 97 : e.which - 49;

  var word;
    if (index == (0 || -1))
  {
    index = 9;
  }

  words = JSON.parse(localStorage.getItem("words") || "{}");
  word = scope().cell.words;
  if (word.split("|").length == 2)
  {
    key = word.split("|")[0].toLowerCase();
    value = word.split("|")[1];
    words[key] = value;
    try
    {
      localStorage.setItem("words", JSON.stringify(words));
    }
    catch
    {
      alert("You are out of storage and cannot add any additional custom macros");
    }
    word = key;
  }

  word = words[word.toLowerCase()] || word;

  scope().cell.setWords(word);
  scope().$apply();

  if(word == "saveWords")
  {
    saveWords();
  }
  else if (word == "loadWords")
  {
    loadWords();
  }

  if (e.which >= 122)
  {
    return;
  }

  isSpeaker = word[word.length - 1] == ":";
  setMacro(word, isSpeaker, index);

  e.stopPropagation();
}

//alt+0 now sets macro to slot 0. 48 is 0.
//shift+control+0 doesn't work. alt+control+shift+0
//and combos (gotta have alt) seem to work
$("body").keydown(function(e) {
    if (e.altKey && e.which == 48) { //48 is 0
	var string = scope().cell.words;
	isSpeaker = string[string.length - 1] == ":";
	setMacro(string, isSpeaker, 9);
    }
});

$("body").keydown(function(e) {
    if (e.shiftKey && e.Control && e.which == 48) { //48 is 0
	var string = scope().cell.words;
	isSpeaker = string[string.length - 1] == ":";
	setMacro(string, isSpeaker, 9);
	e.stopPropagation();
	e.preventDefault();
    }
});
saveWords = function()
{
  words_string = "words = JSON.parse(localStorage.getItem('words')) || {};";
  words = JSON.parse(localStorage.getItem("words"));
  for (key in words)
  {
    words_string = words_string + "words[`" + key + "`] = `" + words[key] + "`; "
  }
  words_string = words_string + "localStorage.setItem('words', JSON.stringify(words));";
  navigator.clipboard.writeText(words_string);
}

loadWords = function()
{
  navigator.clipboard.readText().then(
      clipText => eval(clipText));
}

previousSpace = Date.now();
initialToggle = false;

clearSpeakerID = function() {
  if (scope().cell.speakerLabel)
  {
    scope().cell.setWords("");
    scope().$apply();
  }
}

followid = null;
$("body").attr("tabindex", -1);

//Update the timeworked and stop following the cursor with every keypress
$("body").keydown(function(e)
{
  updateTimeWorked();
  clearInterval(followid);
});

$("body").keydown(function(e) {
  if (e.ctrlKey && e.shiftKey && ((e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105)))
  {
    macroTriggered(e);
  }
});

$("body").keydown(function(e) {
  if (context_sensitive_macro_keys.indexOf(e.which) != -1)
  {
    if(scope().cell.words.length == 0)
    {
      return;
    }
    macroTriggered(e);
    numberTriggered(e);
  }
})

$("body").keydown(function(e) {
  if (e.ctrlKey && !e.shiftKey && ((e.which >= 48 && e.which <= 57) || (e.which >= 96 && e.which <= 105))) {
    clearSpeakerID();
  }
});

$("body").keydown(function(e) {
  if(e.altKey && e.which == 68)
  {
    clearSpeakerID();
  }
});

// double-tapping space with shift down toggles speed
$("body").keydown(function(e) {
    if (e.which == 32) {
	//if (Date.now() - previousSpace < 200)
	if (Date.now() - previousSpace > 50 && Date.now() - previousSpace < 200)
	    {
		toggleSpeed();
	    }
	previousSpace = Date.now(0);
    }
});

// $("body").keydown(function(e) {
//   if (!e.altKey && !e.shiftKey && e.ctrlKey && e.which == 77) {
//     if(removeHyphen())
//     {
//       e.preventDefault();
//       e.stopPropagation();
//     }
//   }
// });

$("body").keydown(function(e) {
  if (!e.altKey && e.shiftKey && e.ctrlKey && e.which == 77 && e.shiftKey) {
    formatSong(e);
      e.preventDefault();
      e.stopPropagation();
  }
});

$("body").keydown(function(e) {
  if (e.ctrlKey && e.which == 76) {
    splitHyphen();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
  if (e.ctrlKey && e.shiftKey && e.which == 38) {
    followid = setInterval(function() {
      $(".video-highlighted").click()
    }, 10);
      e.preventDefault();
      e.stopPropagation();
  }
});

// $("body").keydown(function(e) {
//     if (e.altKey && e.ctrlKey && e.shiftKey && e.which == 80) { //80 is p
//     followid = setInterval(function() {
//       $(".video-highlighted").click()
//     }, 10);
//   }
// });

$("body").keydown(function(e) {
    if (!e.altKey && e.ctrlKey && !e.shiftKey && e.which == 80) { //80 is p
    followid = setInterval(function() {
      $(".video-highlighted").click()
    }, 10);
	e.preventDefault();
	e.stopPropagation();
  }
});

// $("body").keydown(function(e) {
//     if (e.altKey && !e.ctrlKey && !e.shiftKey && e.which == 32) { //32 is space
// 	e.stopPropagation();
// 	e.preventDefault();
//     followid = setInterval(function() {
//       $(".video-highlighted").click()
//     }, 10);
//   }
// });

$("body").keydown(function(e) {
  if (!e.altKey && e.ctrlKey && !e.shiftKey && e.which == 68) {
    applyDoubleDash();
    e.stopPropagation();
    e.preventDefault();
  }
});

//Ctrl-P now spells a word instead of previewing it
$("body").keydown(function(e) {
    if (e.altKey && !e.shiftKey && !e.ctrlKey && e.which == 83) { //83 is s
    spellWord();
    e.preventDefault();
    e.stopPropagation();
  }
});

transcriptActive = function() {
  return $(".user-selected").length > 0 && $(document.activeElement).hasClass("tp-transcript");
}

$("body").keydown(function(e) {
  if (e.ctrlKey && !e.shiftKey && (e.which == 67 || e.which == 88)  && transcriptActive()) //Ctrl-C or Ctrl-X copies cell contents to clipboard
  {
    navigator.clipboard.writeText($(".user-selected").text().trim());
  }
});

$("body").keydown(function(e) {
  if (e.ctrlKey && !e.shiftKey && e.which == 86 && transcriptActive()) //Ctrl-V pastes from clipboard
  {
    navigator.clipboard.readText().then(
      clipText => pasteWord(clipText));
    e.stopPropagation();
    e.preventDefault();
  }
});

// $("body").keydown(function(e) {
//   if(should_not_advance && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 190)
//   {
//     scope().cell.setWords(scope().cell.words + ".");
//     scope().cell.editing = true;
//     scope().$apply();

//     e.stopPropagation();
//     e.preventDefault();
//   }
// });

// $("body").keydown(function(e) {
//   if(should_not_advance && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 188)
//   {
//     scope().cell.setWords(scope().cell.words + ",");
//     scope().cell.editing = true;
//     scope().$apply();

//     e.stopPropagation();
//     e.preventDefault();
//   }
// });

clearCell = function () {
    scope().cell.setWords("");
    if (scope().cell.flagged == true) {
	scope().cell.flagged = false;
    }
    scope().$apply();
}

// getPreviousPopulatedCell = function () {
//     var index_current_cell = scope().cell.timestamp;
//     var object_map = Object.keys(scope().cell.transcript.cellMap)
//     var cell_position = object_map.indexOf(index_current_cell)
//     var previous_cell = cell_position - 1
//     var full_map = scope().cell.transcript.cellMap
//     while (full_map[object_map.at(previous_cell)].isEmpty() == true){
// 	previous_cell = previous_cell - 1
//     }
//     var ppc = full_map[object_map.at(previous_cell)].timestamp
//     var address = "span[timestamp=" + ppc + "]"
//     return angular.element($(address))
// }

indexOfTimestamp = function (x) {
    var object_map = Object.keys(scope().cell.transcript.cellMap)
    //var full_map = scope().cell.transcript.cellMap;
    //return object_map.indexOf('"' + x + '"');
    return object_map.indexOf(x);
};

timestampOfIndex = function (x) {
    var object_map = Object.keys(scope().cell.transcript.cellMap);
    return object_map[x];
};

indexOfCurrentCell = function () {
    var current_ts = scope().cell.timestamp;
    return indexOfTimestamp(current_ts);
};

cellAtIndex = function (x) {
    return scope().cell.transcript.cellMap[timestampOfIndex(x)];
};

clickOnIndex = function (x) {
    var ts = timestampOfIndex(x);
    var selector = "span[timestamp=" + ts + "]";
    //angular.element($("span[timestamp=1819140]")).click()
    // a = 1
    // if (angular.element($("span[timestamp=1816950]"))) {
    // a++;
    // }  
    // else {
    // a = 0;
    // };
    //$("[ng-click='selectPage(page.number, $event)']")[0].click()
    //$("[ng-click='selectPage(page.number, $event)']").length
    //class="pagination-page ng-scope active"
    //document.getElementsByClassName("active")[2].innerText 
    angular.element($(selector)).click();
};

getWordsAtIndex = function (x) {
    var ts = timestampOfIndex(x);
    full_map = scope().cell.transcript.cellMap;
    return full_map[ts].words;
};

isIndexFlagged = function (x) {
    var ts = timestampOfIndex(x);
    full_map = scope().cell.transcript.cellMap;
    return full_map[ts].flagged;
};

getArrayAtIndex = function (x) {
    var ts = timestampOfIndex(x);
    full_map = scope().cell.transcript.cellMap;
    return full_map[ts].words.split(/\s+/);
};

setWordsAtIndex = function (x, y) {
    var ts = timestampOfIndex(x);
    full_map = scope().cell.transcript.cellMap;
    full_map[ts].words = y;
    full_map[ts].dirty = true;
    scope().$apply();
};

clearIndex = function (x) {
    var ts = timestampOfIndex(x);
    full_map = scope().cell.transcript.cellMap;
    full_map[ts].words = "";
    if (full_map[ts].flagged == true) {
	full_map[ts].flagged = false;
    };
    full_map[ts].dirty = true;
    scope().$apply();
};

makeIndexDirty = function (x) {
    var ts = timestampOfIndex(x);
    full_map = scope().cell.transcript.cellMap;
    full_map[ts].dirty = true;
    scope().$apply();
};

lastIndex = function () {
    return Object.keys(scope().cell.transcript.cellMap).length - 1;
};

lengthOfCellMap = function () {
    return Object.keys(scope().cell.transcript.cellMap).length;
};

getPreviousPopulatedIndex = function () {
    var ppi = indexOfCurrentCell() - 1;
    if (ppi == -1) {
	ppi = lastIndex();
    }
    while (cellAtIndex(ppi).isEmpty() == true) {
	ppi--;
	if (ppi == -1) {
	    ppi = lastIndex();
	}
    }
    return ppi;
 }

gotoPreviousPopulatedCell = function () {
    clickOnIndex(getPreviousPopulatedIndex());
}

getNextPopulatedIndex = function () {
    var npi = indexOfCurrentCell() + 1;
    if (npi > lastIndex()) {
	npi = 0;
    }
    while (cellAtIndex(npi).isEmpty() == true) {
	npi++;
	if (npi > lastIndex()) {
	    npi = 0;
	}
    }
    return npi;
}

gotoNextPopulatedCell = function () {
    clickOnIndex(getNextPopulatedIndex());
}

mergeNextPopulatedIndex = function () {
    var a = getWordsAtIndex(indexOfCurrentCell());
    var b = getWordsAtIndex(getNextPopulatedIndex());
    setWordsAtIndex(indexOfCurrentCell(), (a + b));
    if (isIndexFlagged(getNextPopulatedIndex()) == true) {
	scope().cell.flagged = true;
    };
    clearIndex(getNextPopulatedIndex());
    scope().$apply();
};

mergeNextPopulatedIndexWithSpace = function () {
    var a = getWordsAtIndex(indexOfCurrentCell());
    var b = getWordsAtIndex(getNextPopulatedIndex());
    setWordsAtIndex(indexOfCurrentCell(), (a + " " + b));
    if (isIndexFlagged(getNextPopulatedIndex()) == true) {
	scope().cell.flagged = true;
    };
    clearIndex(getNextPopulatedIndex());
    scope().$apply();
};

slurpNextPopulatedIndexWithSpace = function () {
    var a = getWordsAtIndex(indexOfCurrentCell());
    var b = getArrayAtIndex(getNextPopulatedIndex());
    setWordsAtIndex(indexOfCurrentCell(), (a + " " + b.shift()));
    setWordsAtIndex(getNextPopulatedIndex(), (b.join(" ")));
    if (isIndexFlagged(getNextPopulatedIndex()) == true) {
	scope().cell.flagged = true;
    };
    scope().$apply();
};

mergePreviousPopulatedIndex = function () {
    var a = getWordsAtIndex(getPreviousPopulatedIndex());
    var b = getWordsAtIndex(indexOfCurrentCell());
    setWordsAtIndex(indexOfCurrentCell(), (a + b));
    if (isIndexFlagged(getPreviousPopulatedIndex()) == true) {
	scope().cell.flagged = true;
    };
    clearIndex(getPreviousPopulatedIndex());
    scope().$apply();
};

mergePreviousPopulatedIndexWithSpace = function () {
    var a = getWordsAtIndex(getPreviousPopulatedIndex());
    var b = getWordsAtIndex(indexOfCurrentCell());
    setWordsAtIndex(indexOfCurrentCell(), (a + " " + b));
    if (isIndexFlagged(getPreviousPopulatedIndex()) == true) {
	scope().cell.flagged = true;
    };
    clearIndex(getPreviousPopulatedIndex());
    scope().$apply();
};

slurpPreviousPopulatedIndexWithSpace = function () {
    var a = getArrayAtIndex(getPreviousPopulatedIndex());
    var b = getWordsAtIndex(indexOfCurrentCell());
    setWordsAtIndex(indexOfCurrentCell(), (a.pop() + " " + b));
    setWordsAtIndex(getPreviousPopulatedIndex(), (a.join(" ")));
    if (isIndexFlagged(getPreviousPopulatedIndex()) == true) {
	scope().cell.flagged = true;
    };
    scope().$apply();
};

// shift+left arrow key goes to previous populated cell
$("body").keydown(function(e) {
    if(!e.ctrlKey && e.shiftKey && !e.altKey && e.which == 37) // left arrow key is 37
  {
      gotoPreviousPopulatedCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

//Ctrl-J joins the previous cell to the current one
$("body").keydown(function(e)
{
  if (!e.shiftKey && e.ctrlKey && !e.altKey && e.which == 74) //ctrl + j
    {
	mergePreviousPopulatedIndex();
	e.stopPropagation();
	e.preventDefault();
  }
});

$("body").keydown(function(e)
{
  if (!e.shiftKey && !e.ctrlKey && e.altKey && e.which == 74) //alt + j
    {
	mergePreviousPopulatedIndexWithSpace();
	e.stopPropagation();
	e.preventDefault();
  }
});

$("body").keydown(function(e)
{
  if (e.shiftKey && !e.ctrlKey && e.altKey && e.which == 74) //alt + j
    {
	slurpPreviousPopulatedIndexWithSpace();
	e.stopPropagation();
	e.preventDefault();
  }
});

throwIndexForward = function () {
    var arr = getArrayAtIndex(indexOfCurrentCell());
    //var b = getWordsAtIndex(getPreviousPopulatedIndex());
    while (arr.length > 0) {
	if (indexOfCurrentCell() + arr.length > lengthOfCellMap()) {
	    setWordsAtIndex((arr.length - 2), arr.pop());
	} else {
	    setWordsAtIndex((indexOfCurrentCell() + arr.length - 1), arr.pop());
	}
    }
};

throwIndexBackward = function () {
    var arr = getArrayAtIndex(indexOfCurrentCell());
    //var b = getWordsAtIndex(getPreviousPopulatedIndex());
    while (arr.length > 0) {
	if (indexOfCurrentCell() - arr.length < -1) {
	    setWordsAtIndex((lengthOfCellMap() - arr.length+ 1 ), arr.shift());
	} else {
	    setWordsAtIndex((indexOfCurrentCell() - arr.length + 1), arr.shift());
	}
    }
};

$("body").keydown(function(e) {
    if(!e.ctrlKey && !e.shiftKey && e.altKey && e.which == 84) //t key is 84
	{
	    throwIndexForward();
	    e.stopPropagation();
	    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    if(!e.ctrlKey && e.shiftKey && e.altKey && e.which == 84) //t key is 84
	{
	    throwIndexBackward();
	    e.stopPropagation();
	    e.preventDefault();
  }
});

// shift+right arrow key goes to next populated cell
$("body").keydown(function(e) {
    if(!e.ctrlKey && e.shiftKey && !e.altKey && e.which == 39) // right arrow key is 39
  {
      gotoNextPopulatedCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

deleteAndAdvance = function () {
    clearIndex(indexOfCurrentCell());
    gotoNextPopulatedCell();
};

//delete deletes cell contents and moves forward
$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if (hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 46) // 46 is delete
    {
	deleteAndAdvance();
	e.stopPropagation();
	e.preventDefault();
    }
});

//Ctrl-m merges the next populated cell to the current one
$("body").keydown(function(e)
{
  if (!e.altKey && !e.shiftKey && e.ctrlKey && e.which == 77) //ctrl + m
    {
	mergeNextPopulatedIndex();
	e.stopPropagation();
	e.preventDefault();
  }
});

$("body").keydown(function(e)
{
  if (e.altKey && !e.shiftKey && !e.ctrlKey && e.which == 77) //alt + m
    {
	mergeNextPopulatedIndexWithSpace();
	e.stopPropagation();
	e.preventDefault();
  }
});

$("body").keydown(function(e)
{
  if (e.shiftKey && !e.ctrlKey && e.altKey && e.which == 77) //alt + m
    {
	slurpNextPopulatedIndexWithSpace();
	e.stopPropagation();
	e.preventDefault();
  }
});

$("body").keydown(function(e) {
  if(e.ctrlKey && e.altKey && !e.shiftKey && e.which == 70) //70 is f
      {
	  gotoNextPopulatedCell();
	  e.stopPropagation();
	  e.preventDefault();
      }
});

//meta copy to append cell contents to current clipboard
metaCopy = function () {
    navigator.clipboard.readText()
	.then((a) => {
	    var b = scope().cell.words
	    var c = a + " " + b
	    navigator.clipboard.writeText(c);
	    gotoNextPopulatedCell();
	})};

$("body").keydown(function(e) {
  if(e.ctrlKey && e.altKey && !e.shiftKey && e.which == 67) //67 is c
  {
      metaCopy();
      e.stopPropagation();
      e.preventDefault();
  }
});

clearClipboard = function () {
    navigator.clipboard.writeText("");
};

languageCheck = function () {
    var lang = scope().cell.transcript.job.language;
    navigator.clipboard.writeText(lang);
};

$("body").keydown(function(e) {
  if(e.ctrlKey && e.altKey && e.shiftKey && e.which == 73) //73 is i
  {
      languageCheck();
      e.stopPropagation();
      e.preventDefault();
  }
});

lookupCell = function () {
var lang = scope().cell.transcript.job.language;
var cell_contents = scope().cell.words;
switch(lang) {
case "spanish":
    //window.open("https://www.asale.org/damer/" + cell_contents);
    //window.open("https://es.wikipedia.org/wiki/" + cell_contents);
    //window.open("https://es.wiktionary.org/wiki/" + cell_contents);
    window.open("https://dle.rae.es/" + cell_contents + "?m=form");
    break;
case "english":
    // window.open("https://en.wikipedia.org/wiki/" + cell_contents);
    //window.open("https://en.wiktionary.org/wiki/" + cell_contents);
    window.open("https://www.merriam-webster.com/dictionary/" + cell_contents);
    break;
default:
        window.open("https://www.google.com/search?q=" + cell_contents + "++site%3Awiktionary.org");
}
};

$("body").keydown(function(e) {
  if(e.ctrlKey && !e.altKey && !e.shiftKey && e.which == 89) //89 is y
  {
      lookupCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

wikiCell = function () {
var lang = scope().cell.transcript.job.language;
var cell_contents = scope().cell.words;
switch(lang) {
case "spanish":
    window.open("https://es.wikipedia.org/wiki/" + cell_contents);
    break;
case "english":
    window.open("https://en.wikipedia.org/wiki/" + cell_contents);
    break;
default:
        window.open("https://www.google.com/search?q=" + cell_contents + "++site%3Awikpedia.org");
}
};

$("body").keydown(function(e) {
  if(!e.ctrlKey && e.altKey && !e.shiftKey && e.which == 75) //75 is k
  {
      wikiCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

googleCell = function () {
    var cell_contents = scope().cell.words;
    window.open("https://www.google.com/search?q=" + cell_contents);
};

$("body").keydown(function(e) {
  if(e.ctrlKey && !e.altKey && !e.shiftKey && e.which == 71) //71 is g
  {
      googleCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

ddgCell = function () {
    var cell_contents = scope().cell.words;
    window.open("https://duckduckgo.com/?q=" + cell_contents);
};

$("body").keydown(function(e) {
  if(!e.ctrlKey && e.altKey && !e.shiftKey && e.which == 71) //71 is g
  {
      ddgCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

$("body").keydown(function(e) {
  if(e.ctrlKey && e.altKey && !e.shiftKey && e.which == 71) //71 is g
  {
      ddgCell();
      googleCell();
      e.stopPropagation();
      e.preventDefault();
  }
});


// $("body").keydown(function(e) {
//   if(e.ctrlKey && e.altKey && !e.shiftKey && e.which == 96) //96 is 0
//   {
//       clearClipboard();
//       e.stopPropagation();
//       e.preventDefault();
//   }
// });

$("body").keydown(function(e) {
  if(e.ctrlKey && e.altKey && !e.shiftKey && e.which == 88) //88 is x
  {
      clearClipboard();
      e.stopPropagation();
      e.preventDefault();
  }
});

$("body").keydown(function(e) {
  if(!e.ctrlKey && e.altKey && !e.shiftKey && e.which == 8) //9 is backspace in firefox (could be 9 in other browsers)
  {
      clearCell();
      e.stopPropagation();
      e.preventDefault();
  }
});

$("body").keydown(function(e){
  if(should_capitalize_hyphenated_words && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 190)
  {
    capitalize_hyphenated_words(e);
  }
});

$("body").keydown(function(e) {
  if(should_not_advance && !e.ctrlKey && e.shiftKey && e.which == 190)
  {
    words = scope().cell.words;
    first_letter = words[0] == words.toLowerCase()[0] ? words.substr(0, 1).toUpperCase() : words.substr(0, 1).toLowerCase();
    console.log(first_letter);
    scope().cell.setWords(first_letter + words.substr(1, words.length-1));
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

// $("body").keydown(function(e) {
//   if(!e.ctrlKey && !e.altKey && !e.shiftKey && e.which == 220)
//   {
//     scope().cell.setWords(scope().cell.words + "backslash"); //220 is \ and |
//     scope().cell.editing = true;
//     scope().$apply();

//     e.stopPropagation();
//     e.preventDefault();
//   }
// });

//meta paste to bypass having to enter text
metaPaste = function () {
    navigator.clipboard.readText()
	.then((string) => {
	    string = string.replace(/^\s+|\s+$|\s+(?=\s)/g, "");
	    navigator.clipboard.writeText(string);
	    scope().cell.setWords(string);
	    scope().$apply();
	})};

$("body").keydown(function(e) {
  if(e.ctrlKey && !e.altKey && e.shiftKey && e.which == 86) // 86 is v
    {
      metaPaste();
      e.stopPropagation();
      e.preventDefault();
  }
});

appendPaste = function () {
    navigator.clipboard.readText()
	.then((string) => {
	    var a = scope().cell.words
	    scope().cell.setWords(a + string);
	    scope().$apply(); 
	})};

$("body").keydown(function(e) {
    if(!e.ctrlKey && e.altKey && !e.shiftKey && e.which == 86) // 86 is v; 97 is a
    {
      appendPaste();
      e.stopPropagation();
      e.preventDefault();
  }
});

controlsHidden = false;
$("body").keydown(function(e)
{
  if(e.ctrlKey && e.shiftKey && e.which == 72)
  {
    if (controlsHidden)
    {
      $(".controls-container").show();
      controlsHidden = false;
    }
    else
    {
      $(".controls-container").hide();
      controlsHidden = true;
    }
  }
});

characterSet = characterSet = [32,97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122,49,50,51,52,53,54,55,56,57,48,45,34,47,39,44,46,45,58,91,93,35,33,64,40,41,36,37,38,225,233,237,243,250,252,241,209];
/* Have to convert the characterSet to charCodes for encoding reasons(?) using the following

  characters = " abcdefghijklmnopqrstuvwxyz1234567890-\"/',.-:[]#!@()$%&áéíóúñ"; //ÁÜ
  characterSet = [];
  for (character of characters)
  {
    characterSet.push(character.charCodeAt(0));
  }
  console.log("characterSet = " + JSON.stringify(characterSet));
*/

capitalize_hyphenated_words = function(e){
  words = scope().cell.words;
  hyphenated_words = words.split("-");
  if (hyphenated_words.length < 2 || (words.startsWith("--") && words.slice(2).indexOf("-") == -1))
  {
    return;
  }
  for (i in hyphenated_words)
  {
    if (hyphenated_words[i].toUpperCase()[0] != hyphenated_words[i][0] && hyphenated_words[i].length > 0)
    {
      hyphenated_words[i] = hyphenated_words[i][0].toUpperCase() + hyphenated_words[i].slice(1);
      scope().cell.setWords(hyphenated_words.join("-"));
      scope().$apply();
      e.stopPropagation();
      e.preventDefault();
      return;
    }
  }
  newWords = words.toUpperCase()[0] + words.toLowerCase().slice(1);
  if(words.startsWith("--"))
  {
    newWords = "--" + words.toUpperCase()[2] + words.toLowerCase().slice(3);
  }
  scope().cell.setWords(newWords);
}

pasteWord = function(word) {
  for (char of word.toLowerCase()) {
    if (characterSet.indexOf(char.charCodeAt(0)) == -1) {
      return;
    }
  }
  scope().cell.setWords(word);
  scope().$apply();
};

// lastGoogleTap = null;
// $("body").keydown(function(e) { //Automatically copies the current cell contents into the Google search box and opens a search
//   if (e.ctrlKey && e.which == 71)
//   {
//     if (Date.now() - lastGoogleTap < 2000)
//     {
//       $("#google").val($(".user-selected").text().trim());
//       $("#google").parent().submit();
//     }
//     lastGoogleTap = Date.now();
//     e.preventDefault();
//   }
// });

removeHyphen = function() {
  words = scope().cell.words;
  if (words.replace("-", "") != words && words[words.length - 1] != "-") {
    scope().cell.setWords(words.replace("-", ""));
    scope().$apply();
    return true;
  }
  return false;
}

splitHyphen = function() {
  if (scope().cell.words.replace("-", "") != scope().cell.words) {
    scope().cell.setWords(scope().cell.words.replace("-", " "));
    scope().$apply();
  }
}

spellWord = function() {
  word = scope().cell.words;
  spelledWord = "";
  for (char of word) {
    spelledWord = spelledWord + char + "-";
  }
  spelledWord = spelledWord.substr(0, spelledWord.length - 1).toUpperCase();
  if(spelledWord.split("---").length>1)
  {
    spelledWord = spelledWord.split("---").join("").toLowerCase();
  }
  scope().cell.setWords(spelledWord);
  scope().$apply();
}

applyDoubleDash = function()
{
  words = scope().cell.words;
  if (words.endsWith("--"))
  {
    scope().cell.setWords("--" + words.substr(0, words.length-2).toLowerCase());
  }
  else if (words.startsWith("--"))
  {
    scope().cell.setWords(words.substr(2));
  }
  else
  {
    scope().cell.setWords(words + "--");
  }
  scope().$apply();
}

formatSong = function(e) {
  words = scope().cell.words;
  singer = words.split(",")[0].trim();
  title = words.split(",").length == 1 ? "" : '"' + words.split(",")[1].trim() + '"';
  title = title.replace('""', '"').replace('""', '"');
  music = "[" + singer + ", " + title + "]";
  scope().cell.setWords(music.replace(", ]", "]").toUpperCase());
  scope().$apply();
  e.preventDefault();
}

parseDuration = function() {
  return $(".tab-pane:eq(6) td.ng-binding:eq(13)").text();
}

parsePay = function() {
  return parseFloat($(".tab-pane:eq(6) td.ng-binding:eq(15)").text().substr(1));
}

parseName = function() {
  return $(".tab-pane:eq(6) td.ng-binding:eq(3)").text();
}

parseID = function() {
  return $(".tab-pane:eq(6) td.ng-binding:eq(1)").text();
}

parsePay = function() {
  return parseFloat($(".tab-pane:eq(6) td.ng-binding:eq(15)").text().replace("$", ""));
}

parseRate = function() {
  parts = parseDuration().split(":");
  minutes = parseFloat(parts[0]*60) + parseFloat(parts[1]) + parseFloat(parts[2])/60;
  return parsePay()/minutes;
}

getFilesData = function() {
  return JSON.parse(localStorage.getItem("files_data") || "{}");
}

saveFileData = function()
{
  files_data = getFilesData();
  file_data = files_data[parseID()];

  if (!file_data)
  {
    file_data = {};
    file_data.working_time = 0;
    file_data.pay = parsePay();
    file_data.duration = parseDuration();
    file_data.name = parseName();

  }
  else
  {
    file_data.payRate = parseFloat(parsePay())/(parseFloat(file_data.working_time)/3600/1000).toFixed(2);
  }

  files_data[parseID()] = file_data;

  try
  {
    localStorage.setItem("files_data", JSON.stringify(files_data));
  }
  catch (error)
  {
    sortedFileIDs = Object.keys(filesData).sort(function(a, b) {return parseInt(a) > parseInt(b)});
    delete filesData[sortedFileIDs[0]];
    delete filesData[parseID()];
    localStorage.setItem("files_data", JSON.stringify(filesData));
    saveFileData();
  }
}

onStartup = function() {
  //If the file has yet to fully load, try again
  if (!$(".active-cell").length) {
    setTimeout(onStartup, 100);
    return;
  }

  //initially save the file data if first time opened
  if (!getFilesData()[parseID()])
  {
    saveFileData();
  }
    //toggle the speed to the initial setting
    //  toggleSpeed();

    //bring the special instructions to the top right
  $(".col-md-6").eq(1).prepend($(".panel-open").eq(1));

  //save the file data on finish
  $("#finish-dropdown a").mousedown(saveFileData);

  //automatically load low quality
  if(switch_to_low_quality)
  {
    for(i of $("#video-playback-dropdown li a"))
    {
      if(i.textContent == "Switch to Low Quality Stream" || i.textContent == "Switch to HTML5 Audio")
      {
        i.click();
	  //setTimeout(toggleSpeed(), 500);
	  setTimeout(500);
        return;
      }
    }
  }
}

onStartup();

document.onmousemove = updateTimeWorked;


// some functions that deal with creating and
// destroying paragraghs

getParagraph = function () {
    var cpi = scope().paragraph.transcript.findCellParagraph(scope().cell)['index'];
    return scope().paragraph.transcript.paragraphs[cpi];
}

// $("body").keydown(function(e) {
//   if(!e.ctrlKey && e.altKey && e.shiftKey && e.which == 70) //70 is f
//   {
//       $("[ng-click='onClickFullScreen()']").click();
//       e.stopPropagation();
//       e.preventDefault();
//       setTimeout(() => {
//   $(".tp-transcript").focus();}, 500);
//   }
// });

// $("body").keydown(function(e) {
//   if(!e.ctrlKey && e.altKey && !e.shiftKey && e.which == 70) //70 is f
//   {
//       $("[ng-click='onClickFullScreen()']").click();
//       e.stopPropagation();
//       e.preventDefault();
//       setTimeout(() => {
//   $(".tp-transcript").focus();}, 500);
//   }
// });

$("body").keydown(function(e) {
  if(!e.ctrlKey && e.altKey && !e.shiftKey && e.which == 67) //67 is c
  {
      $(".tp-transcript").focus();
      e.stopPropagation();
      e.preventDefault();
  }
});

// $(".tp-transcript").focus();
// hasFocus = ele => (ele === document.activeElement);
// STOE_app = document.querySelector(".tp-transcript");
// const STOE_app = document.getElementsByClassName("tp-transcript")
// const log = document.getElementById(".tp-transcript");

// isSTOEFocused = function () {
//     if (STOE_app == document.activeElement) {
// 	return true;
//     } else {
// 	return false;
//     }
// }

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 190)
  {
    scope().cell.setWords(scope().cell.words + ".");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 188)
  {
      scope().cell.setWords(scope().cell.words + ",");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 191) //191 is ?
  {
      scope().cell.setWords(scope().cell.words + "?");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 59) //59 is ; (186 in other browsers)
  {
      scope().cell.setWords(scope().cell.words + ";");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 59) //59 is ; (186 in other browsers)
  {
      scope().cell.setWords(scope().cell.words + ":");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 49) //49 is !
  {
      scope().cell.setWords(scope().cell.words + "!");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 222) //222 is '
  {
      scope().cell.setWords(scope().cell.words + "'");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 222) //222 is " (186 in other browsers)
  {
      scope().cell.setWords(scope().cell.words + "\"");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 53) //53 is %
  {
      scope().cell.setWords(scope().cell.words + "%");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 220) //220 is %
  {
      scope().cell.setWords(scope().cell.words + "|");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 191) //191 is /
  {
      scope().cell.setWords(scope().cell.words + "/");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && !e.shiftKey && !e.altKey && e.which == 173) //173 is -
  {
      scope().cell.setWords(scope().cell.words + "-");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 173) //173 is -
  {
      scope().cell.setWords(scope().cell.words + "_");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 50) //50 is @
  {
      scope().cell.setWords(scope().cell.words + "@");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 43) //43 is +
  {
      scope().cell.setWords(scope().cell.words + "+");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

$("body").keydown(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.ctrlKey && e.shiftKey && !e.altKey && e.which == 48) //48 is 0
  {
      scope().cell.setWords(scope().cell.words + ")");
    scope().cell.editing = true;
    scope().$apply();

    e.stopPropagation();
    e.preventDefault();
  }
});

// $("body").keydown(function(e) {
//     var STOE_app = document.querySelector(".tp-transcript");
//     var string
//     if(hasFocus(STOE_app)) {
// 	string = "true!"
//     } else {
// 	string = "false!"
//     }
//     if(!e.ctrlKey && !e.altKey && !e.shiftKey && e.which == 220)
//     {
// 	scope().cell.setWords(scope().cell.words + string); //220 is \ and |
// 	scope().cell.editing = true;
// 	scope().$apply();

// 	e.stopPropagation();
// 	e.preventDefault();
//     }
// });

appendIfEditing = function (x) {
if (scope().cell.editing == true) {
    scope().cell.setWords(scope().cell.words + x);
    scope().$apply();
} else {
    scope().cell.setWords(x);
    scope().cell.editing = true;
    scope().$apply();
}
};

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 225) //225 is á
	{
	    appendIfEditing("á");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 193) //193 is Á
	{
	    appendIfEditing("Á");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 233) //233 is é
	{
	    appendIfEditing("é");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 201) //201 is É
	{
	    appendIfEditing("É");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 237) //237 is í
	{
	    appendIfEditing("í");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 205) //205 is Í
	{
	    appendIfEditing("Í");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 243) //243 is ó
	{
	    appendIfEditing("ó");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 211) //211 is Ó
	{
	    appendIfEditing("Ó");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 252) //252 is ü
	{
	    appendIfEditing("ü");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 250) //250 is ú
	{
	    appendIfEditing("ú");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 220) //220 is Ü
	{
	    appendIfEditing("Ü");
  }
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && !e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 241) //241 is ñ
	{
	    appendIfEditing("ñ");
	}
});

$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 209) //209 is Ñ
	{
	    appendIfEditing("Ñ");
	}
});


$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 48) //48 is 0
	{
	    appendIfEditing(")");
	}
});
$("body").keypress(function(e) {
    var app = document.querySelector(".tp-transcript");
    if(hasFocus(app) && e.shiftKey && !e.ctrlKey && !e.altKey && e.which == 41) //41 is )
	{
	    appendIfEditing(")");
	}
});

toggle_z_leader = function () {
    z_leader = true;
    setTimeout(() => {
	z_leader = false;
    }, z_leader_timeout);
};



