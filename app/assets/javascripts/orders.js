//= require ../../../vendor/assets/javascripts/date.format.js

// If the user is on an iPhone, give them access to the HTML5 controls, 
// and remove the old-style controls from the DOM
$(document).ready(function() {
  // Code from http://stackoverflow.com/questions/3007480/determine-if-user-navigated-from-mobile-safari
  var userAgent = window.navigator.userAgent;
  
  if (userAgent.match(/iPad/i) || userAgent.match(/iPhone/i)) {
    $("div.regular-datepicker").remove();
    $("div.html5-datepicker").removeClass("html5-datepicker");
  }
});

// Start the order timer
function startTimer(labelSelector, timerSelector, date) {
	tickTimer(labelSelector, timerSelector, date);
  window.setInterval(function() { tickTimer(labelSelector, timerSelector, date); }, 1000);
  
  // Called every second, to update the displayed time until
  // Requires that the referenced DOM element have the attribute "date" set
  function tickTimer(labelSelector, timerSelector, date) {
    var eventDate = new Date(parseInt(date));
    var timeRemaining = Math.floor((eventDate - Date.now()) / 1000);	// In seconds
    
    var timerText = "";
		var labelText = "";
    if (Math.floor(timeRemaining) > 0) {
      var days = Math.floor(timeRemaining / 60 / 60 / 24);
      timeRemaining -= days * 60 * 60 * 24;
      var hours = Math.floor(timeRemaining / 60 / 60);
      timeRemaining -= hours * 60 * 60;
      var minutes = Math.floor(timeRemaining / 60);
      timeRemaining -= minutes * 60;
      var seconds = Math.floor(timeRemaining);
      timeRemaining -= minutes;
      
      if (days > 0)
      {
        timerText += days;
        if (days == 1) 
          timerText += " day, ";
        else 
          timerText += " days, ";
      }
      if ((hours > 0) || (days > 0))
      {
        timerText += hours;
        if (hours == 1) 
          timerText += " hour, ";
        else 
          timerText += " hours, ";
      }
      if ((minutes > 0) || (hours > 0) || (days > 0))
      {
        timerText += minutes;
        if (minutes == 1) 
          timerText += " minute, ";
        else 
          timerText += " minutes, ";
      }
      // Always show seconds
      timerText += seconds;
      if (seconds == 1) 
        timerText += " second ";
      else 
        timerText += " seconds ";
			labelText = "Will be placed in: ";
    }
    else {
      // The event happened in the past
			labelText = "Placed at: ";
			customDateFormat = "dddd, mmmm, d, yyyy, HH:MM:ss ";
      timerText = dateFormat(eventDate, customDateFormat);
    }
		$(labelSelector).text(labelText);
    $(timerSelector).text(timerText);
  }
}
