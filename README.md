# TaskPulse

A collaborative project management application built with Ruby on Rails. TaskPulse helps teams organize projects, manage tasks, track progress, and collaborate effectively.

## Features

- **Team Management**: Create teams, invite members, and manage team roles
- **Project Organization**: Create and manage projects within teams
- **Task Tracking**: Create, assign, and track tasks with status updates
- **Comments**: Collaborate on tasks with team comments
- **Activity Logs**: Track all project and task activities
- **Dashboard**: Overview of your teams, projects, and tasks
- **User Authentication**: Secure authentication with Devise

## Tech Stack

- **Ruby**: 3.x
- **Rails**: 8.1.1
- **Database**: PostgreSQL
- **Frontend**: Hotwire (Turbo & Stimulus)
- **Authentication**: Devise
- **Asset Pipeline**: Propshaft
- **Web Server**: Puma

## Prerequisites

Before you begin, ensure you have the following installed:
- Ruby (3.x or higher)
- Rails (8.1.1)
- PostgreSQL (9.3 or higher)
- Node.js (for JavaScript dependencies)

## Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd task_pulse
   ```

2. **Install dependencies**
   ```bash
   bundle install
   ```

3. **Configure environment variables**
   
   Create a `.env` file in the root directory:
   ```
   DATABASE_PASSWORD=your_postgres_password
   ```

4. **Setup the database**
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

5. **Start the server**
   ```bash
   rails server
   ```

6. **Visit the application**
   
   Open your browser and navigate to `http://localhost:3000`

## Database Configuration

The application uses PostgreSQL. Update `config/database.yml` if needed:

```yaml
development:
  adapter: postgresql
  database: task_pulse_development
  username: postgres
  password: <%= ENV['DATABASE_PASSWORD'] %>
  host: localhost
```

## Usage

1. **Create an account**: Sign up with your email and password
2. **Create a team**: Start by creating a team for your organization
3. **Add team members**: Invite colleagues to join your team
4. **Create projects**: Organize work into projects within your team
5. **Manage tasks**: Create tasks, assign them, and track progress
6. **Collaborate**: Use comments to discuss tasks with team members

## Running Tests

```bash
rails test
rails test:system
```

## Docker Support

The project includes a Dockerfile for containerization:

```bash
docker build -t task_pulse .
docker run -p 3000:3000 task_pulse
```

## Project Structure

```
app/
├── controllers/      # Application controllers
├── models/          # ActiveRecord models (User, Team, Project, Task, Comment)
├── views/           # View templates
├── javascript/      # Stimulus controllers
└── assets/          # Stylesheets and images

config/              # Application configuration
db/                  # Database schema and migrations
test/               # Test files
```

## Models

- **User**: Handles authentication and user management
- **Team**: Organizes users into teams
- **TeamMembership**: Manages user-team relationships
- **Project**: Containers for tasks within a team
- **Task**: Individual work items with status tracking
- **Comment**: Discussion threads on tasks
- **ActivityLog**: Tracks all system activities

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is open source and available under the [MIT License](LICENSE).

## Support

For issues, questions, or contributions, please open an issue on GitHub.
