# Boat-Sched - Boat Scheduling Management System

A comprehensive boat scheduling management system built with Spring Boot backend, Flutter frontend, MySQL database, and Docker deployment.

## Features

### User Features
- Phone number-based authentication
- Create schedules (only for next day from 00:00)
- View own schedules with status filtering
- Cancel own requested schedules
- Real-time push notifications via FCM
- View system notices and popup alerts
- Danger mode visual indicator (red background)

### Manager Features
- View all schedules from all users
- Approve or cancel any schedule
- Manage system configuration (notices, popups, danger mode)
- Send broadcast notifications to all users (on danger mode toggle)
- Board/Card view for easy schedule management

## Tech Stack

### Backend
- **Framework**: Spring Boot 3.2.1
- **Language**: Java 17
- **Database**: MySQL 8.0
- **Authentication**: JWT (JSON Web Tokens)
- **Push Notifications**: Firebase Cloud Messaging (FCM)
- **Build Tool**: Maven
- **Containerization**: Docker

### Frontend
- **Framework**: Flutter
- **Language**: Dart
- **State Management**: Provider
- **HTTP Client**: http package
- **Secure Storage**: flutter_secure_storage
- **Push Notifications**: firebase_messaging

## Project Structure

```
bollae/
├── backend/                     # Spring Boot application
│   ├── src/main/java/com/boatsched/
│   │   ├── entity/             # JPA entities (User, Schedule, SystemConfig)
│   │   ├── repository/         # Spring Data JPA repositories
│   │   ├── service/            # Business logic services
│   │   ├── controller/         # REST API controllers
│   │   ├── dto/                # Data transfer objects
│   │   ├── security/           # JWT authentication & authorization
│   │   ├── config/             # Configuration classes (Firebase, Security)
│   │   └── BoatSchedApplication.java
│   ├── src/main/resources/
│   │   ├── application.yml     # Main configuration
│   │   └── application-local.yml  # Local development config
│   ├── pom.xml                 # Maven dependencies
│   └── Dockerfile              # Backend Docker image
├── frontend/                   # Flutter application
│   ├── lib/
│   │   ├── models/             # Data models
│   │   ├── services/           # API and business logic services
│   │   ├── screens/            # UI screens
│   │   ├── providers/          # State management
│   │   └── main.dart           # App entry point
│   └── pubspec.yaml            # Flutter dependencies
├── docker-compose.yml          # Docker services configuration
├── .env.example                # Environment variables template
└── README.md                   # This file
```

## Prerequisites

### For Backend Development
- Java 17 or higher
- Maven 3.6+
- MySQL 8.0 (or use Docker)
- Firebase project with service account JSON

### For Frontend Development
- Flutter SDK 3.0+
- Dart SDK 3.0+
- Android Studio / Xcode (for mobile development)

### For Docker Deployment
- Docker 20.10+
- Docker Compose 2.0+

## Quick Start

### 1. Backend Setup

#### Using Docker (Recommended)

1. Copy environment variables:
```bash
cp .env.example .env
```

2. Edit `.env` file with your credentials:
```env
DB_NAME=boatsched
DB_PORT=3306
DB_PASSWORD=your_secure_password
JWT_SECRET=your_jwt_secret_key_min_256_bits
FIREBASE_CONFIG_PATH=./firebase-config.json
```

3. Place your Firebase service account JSON file as `firebase-config.json` in the project root.

4. Start services:
```bash
docker-compose up -d
```

The backend will be available at `http://localhost:8080`

#### Local Development (Without Docker)

1. Start MySQL:
```bash
# Using Docker for MySQL only
docker run -d \
  --name boatsched-mysql \
  -e MYSQL_ROOT_PASSWORD=password \
  -e MYSQL_DATABASE=boatsched \
  -p 3306:3306 \
  mysql:8.0
```

2. Configure `backend/src/main/resources/application-local.yml` with your database credentials.

3. Build and run:
```bash
cd backend
mvn clean install
mvn spring-boot:run -Dspring-boot.run.profiles=local
```

### 2. Frontend Setup

1. Install dependencies:
```bash
cd frontend
flutter pub get
```

2. Configure API endpoint:
Edit `frontend/lib/services/api_service.dart` and update the `baseUrl`:
```dart
static const String baseUrl = 'http://YOUR_BACKEND_IP:8080/api';
```

3. Firebase Setup:
- Add `google-services.json` to `frontend/android/app/`
- Add `GoogleService-Info.plist` to `frontend/ios/Runner/`

4. Run the app:
```bash
flutter run
```

## API Documentation

### Authentication Endpoints

#### Register User
```http
POST /api/auth/register
Content-Type: application/json

{
  "phoneNumber": "010-1234-5678",
  "storeName": "My Store",
  "representativeName": "John Doe"
}
```

Response:
```json
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
  "userId": 1,
  "phoneNumber": "010-1234-5678",
  "storeName": "My Store",
  "representativeName": "John Doe",
  "role": "USER"
}
```

#### Login
```http
POST /api/auth/login
Content-Type: application/json

{
  "phoneNumber": "010-1234-5678"
}
```

### Schedule Endpoints

All schedule endpoints require JWT authentication via `Authorization: Bearer {token}` header.

#### Create Schedule
```http
POST /api/schedules
Authorization: Bearer {token}
Content-Type: application/json

{
  "scheduleDate": "2026-01-20",
  "scheduleTime": "09:00:00",
  "paxCount": 5,
  "purpose": "관광",
  "note": "Optional note"
}
```

#### Get Schedules
```http
GET /api/schedules?status=REQUESTED
Authorization: Bearer {token}
```

Status options: `REQUESTED`, `APPROVED`, `CANCELED` (omit for all)

#### Approve Schedule (Manager only)
```http
PUT /api/schedules/{id}/approve
Authorization: Bearer {token}
```

#### Cancel Schedule
```http
DELETE /api/schedules/{id}
Authorization: Bearer {token}
```

### System Configuration Endpoints

#### Get System Config
```http
GET /api/system/config
```

Public endpoint (no auth required)

#### Update System Config (Manager only)
```http
PUT /api/system/config
Authorization: Bearer {token}
Content-Type: application/json

{
  "noticeTitle": "Important Notice",
  "noticeContent": "Please check the weather forecast",
  "popupContent": "System maintenance scheduled",
  "isDangerMode": false
}
```

### User Endpoints

#### Update FCM Token
```http
PUT /api/users/fcm-token
Authorization: Bearer {token}
Content-Type: application/json

{
  "fcmToken": "firebase_cloud_messaging_token"
}
```

## Business Rules

### Date Validation
- Schedules can only be created for **the next day** (current date + 1 day)
- The validation is based on the date starting from 00:00 (midnight)
- This rule is enforced in both frontend and backend

### Available Options

**Time Slots**:
- 09:00, 10:00, 11:00, 13:00, 14:00, 15:00, 16:00, 17:00

**Passenger Count**:
- 1 to 10 passengers

**Purpose Options**:
- 관광 (Tourism)
- 낚시 (Fishing)
- 화물운송 (Cargo Transport)
- 기타 (Other)

### Authorization Rules

**USER Role**:
- Can only view and cancel own schedules
- Can create new schedules

**MANAGER Role**:
- Can view all schedules from all users
- Can approve and cancel any schedule
- Can manage system configuration

### Push Notification Triggers

1. **Schedule Created** → Notify all managers
2. **Schedule Approved** → Notify the requesting user
3. **Schedule Canceled by Manager** → Notify the requesting user
4. **Danger Mode Toggled** → Broadcast to all users

## Database Schema

### users
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT |
| phone_number | VARCHAR(20) | UNIQUE, NOT NULL |
| store_name | VARCHAR(255) | NOT NULL |
| representative_name | VARCHAR(255) | NOT NULL |
| role | ENUM('MANAGER','USER') | NOT NULL |
| fcm_token | VARCHAR(255) | |

### schedules
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PRIMARY KEY, AUTO_INCREMENT |
| user_id | BIGINT | FOREIGN KEY, NOT NULL |
| schedule_date | DATE | NOT NULL |
| schedule_time | TIME | NOT NULL |
| pax_count | INT | NOT NULL |
| purpose | VARCHAR(50) | NOT NULL |
| note | TEXT | |
| status | ENUM('REQUESTED','APPROVED','CANCELED') | NOT NULL |

### system_config
| Column | Type | Constraints |
|--------|------|-------------|
| id | BIGINT | PRIMARY KEY |
| notice_title | TEXT | |
| notice_content | TEXT | |
| popup_content | TEXT | |
| is_danger_mode | BOOLEAN | NOT NULL, DEFAULT FALSE |

## Development

### Creating a Manager Account

By default, all registered users have the `USER` role. To create a manager account, manually update the database:

```sql
UPDATE users SET role = 'MANAGER' WHERE phone_number = '010-1234-5678';
```

Or insert directly:
```sql
INSERT INTO users (phone_number, store_name, representative_name, role)
VALUES ('010-9999-9999', 'Admin', 'Manager Name', 'MANAGER');
```

### Running Tests

Backend:
```bash
cd backend
mvn test
```

Frontend:
```bash
cd frontend
flutter test
```

## Deployment

### AWS Deployment Strategy

1. **Database**: Create RDS MySQL instance
2. **Backend**: Deploy to EC2 or Elastic Beanstalk
3. **Frontend**: Build APK/IPA and distribute

Update environment variables:
```env
DB_HOST=your-rds-endpoint.amazonaws.com
DB_NAME=boatsched
DB_USER=admin
DB_PASSWORD=your_rds_password
JWT_SECRET=your_production_jwt_secret
FIREBASE_CONFIG_PATH=/path/to/firebase-config.json
```

## Security Considerations

1. **JWT Secret**: Use a strong, random secret key (minimum 256 bits)
2. **Database Password**: Use strong passwords for production
3. **Firebase Config**: Never commit firebase-config.json to version control
4. **HTTPS**: Use HTTPS in production (configure SSL certificates)
5. **CORS**: Update CORS configuration for production domains

## Troubleshooting

### Backend doesn't start
- Check MySQL is running: `docker ps`
- Check logs: `docker-compose logs backend`
- Verify database credentials in .env file

### Frontend can't connect to backend
- Update API baseUrl in `api_service.dart`
- Check backend is accessible: `curl http://localhost:8080/api/system/config`
- For Android emulator, use `10.0.2.2` instead of `localhost`

### FCM notifications not working
- Verify Firebase config file is present
- Check FCM token is being sent to backend
- Review backend logs for Firebase initialization errors

## License

This project is proprietary and confidential.

## Support

For issues and questions, please contact the development team.
