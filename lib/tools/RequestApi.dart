class RequestApi {
  static const test = '/api/test/{text}';

  static const searchMovie = '/api/search/movie/{text}';
  static const searchMovieCancel  = '/api/search/movie/cancel/{id}';
  static const searchResult = '/api/search/result/{page}/{id}';
  static const searchLabelAnytime = '/api/search/label/anytime';
  static const searchLabelHot = '/api/search/label/hot';

  static const checkDeviceId = '/api/device/check/{deviceId}';

  static const userLogin  = '/api/user/login';
  static const userRegister = '/api/user/register';
  static const userRegisterSms = '/api/user/register/sms/{phone}';

  static const videoPlayer = '/api/video/player/{id}';
  static const videoLike = '/api/video/like/{id}';
  static const videoShare = '/api/video/share/{id}';
  static const videoComments = '/api/video/comment/{page}/{id}';
  static const videoCommentDelete = '/api/video/comment/delete/{id}';
  static const videoCommentLike = '/api/video/comment/like/{id}';
  static const videoComment = '/api/video/comment';
  static const videoHeartbeat = '/api/video/heartbeat';
  static const videoAnytime = '/api/video/anytime';
  static const videoCategoryTags = '/api/video/category/tags';
  static const videoCategoryList = '/api/video/category/list/{first}/{second}/{last}/{page}';
  static const videoConcentrations = '/api/video/concentrations';
  static const videoConcentrationsAnytime = '/api/video/concentrations/anytime/{id}';
  static const videoConcentration = '/api/video/concentrations/{id}/{page}';
  static const videoMembership = '/api/video/membership/{page}';
  static const videoDiamond = '/api/video/diamond/{page}';
  static const videoRank = '/api/video/rank/{first}/{second}';

  static const shortVideoHeartbeat = '/api/shortVideo/heartbeat';
  static const shortVideoUpload = '/api/shortVideo/upload';
  static const shortVideoFollow = '/api/shortVideo/follow/{id}';
  static const shortVideoUnfollow = '/api/shortVideo/unfollow/{id}';
  static const shortVideoComments = '/api/shortVideo/comments/{id}/{page}';
  static const shortVideoComment = '/api/shortVideo/comment';
  static const shortVideoLike = '/api/shortVideo/like/{id}';
  static const shortVideoUnlike = '/api/shortVideo/unlike/{id}';
  static const shortVideoFriend = '/api/shortVideo/friend/{id}/{page}';
  static const shortVideoConcentration = '/api/shortVideo/concentration/{page}';
}