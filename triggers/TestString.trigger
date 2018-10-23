trigger TestString on Account (before update) {
	ID userId = '00530000000hAqD';
	if(userId == UserInfo.getUserId())
		System.debug('ID matches ID');
	String userString = '00530000000hAqD';
	if(userString == UserInfo.getUserId())
		System.debug('String matches ID');
}