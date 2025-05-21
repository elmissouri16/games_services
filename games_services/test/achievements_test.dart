import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:games_services/src/achievements.dart';
import 'package:games_services/src/models/achievement_item_data.dart';
import 'package:games_services_platform_interface/game_services_platform_interface.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

// Generate mocks for GamesServicesPlatform
@GenerateMocks([GamesServicesPlatform])
import 'achievements_test.mocks.dart';

void main() {
  // Create a mock instance
  late MockGamesServicesPlatform mockPlatform;

  setUp(() {
    // Initialize the mock before each test
    mockPlatform = MockGamesServicesPlatform();
    // Set the mock instance as the default for GamesServicesPlatform
    GamesServicesPlatform.instance = mockPlatform;
  });

  group('Achievements', () {
    const achievementId = 'ach_1';
    const achievementName = 'Test Achievement 1';
    const achievementDescription = 'Description for Test Achievement 1';
    const lockedImageBase64 = 'base64_locked_image_data';
    const unlockedImageBase64 = 'base64_unlocked_image_data';

    final achievementJsonWithImages = [
      {
        'id': achievementId,
        'name': achievementName,
        'description': achievementDescription,
        'lockedImage': lockedImageBase64,
        'unlockedImage': unlockedImageBase64,
        'completedSteps': 50,
        'totalSteps': 100,
        'unlocked': false,
      }
    ];

    final achievementJsonWithoutImages = [
      {
        'id': achievementId,
        'name': achievementName,
        'description': achievementDescription,
        'lockedImage': null,
        'unlockedImage': null,
        'completedSteps': 50,
        'totalSteps': 100,
        'unlocked': false,
      }
    ];

    test('loadAchievements with loadImages: true should return achievements with image data', () async {
      // Arrange
      when(mockPlatform.loadAchievements(loadImages: true, forceRefresh: false))
          .thenAnswer((_) async => jsonEncode(achievementJsonWithImages));

      // Act
      final achievements = await Achievements.loadAchievements(loadImages: true, forceRefresh: false);

      // Assert
      expect(achievements, isNotNull);
      expect(achievements!.length, 1);
      final achievement = achievements.first;
      expect(achievement.id, achievementId);
      expect(achievement.name, achievementName);
      expect(achievement.description, achievementDescription);
      expect(achievement.lockedImage, lockedImageBase64);
      expect(achievement.unlockedImage, unlockedImageBase64);
      expect(achievement.completedSteps, 50);
      expect(achievement.totalSteps, 100);
      expect(achievement.unlocked, false);
      verify(mockPlatform.loadAchievements(loadImages: true, forceRefresh: false)).called(1);
    });

    test('loadAchievements with loadImages: false should return achievements without image data', () async {
      // Arrange
      when(mockPlatform.loadAchievements(loadImages: false, forceRefresh: false))
          .thenAnswer((_) async => jsonEncode(achievementJsonWithoutImages));

      // Act
      final achievements = await Achievements.loadAchievements(loadImages: false, forceRefresh: false);

      // Assert
      expect(achievements, isNotNull);
      expect(achievements!.length, 1);
      final achievement = achievements.first;
      expect(achievement.id, achievementId);
      expect(achievement.name, achievementName);
      expect(achievement.description, achievementDescription);
      expect(achievement.lockedImage, isNull);
      expect(achievement.unlockedImage, isNull);
      verify(mockPlatform.loadAchievements(loadImages: false, forceRefresh: false)).called(1);
    });

    test('loadAchievements with loadImages: true and forceRefresh: true should call platform with correct params', () async {
      // Arrange
      when(mockPlatform.loadAchievements(loadImages: true, forceRefresh: true))
          .thenAnswer((_) async => jsonEncode(achievementJsonWithImages));

      // Act
      await Achievements.loadAchievements(loadImages: true, forceRefresh: true);

      // Assert
      verify(mockPlatform.loadAchievements(loadImages: true, forceRefresh: true)).called(1);
    });

    test('loadAchievements with loadImages: false and forceRefresh: true should call platform with correct params', () async {
      // Arrange
      when(mockPlatform.loadAchievements(loadImages: false, forceRefresh: true))
          .thenAnswer((_) async => jsonEncode(achievementJsonWithoutImages));

      // Act
      await Achievements.loadAchievements(loadImages: false, forceRefresh: true);

      // Assert
      verify(mockPlatform.loadAchievements(loadImages: false, forceRefresh: true)).called(1);
    });
     test('loadAchievements with loadImages defaults to false', () async {
      // Arrange
      when(mockPlatform.loadAchievements(loadImages: false, forceRefresh: false))
          .thenAnswer((_) async => jsonEncode(achievementJsonWithoutImages));

      // Act
      final achievements = await Achievements.loadAchievements(); // loadImages defaults to false

      // Assert
      expect(achievements, isNotNull);
      expect(achievements!.length, 1);
      final achievement = achievements.first;
      expect(achievement.lockedImage, isNull);
      expect(achievement.unlockedImage, isNull);
      verify(mockPlatform.loadAchievements(loadImages: false, forceRefresh: false)).called(1);
    });
  });
}
