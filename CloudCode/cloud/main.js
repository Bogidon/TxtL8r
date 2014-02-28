// Use Parse.Cloud.define to define as many cloud functions as you want
Parse.Cloud.define("parseFriends", function(request, response) {
	var query = new Parse.Query(Parse.User);
	query.containedIn("fbId", request.params.friendIDs);
	query.find({
		success: function(results){
			response.success(results);
		},
		error: function() {
			response.error("Friend lookup failed");
		}
	});
});