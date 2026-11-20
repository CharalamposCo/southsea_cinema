# Southsea Cinema

A Flutter mobile application developed as coursework for the Programming Applications and Programming Languages (M30235) and User Experience Design and Implementation (M32605) modules at the University of Portsmouth.

## Overview

Southsea Cinema is a mobile-friendly cinema application inspired by the [Southsea Cinema website](https://southseacinema.savoysystems.co.uk/SouthseaCinema.dll/).

The application allows users to browse cinema movies, add tickets to a basket, complete bookings and view their previous bookings.

The project is developed progressively through the weekly coursework worksheets.

## Features

The application currently includes:

- **Movie listings:** Browse available cinema movies and view their information.
- **Shopping basket:** Add and remove movie tickets and calculate the total price.
- **Booking system:** Complete a booking and receive a booking number.
- **Booking history:** Store and display previous bookings using SQLite.
- **Settings:** Save customer details and preferences.
- **Light and dark themes:** Switch between light and dark appearance, with the selected theme saved between app sessions.
- **Automated tests:** Unit tests and widget tests for the application's main functionality.

## Technologies Used

- Flutter
- Dart
- SQLite using `sqflite`
- Shared Preferences
- Visual Studio Code
- Git and GitHub

## Getting Started

### Prerequisites

You need:

- A GitHub account.
- Flutter SDK installed.
- Dart SDK (included with Flutter).
- Git installed and connected to your GitHub account.
- Visual Studio Code or another Flutter-compatible IDE.
- An Android emulator or compatible device.

Follow the [development environment instructions in Worksheet 1](https://manighahrmani.github.io/sandwich_shop/worksheet-1.html#set-up-your-development-environment).

### Clone the Repository

Fork the original repository on GitHub and clone your fork:

```bash
git clone https://github.com/YOUR-USERNAME/southsea_cinema.git
cd southsea_cinema
```

Replace `YOUR-USERNAME` with your GitHub username.

### Install Dependencies

Open a terminal in the project directory and run:

```bash
flutter pub get
```

This downloads the packages required by the application.

### Run the Application

Start an Android emulator or connect a compatible device, then run:

```bash
flutter run
```

To see the available devices, use:

```bash
flutter devices
```

### Run Tests

To execute all automated tests, run:

```bash
flutter test
```

To check the project for errors and warnings, run:

```bash
flutter analyze
```

## Project Structure

The project is organised into separate folders to keep the code maintainable and easy to understand.

```text
southsea_cinema/
├── lib/
│   ├── constants.dart
│   ├── main.dart
│   ├── database/
│   │   └── cinema_db.dart
│   ├── models/
│   │   ├── movie.dart
│   │   └── booking.dart
│   ├── repositories/
│   │   ├── basket_repository.dart
│   │   └── movie_repository.dart
│   ├── views/
│   │   ├── home_view.dart
│   │   ├── basket_view.dart
│   │   └── settings_view.dart
│   └── widgets/
│       └── nav_drawer.dart
├── test/
│   ├── database/
│   ├── models/
│   ├── repositories/
│   ├── views/
│   └── widget_test.dart
├── pubspec.yaml
└── README.md
```

Additional files and folders may be added as the coursework develops.

## Marking Criteria

The Southsea Cinema coursework is Item 1 of the module and is worth 50% of the overall module mark.

Assessment takes place through five live, in-person demonstrations during timetabled practical sessions. Every two worksheets prepare students for one demonstration.

Only the best four demonstration marks count towards Item 1. Each counted demonstration contributes 25% of Item 1.

Each demonstration assesses:

- Functionality (9%).
- Code quality (8%).
- Understanding of your own code through two questions (8%).

Demonstrations must be completed in order, and students can complete at most one demonstration during each two-week demonstration window.

For the full mark breakdown, missed-demo rules and Extenuating Circumstances information, read the [Assessment Guide](https://portdotacdotuk-my.sharepoint.com/:w:/g/personal/mani_ghahremani_port_ac_uk/IQC9nZoNwb2jT40MnFQPZWVvAVdTK2PGBmZ8jPff30RRyPc).

The full demonstration dates and requirements are listed on the [Flutter Course homepage](https://manighahrmani.github.io/sandwich_shop/).

## Submission

Submit the link to your public forked GitHub repository on Moodle before the first demonstration.

You do not need to submit a ZIP file or a separate copy of the source code.

Make sure your repository is public and that it can be accessed using a private or incognito browser window.

## Demonstration Preparation

Before attending a demonstration, make sure the application runs correctly from a clean clone.

Run:

```bash
flutter pub get
flutter test
flutter analyze
flutter run
```

You should be able to explain the functionality you have implemented and answer questions about your code.

## Help with Coursework

If you have questions or encounter problems, use the [Discord guide](https://portdotacdotuk-my.sharepoint.com/:p:/g/personal/mani_ghahremani_port_ac_uk/IQCMJP6IiR_bQoYUMdXJSRDYAWnajEALZYEXFZyrJkHS1QU) to find the dedicated coursework Discord channel.

Before posting a question, check existing discussions to see whether it has already been answered.

You can also attend your timetabled practical sessions to receive support from teaching staff.