class RequestApi {
  static const test = '/api/test/{text}';

  static const searchMovie = '/api/search/movie/{text}';
  static const searchMovieCancel  = '/api/search/movie/cancel/{id}';
  static const searchResult = '/api/search/result/{page}/{id}';
  static const searchLabelAnytime = '/api/search/label/anytime';
  static const searchLabelHot = '/api/search/label/hot';

  static const checkDeviceId = '/api/device/check/{deviceId}';

  static const userLogin  = '/api/user/login';
  static const userProfile = '/api/user/profile/{id}';
  static const userFans = '/api/user/fans/{id}/{page}';
  static const userFollow = '/api/user/follow/{id}/{page}';
  static const userMyFans = '/api/user/myFans/{page}';
  static const userMyFollow = '/api/user/myFollow/{page}';
  static const userProfileVideo = '/api/user/profile/{id}/video/{page}';
  static const userMyProfile = '/api/user/my/profile';
  static const userMyProfileVideo = '/api/user/my/profile/video/{page}';
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
  static const videoPublicity = '/api/video/publicity';
  static const videoPublicityReport = '/api/video/publicity/report/{id}';

  static const shortVideoHeartbeat = '/api/shortVideo/heartbeat';
  static const shortVideoUpload = '/api/shortVideo/upload';
  static const shortVideoFollow = '/api/shortVideo/follow/{id}';
  static const shortVideoUnfollow = '/api/shortVideo/unfollow/{id}';
  static const shortVideoComments = '/api/shortVideo/comments/{id}/{page}';
  static const shortVideoCommentChildren = '/api/shortVideo/comment/children/{id}/{page}';
  static const shortVideoComment = '/api/shortVideo/comment';
  static const shortVideoCommentPin = '/api/shortVideo/comment/pin/{id}';
  static const shortVideoCommentUnpin = '/api/shortVideo/comment/unpin/{id}';
  static const shortVideoCommentDelete = '/api/shortVideo/comment/delete/{id}';
  static const shortVideoCommentReport = '/api/shortVideo/comment/report/{id}';
  static const shortVideoCommentLike = '/api/shortVideo/comment/like/{id}';
  static const shortVideoCommentUnlike = '/api/shortVideo/comment/unlike/{id}';
  static const shortVideoLike = '/api/shortVideo/like/{id}';
  static const shortVideoUnlike = '/api/shortVideo/unlike/{id}';
  static const shortVideoFriend = '/api/shortVideo/friend/{id}/{page}';
  static const shortVideoConcentration = '/api/shortVideo/concentration/{page}';

  static const gameTest = '/api/game/test';
  static const gameList = '/api/game/list';
  static const gamePayment = '/api/game/payment';
  static const gameRecords = '/api/game/records';
  static const gameEnter = '/api/game/enterGame';
  static const gameScroll = '/api/game/scroll';
  static const gameBalance = '/api/game/getBalance';
  static const gameCashOutBalance = '/api/game/cashOut/getBalance';
  static const gameCashOutGetConfig = '/api/game/cashOut/getConfig';
  static const gameCashOutGetCards = '/api/game/cashOut/getCards/{page}';
  static const gameCashOutEditCard = '/api/game/cashOut/editCard';
  static const gameCashOutAddCard = '/api/game/cashOut/addCard';
  static const gameCashOutRemoveCard = '/api/game/cashOut/removeCard/{id}';
  static const gameCashOutSetDefault = '/api/game/cashOut/setDefault/{id}';
  static const gameCashOutRecords = '/api/game/cashOut/records/{page}';
  static const gameCashOut = '/api/game/cashOut';
  static const gamePublicity = '/api/game/publicity';
  static const gameButtons = '/api/game/buttons';
  static const gameButton = '/api/game/button/{id}';
  static const gameOrder = '/api/game/order/{page}';
  static const gameFunds = '/api/game/fund/{page}';
  static const gamePublicityReport = '/api/game/publicity/report/{id}';
}