# Flutter Flashcard App

This application is developed using Flutter for the frontend and TypeScript for the backend. It allows users to create sets of flashcards and add cards to them. Only the creator of a set or flashcard can edit or delete it. Sets can be marked as public, allowing all users to view and learn from them.

## Features

- Create and edit flashcard sets
- Add flashcards to sets
- Mark sets as public
- Browse public flashcard sets
- Study flashcards with the ability to mark correct and incorrect answers
- View learning statistics

## Database Structure (Firestore)

- **userStats**
  - `averageAccuracy`: average accuracy
  - `averageRepeatUnknown`: average number of repeated unknown flashcards
  - `totalSetsCompleted`: total number of completed sets
- **sets**
  - `creatorUserId`: ID of the set creator
  - `isPublic`: whether the set is public
  - `title`: title of the set
- **setStats**
  - `averageAccuracy`: average accuracy
  - `totalAttempts`: total number of attempts
  - `totalCorrect`: total number of correct answers
  - `totalIncorrect`: total number of incorrect answers
  - `totalRepeatUnknown`: total number of repeated unknown flashcards
- **flashcards**
  - `definition`: flashcard definition
  - `setId`: ID of the set
  - `term`: flashcard term

## Application Screens

1. **Study Screen**
   - Navigate through flashcards in a set
   - Mark flashcards as correct or incorrect
2. **Study Summary Screen**
   - Display results after studying (correct and incorrect answers)
   - Option to review incorrectly answered flashcards or all flashcards
3. **General Statistics Screen**
   - Statistics for all sets
   - Average number of mastered flashcards, number of completed tests, number of perfectly mastered sets
4. **Set Statistics Screen**
   - Statistics for a specific set
   - Average number of mastered flashcards, number of completed tests
5. **Main Screen**
   - Display all public flashcard sets (with filtering and pagination)
6. **Add Flashcards Screen**
7. **Login and Registration Screens**
8. **User's Flashcards Screen**
   - Display flashcards created by the user (with filtering and pagination)

## Installation

To run the application locally, follow these steps:

1. Clone the repository:
   ```sh
   git clone https://github.com/weronikakopacz/flashcards_app.git

2. Start the backend:
   ```sh
   cd server
   npm start
   
3. Run the frontend:
   ```sh
   cd ../frontend
   flutter run

## Requirements
- Flutter SDK
- Node.js
- Firestore (Firebase)
