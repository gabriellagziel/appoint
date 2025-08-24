class FCMService {
  Future<void> initialize() async {}

  Future<String?> getToken() async => 'test-token';

  Future<void> subscribeToTopic(String topic) async {}

  Future<void> unsubscribeFromTopic(String topic) async {}
}

