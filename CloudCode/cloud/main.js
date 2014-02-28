// Use Parse.Cloud.define to define as many cloud functions as you want
Parse.Cloud.define("parseFriends", function(request, response) {
	var userQuery = new Parse.Query(Parse.User);
	userQuery.containedIn("fbId", request.params.friendIDs);
	userQuery.find({
		success: function(results){
			response.success(results);
		},
		error: function() {
			response.error("Friend lookup failed");
		}
	});
});