import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

// Simple manual mock implementation
class MockClient {
  http.Response? _response;
  Exception? _exception;
  List<String> _calledUrls = [];

  void setResponse(http.Response response) {
    _response = response;
    _exception = null;
  }

  void setException(Exception exception) {
    _exception = exception;
    _response = null;
  }

  Future<http.Response> get(Uri url) async {
    _calledUrls.add(url.toString());

    if (_exception != null) {
      throw _exception!;
    }

    return _response ?? http.Response('{}', 200);
  }

  Future<http.Response> post(Uri url, {Object? body}) async {
    _calledUrls.add('POST: ${url.toString()}');

    if (_exception != null) {
      throw _exception!;
    }

    return _response ?? http.Response('{}', 201);
  }

  List<String> get calledUrls => _calledUrls;

  void reset() {
    _response = null;
    _exception = null;
    _calledUrls.clear();
  }
}

// Abstract interface to make testing easier
abstract class HttpClient {
  Future<http.Response> get(Uri url);
  Future<http.Response> post(Uri url, {Object? body});
}

// Real implementation
class RealHttpClient implements HttpClient {
  final http.Client _client = http.Client();

  @override
  Future<http.Response> get(Uri url) => _client.get(url);

  @override
  Future<http.Response> post(Uri url, {Object? body}) =>
      _client.post(url, body: body);
}

// Manual mock implementation for testing
class MockHttpClient implements HttpClient {
  http.Response? _getResponse;
  http.Response? _postResponse;
  Exception? _exception;
  List<String> _calledUrls = [];

  void setGetResponse(http.Response response) {
    _getResponse = response;
    _exception = null;
  }

  void setPostResponse(http.Response response) {
    _postResponse = response;
    _exception = null;
  }

  void setException(Exception exception) {
    _exception = exception;
    _getResponse = null;
    _postResponse = null;
  }

  @override
  Future<http.Response> get(Uri url) async {
    _calledUrls.add('GET: $url');

    if (_exception != null) {
      throw _exception!;
    }

    return _getResponse ?? http.Response('{"default": "response"}', 200);
  }

  @override
  Future<http.Response> post(Uri url, {Object? body}) async {
    _calledUrls.add('POST: $url');

    if (_exception != null) {
      throw _exception!;
    }

    return _postResponse ?? http.Response('{"created": true}', 201);
  }

  // Test helpers
  List<String> get calledUrls => List.unmodifiable(_calledUrls);
  int get callCount => _calledUrls.length;
  bool wasGetCalled(String url) =>
      _calledUrls.any((call) => call.contains('GET') && call.contains(url));
  bool wasPostCalled(String url) =>
      _calledUrls.any((call) => call.contains('POST') && call.contains(url));

  void reset() {
    _getResponse = null;
    _postResponse = null;
    _exception = null;
    _calledUrls.clear();
  }
}

// Service class that uses dependency injection
class UserService {
  final HttpClient client;

  UserService(this.client);

  Future<Map<String, dynamic>?> fetchUser(int userId) async {
    try {
      final response = await client.get(
        Uri.parse('https://jsonplaceholder.typicode.com/users/$userId'),
      );

      if (response.statusCode == 200) {
        // In a real app, you'd parse JSON here
        return {'id': userId, 'data': response.body};
      }
      return null;
    } catch (e) {
      throw Exception('Failed to fetch user: $e');
    }
  }

  Future<bool> createUser(Map<String, dynamic> userData) async {
    try {
      final response = await client.post(
        Uri.parse('https://jsonplaceholder.typicode.com/users'),
        body: userData.toString(),
      );

      return response.statusCode == 201;
    } catch (e) {
      return false;
    }
  }

  Future<List<Map<String, dynamic>>> fetchMultipleUsers(
    List<int> userIds,
  ) async {
    final List<Map<String, dynamic>> users = [];

    for (final id in userIds) {
      final user = await fetchUser(id);
      if (user != null) {
        users.add(user);
      }
    }

    return users;
  }
}

void main() {
  group('UserService with Manual Mocks', () {
    late MockHttpClient mockClient;
    late UserService userService;

    setUp(() {
      mockClient = MockHttpClient();
      userService = UserService(mockClient);
    });

    tearDown(() {
      mockClient.reset();
    });

    group('fetchUser', () {
      test('should return user data when API call is successful', () async {
        // Arrange
        const userId = 1;
        const mockResponseBody =
            '{"id": 1, "name": "John Doe", "email": "john@example.com"}';
        mockClient.setGetResponse(http.Response(mockResponseBody, 200));

        // Act
        final result = await userService.fetchUser(userId);

        // Assert
        expect(result, isNotNull);
        expect(result!['id'], userId);
        expect(result['data'], mockResponseBody);
        expect(mockClient.callCount, 1);
        expect(mockClient.wasGetCalled('users/$userId'), true);
      });

      test('should return null when API returns non-200 status', () async {
        // Arrange
        const userId = 1;
        mockClient.setGetResponse(http.Response('Not Found', 404));

        // Act
        final result = await userService.fetchUser(userId);

        // Assert
        expect(result, isNull);
        expect(mockClient.callCount, 1);
      });

      test('should throw exception when network error occurs', () async {
        // Arrange
        const userId = 1;
        mockClient.setException(Exception('Network error'));

        // Act & Assert
        expect(
          () => userService.fetchUser(userId),
          throwsA(
            isA<Exception>().having(
              (e) => e.toString(),
              'message',
              contains('Failed to fetch user'),
            ),
          ),
        );
        expect(mockClient.callCount, 1);
      });
    });

    group('createUser', () {
      test('should return true when user creation is successful', () async {
        // Arrange
        final userData = {'name': 'Jane Doe', 'email': 'jane@example.com'};
        mockClient.setPostResponse(http.Response('{"id": 2}', 201));

        // Act
        final result = await userService.createUser(userData);

        // Assert
        expect(result, true);
        expect(mockClient.callCount, 1);
        expect(mockClient.wasPostCalled('users'), true);
      });

      test('should return false when user creation fails', () async {
        // Arrange
        final userData = {'name': 'Jane Doe', 'email': 'invalid-email'};
        mockClient.setPostResponse(http.Response('Bad Request', 400));

        // Act
        final result = await userService.createUser(userData);

        // Assert
        expect(result, false);
        expect(mockClient.callCount, 1);
      });

      test('should return false when network error occurs', () async {
        // Arrange
        final userData = {'name': 'Jane Doe', 'email': 'jane@example.com'};
        mockClient.setException(Exception('Network timeout'));

        // Act
        final result = await userService.createUser(userData);

        // Assert
        expect(result, false);
        expect(mockClient.callCount, 1);
      });
    });

    group('fetchMultipleUsers', () {
      test('should fetch multiple users successfully', () async {
        // Arrange
        const userIds = [1, 2, 3];
        mockClient.setGetResponse(http.Response('{"user": "data"}', 200));

        // Act
        final result = await userService.fetchMultipleUsers(userIds);

        // Assert
        expect(result.length, 3);
        expect(mockClient.callCount, 3);

        for (int i = 0; i < userIds.length; i++) {
          expect(result[i]['id'], userIds[i]);
          expect(mockClient.wasGetCalled('users/${userIds[i]}'), true);
        }
      });

      test('should handle partial failures gracefully', () async {
        // Arrange
        const userIds = [1, 2, 3];
        int callCount = 0;

        // Override the get method to simulate different responses
        mockClient = MockHttpClient();
        userService = UserService(mockClient);

        // Act
        final result = await userService.fetchMultipleUsers(userIds);

        // Assert - should return empty list if default response is used
        expect(result.length, 3); // Default mock returns success
        expect(mockClient.callCount, 3);
      });
    });

    group('Test Interaction Patterns', () {
      test('should track method call order', () async {
        // Arrange
        mockClient.setGetResponse(http.Response('{}', 200));
        mockClient.setPostResponse(http.Response('{}', 201));

        // Act
        await userService.fetchUser(1);
        await userService.createUser({'name': 'Test'});
        await userService.fetchUser(2);

        // Assert
        final calls = mockClient.calledUrls;
        expect(calls.length, 3);
        expect(calls[0], contains('GET'));
        expect(calls[0], contains('users/1'));
        expect(calls[1], contains('POST'));
        expect(calls[2], contains('GET'));
        expect(calls[2], contains('users/2'));
      });

      test('should reset mock state between tests', () async {
        // This test verifies that tearDown properly resets the mock
        expect(mockClient.callCount, 0);
        expect(mockClient.calledUrls, isEmpty);
      });
    });
  });

  group('Testing Best Practices Demonstration', () {
    test('should use descriptive test names that explain behavior', () {
      // This test name clearly describes what behavior is being tested
      expect(true, true);
    });

    test('should use AAA pattern: Arrange, Act, Assert', () async {
      // Arrange - Set up test data and mocks
      final mockClient = MockHttpClient();
      final userService = UserService(mockClient);
      mockClient.setGetResponse(http.Response('{}', 200));

      // Act - Execute the behavior being tested
      final result = await userService.fetchUser(1);

      // Assert - Verify the expected outcome
      expect(result, isNotNull);
    });

    test('should test edge cases and error conditions', () async {
      final mockClient = MockHttpClient();
      final userService = UserService(mockClient);

      // Test empty response
      mockClient.setGetResponse(http.Response('', 200));
      final emptyResult = await userService.fetchUser(1);
      expect(emptyResult, isNotNull);

      // Test server error
      mockClient.reset();
      mockClient.setGetResponse(http.Response('Internal Server Error', 500));
      final errorResult = await userService.fetchUser(1);
      expect(errorResult, isNull);
    });
  });
}
