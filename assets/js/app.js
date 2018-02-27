// Brunch automatically concatenates all files in your
// watched paths. Those paths can be configured at
// config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if
// explicitly imported. The only exception are files
// in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember
// to also remove its path from "config.paths.watched".
import $ from "jquery";
import "phoenix_html"

function set_button(post_id, value) {
  $('.start-button').each( (_, bb) => {
    if (post_id == $(bb).data('post-id')) {
      $(bb).data('toggle', value);
    }
  });
  update_buttons();
}

function update_buttons() {
  $('.start-button').each( (_, bb) => {
    let btn_toggle = $(bb).data('toggle')
    if (btn_toggle != "start") {
      $(bb).text("End Working");
    }
    else {
      $(bb).text("Start Working");
    }
  });
}

function start(post_id) {
  let current_time = new Date();
    set_button(post_id, "end",);
    sessionStorage.setItem('to', current_time)
}

function end(post_id, time_id) {
  let current_time = new Date();
  let endSecond = current_time.getSeconds();
  let endMinute = current_time.getMinutes();
  let endHour = current_time.getHours();
  let endDay = current_time.getDate();
  let endMonth = current_time.getMonth() + 1;
  let endYear = current_time.getFullYear();
  let start_time = new Date(sessionStorage.getItem('to'));
  let startSecond = start_time.getSeconds();
  let startMinute = start_time.getMinutes();
  let startHour = start_time.getHours();
  let startDay = start_time.getDate();
  let startMonth = start_time.getMonth() + 1;
  let startYear = start_time.getFullYear();
  let text = JSON.stringify({
        post_id: post_id,
        end_second: endSecond,
        end_minute: endMinute,
        end_hour: endHour,
        end_day: endDay,
        end_month: endMonth,
        end_year: endYear,
        start_second: startSecond,
        start_minute: startMinute,
        start_hour: startHour,
        start_day: startDay,
        start_month: startMonth,
        start_year: startYear
  });
  if (time_id == "")
  {
      $.ajax(block_path, {
      method: "POST",
      dataType: "json",
      contentType: "application/json; charset=UTF-8",
      data: text,
    });
    set_button(post_id, "start");
    alert("Time Block Set!");
    window.location.replace(userHomePage);
  }
  else {
    $.ajax(block_path, {
    method: "PUT",
    dataType: "json",
    contentType: "application/json; charset=UTF-8",
    data: text,
  });
  set_button(post_id, "start");
  alert("Time Block Set!");
  window.location.replace(userHomePage);
  }
}


function start_click(ev) {
  let btn = $(ev.target);
  let toggle = btn.data('toggle');
  let post_id = btn.data('post-id');
  let time_id = btn.data('time-id');
  if (toggle == "start")
    start(post_id);
  else
    end(post_id, time_id);
}
function init() {
  if (!$('.start-button')) {
    console.log("Not Start Button!")
    return;
  }

  $(".start-button").click(start_click);

  update_buttons();
}

$(init);

// Import local files
//
// Local files can be imported directly using relative
// paths "./socket" or full ones "web/static/js/socket".

// import socket from "./socket"
