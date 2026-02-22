# Club Management Platform - Functionalities Documentation

## Overview
Role-Based Club Management Web Application for ~100 users, built with Flutter and Firebase, focused on Task and Event Management.

---

## 1. Authentication System

### Features
- **User Registration**
  - Email/password authentication via Firebase Auth
  - Email verification required
  - Profile setup during registration (name, department selection)

- **User Login**
  - Email/password login
  - Password recovery/reset functionality
  - Remember me option
  - Session management

- **User Logout**
  - Secure logout with session cleanup
  - Automatic logout on token expiration

### Technical Requirements
- Firebase Authentication integration
- Secure token management
- Password complexity requirements (min 8 chars, uppercase, lowercase, number)
- Rate limiting for failed login attempts

---

## 2. Role-Based Access Control (RBAC)

### Role Hierarchy
1. **Member** (Base Level)
   - View assigned tasks
   - View assigned events
   - View own profile
   - Update task status (assigned tasks only)

2. **Department Manager**
   - All Member permissions
   - Create/edit/archive tasks for their department
   - Create/edit/archive events for their department
   - View department member profiles
   - Assign tasks to department members
   - View department analytics

3. **Core Team**
   - All Department Manager permissions (across all departments)
   - View global analytics dashboard
   - Create events from templates
   - Manage multi-department events
   - Access activity logs
   - View all member profiles

4. **Admin**
   - All Core Team permissions
   - Create/update/delete users
   - Assign/modify roles
   - Create/edit/delete event templates
   - Manage departments
   - Access admin analytics dashboard
   - Permanent delete archived items
   - View/manage activity logs

### Authorization Rules
- Role-based UI rendering (hide/show features based on role)
- Backend security rules enforce permissions
- Dynamic permission updates on role change
- Hierarchical permission inheritance

---

## 3. Membership Lifecycle Tracking

### Member Profile Management
**Fields:**
- Member ID (auto-generated)
- Full Name
- Email
- Join Date (auto-set on registration)
- Current Role
- Current Department
- Profile Picture URL (Google Drive link)
- Status (Active/Archived)
- Promotion History (array of role changes)
- Department Change History (array of department transfers)

### Promotion History Tracking
**Each Entry:**
- Previous Role
- New Role
- Changed By (Admin ID)
- Change Date
- Reason/Notes (optional)

### Department Change History
**Each Entry:**
- Previous Department
- New Department
- Changed By (Admin/Manager ID)
- Change Date
- Reason/Notes (optional)

### Status Management
- **Active**: Normal operational status
- **Archived**: Soft-deleted but retained for history
- Archived members:
  - Cannot login
  - Remain in historical data
  - Tasks/events remain linked
  - Can be restored by Admin
  - Can be permanently deleted by Admin

### Features
- View member profile (role-based access)
- Edit member information (Admin/Core Team only)
- Role promotion/demotion (Admin only)
- Department transfer (Admin/Core Team only)
- Member deactivation/archiving (Admin only)
- Member restoration from archive (Admin only)
- Permanent deletion (Admin only, from archive)

---

## 4. Department System

### Department Structure
**Fields:**
- Department ID
- Department Name
- Description
- Manager ID (reference to Member)
- Member List (array of Member IDs)
- Created Date
- Status (Active/Archived)

### Department Features
- **Create Department** (Admin only)
  - Name, description
  - Assign initial manager

- **Edit Department** (Admin/Core Team)
  - Update name, description
  - Change manager (triggers permission transfer)

- **Assign Members** (Admin/Core Team)
  - Add members to department
  - Remove members from department
  - Track department change history

- **Archive Department** (Admin only)
  - Soft delete department
  - Maintain historical data
  - Handle member reassignment

### Manager Responsibilities
- Manage department tasks
- Manage department events
- View department member performance
- Assign tasks to department members

### Permission Transfer Rules
**When Department Manager Role is Removed:**
1. Remove edit permissions on tasks created as manager
2. New manager inherits edit permissions on department tasks
3. Historical data remains attributed to original creator
4. Activity logs record permission transfer

---

## 5. Task Assignment Engine

### Task Model
**Fields:**
- Task ID
- Title
- Description
- Assigned Members (array of Member IDs)
- Assigned Department (Department ID)
- Assigned Role (optional: Member/Manager/Core/Admin)
- Deadline (DateTime)
- Status (Pending/In Progress/Completed/Archived)
- Related Event ID (optional)
- Google Drive Links (array)
- Created By (Member ID)
- Created By Role (role at time of creation)
- Created Date
- Last Modified Date
- Last Modified By
- Archived Flag (boolean)
- Completion Date (optional)

### Task Assignment Types

#### 1. Individual Assignment
- Task assigned to specific member(s)
- Each assigned member can view the task
- All assigned members share the same task instance
- Any assigned member can update status

#### 2. Department Assignment
- Task visible to all department members
- Only department members, manager, core team, and admin can view
- Department manager can assign to specific members within department

#### 3. Role-Based Assignment
- Task visible to all members with specified role
- Dynamic: new members with that role automatically see it
- Permission updates automatically when member role changes

### Task Visibility Rules
**Department Tasks:**
- Department Members: Can view
- Department Manager: Can view and edit
- Core Team: Can view and edit
- Admin: Can view and edit
- Other departments: Cannot view

**Role-Based Tasks:**
- Members with assigned role: Can view
- Task creator: Can view and edit
- Core Team: Can view and edit
- Admin: Can view and edit

**Individual Tasks:**
- Assigned members: Can view and update status
- Task creator: Can view and edit
- Department manager (if same dept): Can view and edit
- Core Team: Can view and edit
- Admin: Can view and edit

### Task Management Features
- **Create Task** (Manager/Core Team/Admin)
  - Set title, description, deadline
  - Assign to members/department/role
  - Link to event (optional)
  - Add Google Drive links

- **Edit Task** (Based on permissions)
  - Update details
  - Reassign members
  - Change deadline
  - Add/remove Drive links
  - Update status

- **Update Task Status** (Assigned members)
  - Mark as In Progress
  - Mark as Completed
  - Add completion notes

- **Archive Task** (Creator, Manager, Core Team, Admin)
  - Soft delete
  - Move to archive
  - Maintain history

- **Link to Event** (Creator, Manager, Core Team, Admin)
  - Associate task with event
  - Display in event context

### Task Notifications
- Deadline reminders (24h, 1 week before)
- Assignment notifications
- Status update notifications to creator
- Overdue task alerts

---

## 6. Event Management

### Event Model
**Fields:**
- Event ID
- Title
- Description
- Start Date
- End Date
- Timeline (array of milestones)
- Departments (array of Department IDs)
- Meetings (array of meeting objects)
- Linked Tasks (array of Task IDs)
- Google Drive Links (array)
- Created By (Member ID)
- Created By Role
- Created Date
- Last Modified Date
- Status (Planning/Ongoing/Completed/Archived)
- Template ID (if created from template)

### Timeline Structure
**Milestone Object:**
- Milestone ID
- Title
- Description
- Target Date
- Status (Pending/Completed)
- Responsible Department/Member

### Meeting Structure
**Meeting Object:**
- Meeting ID
- Title
- Date & Time
- Duration
- Location/Link
- Attendees (array of Member IDs)
- Department (optional)
- Notes/Minutes (Google Drive link)
- Status (Scheduled/Completed/Cancelled)

### Event Features
- **Create Event** (Manager/Core Team/Admin)
  - Set title, description
  - Define timeline
  - Assign departments
  - Schedule meetings
  - Create from template (optional)

- **Edit Event** (Creator, Assigned Managers, Core Team, Admin)
  - Update details
  - Modify timeline
  - Add/remove departments
  - Manage meetings
  - Link/unlink tasks

- **View Event** (Based on department assignment)
  - Members of assigned departments can view
  - Core Team and Admin can view all events

- **Event Dashboard**
  - View all milestones
  - Track linked tasks progress
  - View upcoming meetings
  - Access Drive links
  - Timeline visualization

- **Archive Event** (Creator, Core Team, Admin)
  - Soft delete event
  - Maintain event history
  - Keep linked tasks accessible

### Meeting Management
- Schedule meetings within events
- Track meeting attendance
- Link meeting notes (Drive)
- Meeting reminders
- Count meetings as events in analytics

---

## 7. Event Templates

### Template Model
**Fields:**
- Template ID
- Template Name
- Description
- Default Tasks (array of task templates)
- Default Departments (array)
- Default Timeline (array of milestone templates)
- Default Meetings (array of meeting templates)
- Created By (Admin ID)
- Created Date
- Last Modified Date
- Status (Active/Archived)

### Task Template Structure
- Title
- Description
- Default Assigned Department
- Default Assigned Role
- Suggested Deadline (relative: "7 days before event")
- Google Drive Links (template links)

### Timeline Template Structure
- Milestone Title
- Milestone Description
- Relative Date ("2 weeks before", "1 week before", "event date")
- Responsible Department (default)

### Meeting Template Structure
- Meeting Title
- Relative Date/Time
- Default Duration
- Default Attendees (by role/department)

### Template Features
- **Create Template** (Admin only)
  - Define template structure
  - Set default tasks
  - Set default departments
  - Set default timeline
  - Set default meetings

- **Edit Template** (Admin only)
  - Update template details
  - Modify default tasks
  - Modify timeline
  - Modify meetings

- **Instantiate Event from Template** (Manager/Core Team/Admin)
  - Select template
  - Customize event details
  - Adjust timeline dates
  - Modify departments
  - Create all linked tasks automatically
  - Schedule meetings based on template

- **View Templates** (Manager/Core Team/Admin)
  - Browse available templates
  - Preview template structure

- **Archive Template** (Admin only)
  - Soft delete template
  - Maintain history of events created from it

---

## 8. Activity Logging System

### Activity Log Model
**Fields:**
- Log ID
- Action Type (enum)
- Actor ID (Member who performed action)
- Actor Role (role at time of action)
- Target Type (Task/Event/Member/Department/Template)
- Target ID
- Timestamp
- Before State (JSON snapshot)
- After State (JSON snapshot)
- Notes/Reason (optional)
- IP Address (optional)

### Action Types
**Member Actions:**
- `MEMBER_CREATED`
- `MEMBER_UPDATED`
- `MEMBER_ROLE_CHANGED`
- `MEMBER_DEPARTMENT_CHANGED`
- `MEMBER_ARCHIVED`
- `MEMBER_RESTORED`
- `MEMBER_DELETED`

**Task Actions:**
- `TASK_CREATED`
- `TASK_UPDATED`
- `TASK_ASSIGNED`
- `TASK_STATUS_CHANGED`
- `TASK_ARCHIVED`
- `TASK_RESTORED`
- `TASK_DELETED`

**Event Actions:**
- `EVENT_CREATED`
- `EVENT_UPDATED`
- `EVENT_ARCHIVED`
- `EVENT_RESTORED`
- `EVENT_DELETED`
- `MEETING_SCHEDULED`
- `MEETING_UPDATED`
- `MEETING_CANCELLED`

**Department Actions:**
- `DEPARTMENT_CREATED`
- `DEPARTMENT_UPDATED`
- `DEPARTMENT_MANAGER_CHANGED`
- `DEPARTMENT_ARCHIVED`
- `DEPARTMENT_RESTORED`

**Template Actions:**
- `TEMPLATE_CREATED`
- `TEMPLATE_UPDATED`
- `TEMPLATE_ARCHIVED`
- `TEMPLATE_INSTANTIATED`

### Logging Attachments
**Task Logs:**
- Attached to task document
- Viewable by task creator, assigned members, managers, core team, admin

**Member Profile Logs:**
- Attached to member document
- Viewable by member themselves, core team, admin
- Shows promotion history, department changes, role changes

**Event Logs:**
- Attached to event document
- Viewable by event creator, department managers, core team, admin

### Log Features
- **Automatic Logging**
  - All CRUD operations logged automatically
  - Role changes logged
  - Status changes logged
  - Assignment changes logged

- **View Activity Logs** (Role-based)
  - Members: Own profile logs
  - Managers: Department entity logs
  - Core Team: All logs
  - Admin: All logs

- **Search/Filter Logs** (Core Team/Admin)
  - Filter by action type
  - Filter by actor
  - Filter by date range
  - Filter by target type

- **Audit Trail**
  - Immutable log entries
  - Complete change history
  - Attribution of all changes

---

## 9. Soft Delete & Archive System

### Soft Delete Mechanism
**Applicable To:**
- Members
- Tasks
- Events
- Departments
- Templates

### Archive Process
1. **Soft Delete Action**
   - Set `archived` flag to true
   - Set `archived_date` timestamp
   - Set `archived_by` to actor ID
   - Keep all data intact
   - Log the archive action

2. **Archive View**
   - Separate "Archive" section in UI
   - List all archived items by type
   - Show archive date and reason
   - Searchable and filterable

3. **Restore Action**
   - Available to Admin (and Core Team for tasks/events)
   - Unset `archived` flag
   - Set `restored_date` timestamp
   - Set `restored_by` to actor ID
   - Log the restore action

4. **Permanent Delete**
   - Available ONLY in Archive view
   - Admin only
   - Confirmation dialog with warning
   - Complete removal from database
   - Cannot be undone
   - Log the deletion action

### Archive Features
- **View Archive** (Admin/Core Team)
  - Browse archived items
  - Filter by type
  - Sort by archive date
  - Search archived items

- **Restore from Archive** (Admin/Core Team)
  - Restore individual items
  - Bulk restore (Admin only)
  - Restore with confirmation

- **Permanent Delete** (Admin only)
  - Delete individual items
  - Bulk delete option
  - Confirmation with password
  - Warning about irreversibility

### Archived Item Behavior
**Members:**
- Cannot login
- Not shown in member lists
- Remain in task/event assignments (historical)
- Profile viewable in archive

**Tasks:**
- Not shown in active task lists
- Remain linked to events
- Count in historical analytics
- Searchable in archive

**Events:**
- Not shown in event lists
- Linked tasks remain accessible
- Count in historical analytics
- Searchable in archive

**Departments:**
- Not shown in department lists
- Members must be reassigned before archiving
- Historical references remain

**Templates:**
- Not shown in template list
- Events created from it remain linked
- Cannot be instantiated

---

## 10. Analytics Dashboard

### Access Control
- **Admin & Core Team Only**
- Comprehensive metrics
- Real-time updates
- Export capabilities

### Dashboard Metrics

#### Overview Section
- Total Active Members
- Total Active Tasks
- Total Events (including meetings)
- Tasks Completed This Month
- Upcoming Deadlines (next 7 days)

#### Task Analytics
- **Overall:**
  - Total tasks created
  - Tasks by status (Pending/In Progress/Completed/Archived)
  - Completion rate (%)
  - Average completion time

- **By Department:**
  - Tasks per department
  - Completion rate per department
  - Overdue tasks per department

- **By Member:**
  - Most active members (tasks completed)
  - Tasks per member
  - Average tasks per member

- **Timeline:**
  - Tasks created over time (chart)
  - Tasks completed over time (chart)
  - Monthly/weekly views

#### Event Analytics
- **Overall:**
  - Total events organized
  - Events by status
  - Meetings scheduled vs completed
  - Events per month (chart)

- **By Department:**
  - Events per department
  - Department participation rate

- **Timeline:**
  - Events over time (chart)
  - Upcoming events calendar

#### Member Analytics
- Total members
- Active vs Archived members
- Members by role (breakdown)
- Members by department (breakdown)
- New members this month
- Promotion history summary

#### Performance Metrics
- Average task completion time
- On-time completion rate
- Overdue task rate
- Most productive departments
- Most productive members
- Event success rate (based on timeline completion)

### Visualization Types
- Line charts (trends over time)
- Bar charts (comparisons)
- Pie charts (distributions)
- Tables (detailed breakdowns)
- Heatmaps (activity patterns)

### Export Features
- Export to PDF
- Export to CSV
- Date range selection
- Custom metric selection

---

## 11. File Management

### No File Storage
- Application does NOT store files directly
- All files stored in Google Drive
- Only links stored in database

### Google Drive Integration
**Link Fields:**
- In Tasks: Array of Drive links
- In Events: Array of Drive links
- In Meetings: Link to meeting notes
- In Member Profiles: Link to profile picture

**Link Management:**
- Add Drive link (paste URL)
- Validate link format
- Display link with icon
- Open link in new tab
- Remove link

**Best Practices:**
- Use shared Google Drive folder per department
- Organize by event/task
- Consistent naming conventions
- Proper sharing permissions set in Drive

---

## 12. Version 1 Limitations

### Admin Cannot (V1):
- **Disable Members** (must archive instead)
- **Lock Task Updates** (no freeze functionality)
- **Freeze Departments** (no department freeze)

### Future Enhancements (V2+):
- Member suspension (temporary disable)
- Task locking (prevent updates)
- Department freeze (pause operations)
- Custom role creation
- Advanced notifications (push, SMS)
- Mobile app native features
- Offline mode
- File upload integration
- Advanced reporting
- Calendar integration
- Gantt chart for events
- Resource management
- Budget tracking
- Attendance tracking

---

## 13. User Interface Requirements

### Responsive Design
- Desktop optimized (primary)
- Tablet compatible
- Mobile responsive
- Minimum width: 320px

### Key Screens

#### Authentication
- Login page
- Registration page
- Password reset page
- Email verification page

#### Dashboard (Role-based)
- Overview widgets
- Quick actions
- Recent activity
- Upcoming deadlines
- Notifications

#### Members
- Member list
- Member profile
- Member edit (Admin)
- Promotion history
- Department history

#### Tasks
- Task list (with filters)
- Task detail view
- Create task form
- Edit task form
- Task calendar view
- My tasks view

#### Events
- Event list
- Event detail
- Create event form
- Edit event form
- Event timeline view
- Event dashboard
- Meeting management

#### Departments
- Department list
- Department detail
- Department members
- Department tasks
- Department events

#### Templates (Admin)
- Template list
- Template detail
- Create template form
- Edit template form
- Instantiate template wizard

#### Analytics (Admin/Core Team)
- Analytics dashboard
- Task metrics
- Event metrics
- Member metrics
- Export tools

#### Archive (Admin/Core Team)
- Archived items list
- Restore functionality
- Permanent delete (Admin)

#### Settings
- Profile settings
- Password change
- Notification preferences
- Theme settings

---

## 14. Notification System

### Notification Types
- Task assigned
- Task deadline approaching
- Task overdue
- Task completed (to creator)
- Event created (to department members)
- Meeting scheduled
- Meeting reminder (1 day before)
- Role changed
- Department changed
- Mention in notes/comments (future)

### Notification Delivery
- In-app notifications
- Email notifications (optional)
- Notification badge counter
- Notification history

### Notification Preferences
- Enable/disable by type
- Email notification toggle
- Frequency settings

---

## 15. Search & Filter Functionality

### Global Search
- Search across tasks, events, members
- Real-time search results
- Search by title, description, ID
- Role-based result filtering

### Task Filters
- By status
- By department
- By assigned member
- By deadline range
- By creator
- By related event

### Event Filters
- By status
- By department
- By date range
- By creator

### Member Filters
- By role
- By department
- By status (active/archived)
- By join date range

---

## 16. Validation Rules

### Member Validation
- Name: Required, 2-50 characters
- Email: Required, valid email format, unique
- Password: Min 8 characters, uppercase, lowercase, number
- Role: Required, valid role enum
- Department: Required for Members and Managers

### Task Validation
- Title: Required, 3-100 characters
- Description: Optional, max 1000 characters
- Deadline: Required, future date
- At least one assignment (member/department/role)
- Valid Google Drive links

### Event Validation
- Title: Required, 3-100 characters
- Description: Optional, max 2000 characters
- Start Date: Required, future date (for new events)
- End Date: Required, after start date
- At least one department assigned

### Department Validation
- Name: Required, 3-50 characters, unique
- Description: Optional, max 500 characters
- Manager: Required, must be active member

---

## 17. Error Handling

### User-Facing Errors
- Clear error messages
- Actionable guidance
- No technical jargon
- Validation errors inline

### System Errors
- Graceful degradation
- Error logging to Firebase
- User notification of issue
- Retry mechanisms

### Network Errors
- Offline detection
- Connection loss handling
- Automatic retry
- User feedback

---

## 18. Performance Requirements

### Target Metrics
- Initial load: < 3 seconds
- Page navigation: < 1 second
- Search results: < 500ms
- Dashboard load: < 2 seconds

### Optimization Strategies
- Lazy loading
- Pagination (25-50 items per page)
- Image optimization
- Caching strategies
- Efficient Firestore queries
- Index optimization

---

## 19. Security Requirements

### Authentication Security
- Secure password storage (Firebase Auth)
- Session timeout (30 minutes inactivity)
- Password reset flow
- Email verification required

### Authorization Security
- Role-based security rules in Firestore
- Backend validation of all permissions
- No client-side only security
- Audit logging of sensitive actions

### Data Security
- HTTPS only
- Secure Firebase configuration
- Environment variables for secrets
- No sensitive data in client storage
- XSS prevention
- CSRF protection

---

## 20. Accessibility Requirements

### WCAG 2.1 Level AA Compliance
- Keyboard navigation
- Screen reader support
- Sufficient color contrast
- Focus indicators
- Alt text for images
- Semantic HTML
- ARIA labels where needed

### User Experience
- Clear navigation
- Consistent UI patterns
- Helpful error messages
- Loading indicators
- Success confirmations
- Undo functionality (where applicable)

---

## Summary

This document outlines all core functionalities for the Club Management Platform V1. The system provides comprehensive role-based access control, efficient task and event management, detailed activity logging, and powerful analytics while maintaining data integrity through soft delete mechanisms and audit trails.

**Total Features: 20 major modules**
**Target Users: ~100 concurrent users**
**Technology Stack: Flutter + Firebase**
