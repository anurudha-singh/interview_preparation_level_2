import 'package:flutter_test/flutter_test.dart';

// Example business logic class for unit testing
class Calculator {
  double add(double a, double b) => a + b;
  double subtract(double a, double b) => a - b;
  double multiply(double a, double b) => a * b;
  double divide(double a, double b) {
    if (b == 0) throw ArgumentError('Cannot divide by zero');
    return a / b;
  }
  
  bool isEven(int number) => number % 2 == 0;
  List<int> getEvenNumbers(List<int> numbers) {
    return numbers.where((n) => isEven(n)).toList();
  }
}

// Example data model for testing
class User {
  final String name;
  final String email;
  final int age;
  
  User({required this.name, required this.email, required this.age});
  
  bool get isAdult => age >= 18;
  bool get hasValidEmail => email.contains('@') && email.contains('.');
  
  Map<String, dynamic> toJson() => {
    'name': name,
    'email': email,
    'age': age,
  };
  
  factory User.fromJson(Map<String, dynamic> json) => User(
    name: json['name'],
    email: json['email'],
    age: json['age'],
  );
}

void main() {
  group('Calculator Unit Tests', () {
    late Calculator calculator;
    
    setUp(() {
      calculator = Calculator();
    });
    
    group('Basic Operations', () {
      test('should add two numbers correctly', () {
        // Arrange
        const double a = 5.0;
        const double b = 3.0;
        
        // Act
        final result = calculator.add(a, b);
        
        // Assert
        expect(result, 8.0);
      });
      
      test('should subtract two numbers correctly', () {
        expect(calculator.subtract(10.0, 4.0), 6.0);
      });
      
      test('should multiply two numbers correctly', () {
        expect(calculator.multiply(6.0, 7.0), 42.0);
      });
      
      test('should divide two numbers correctly', () {
        expect(calculator.divide(15.0, 3.0), 5.0);
      });
      
      test('should throw error when dividing by zero', () {
        expect(() => calculator.divide(10.0, 0.0), throwsArgumentError);
      });
    });
    
    group('Number Analysis', () {
      test('should identify even numbers', () {
        expect(calculator.isEven(2), isTrue);
        expect(calculator.isEven(3), isFalse);
        expect(calculator.isEven(0), isTrue);
        expect(calculator.isEven(-2), isTrue);
      });
      
      test('should filter even numbers from list', () {
        final numbers = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
        final evenNumbers = calculator.getEvenNumbers(numbers);
        
        expect(evenNumbers, [2, 4, 6, 8, 10]);
        expect(evenNumbers.length, 5);
      });
      
      test('should return empty list when no even numbers', () {
        final oddNumbers = [1, 3, 5, 7, 9];
        final result = calculator.getEvenNumbers(oddNumbers);
        
        expect(result, isEmpty);
      });
    });
  });
  
  group('User Model Tests', () {
    test('should create user with valid data', () {
      final user = User(
        name: 'John Doe',
        email: 'john@example.com',
        age: 25,
      );
      
      expect(user.name, 'John Doe');
      expect(user.email, 'john@example.com');
      expect(user.age, 25);
    });
    
    test('should identify adult users', () {
      final adult = User(name: 'Adult', email: 'adult@test.com', age: 18);
      final minor = User(name: 'Minor', email: 'minor@test.com', age: 17);
      
      expect(adult.isAdult, isTrue);
      expect(minor.isAdult, isFalse);
    });
    
    test('should validate email format', () {
      final validUser = User(name: 'Valid', email: 'valid@test.com', age: 25);
      final invalidUser = User(name: 'Invalid', email: 'invalid-email', age: 25);
      
      expect(validUser.hasValidEmail, isTrue);
      expect(invalidUser.hasValidEmail, isFalse);
    });
    
    test('should serialize to JSON correctly', () {
      final user = User(name: 'Test User', email: 'test@test.com', age: 30);
      final json = user.toJson();
      
      expect(json['name'], 'Test User');
      expect(json['email'], 'test@test.com');
      expect(json['age'], 30);
    });
    
    test('should deserialize from JSON correctly', () {
      final json = {
        'name': 'Test User',
        'email': 'test@test.com',
        'age': 30,
      };
      
      final user = User.fromJson(json);
      
      expect(user.name, 'Test User');
      expect(user.email, 'test@test.com');
      expect(user.age, 30);
    });
  });
  
  group('Edge Cases and Error Handling', () {
    late Calculator calculator;
    
    setUp(() {
      calculator = Calculator();
    });
    
    test('should handle negative numbers', () {
      expect(calculator.add(-5.0, -3.0), -8.0);
      expect(calculator.multiply(-2.0, 3.0), -6.0);
    });
    
    test('should handle decimal precision', () {
      expect(calculator.add(0.1, 0.2), closeTo(0.3, 0.01));
    });
    
    test('should handle large numbers', () {
      const large1 = 999999999.0;
      const large2 = 111111111.0;
      expect(calculator.add(large1, large2), 1111111110.0);
    });
  });
}
