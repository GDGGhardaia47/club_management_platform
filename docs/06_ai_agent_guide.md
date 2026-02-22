# AI Agent Working Guide - Club Management Platform

## Purpose
This guide helps AI agents work efficiently on the Club Management Platform with minimal human intervention. It provides context, conventions, and workflows for autonomous development.

---

## Table of Contents
1. [Project Context](#project-context)
2. [Documentation Structure](#documentation-structure)
3. [Development Workflow](#development-workflow)
4. [Code Conventions](#code-conventions)
5. [Common Tasks](#common-tasks)
6. [Decision-Making Framework](#decision-making-framework)
7. [Testing Guidelines](#testing-guidelines)
8. [Troubleshooting](#troubleshooting)

---

## Project Context

### Project Overview
- **Name**: Club Management Platform
- **Type**: Role-Based Web Application
- **Tech Stack**: Flutter (Web) + Firebase
- **Target Users**: ~100 concurrent users
- **Core Features**: Task Management, Event Management, RBAC, Analytics

### Key Documents
All documentation is in `/docs/` folder:
1. `01_functionalities.md` - Complete feature specifications
2. `02_sprint_planning.md` - Development sprints (backend & frontend)
3. `03_architecture.md` - Technical architecture and patterns
4. `04_data_models.md` - Data schemas and models
5. `05_security_rules.md` - Firebase security rules
6. `06_ai_agent_guide.md` - This guide

### Project State
- **Current Phase**: Documentation Complete
- **Next Phase**: Implementation (awaiting user signal)
- **Sprint System**: 14 sprints planned (7 backend + 7 frontend + deployment)

---

## Documentation Structure

### Reading Order for New Tasks
1. **Feature Request** → Read `01_functionalities.md` to understand feature requirements
2. **Architecture Question** → Read `03_architecture.md` for patterns and structure
3. **Data Model** → Read `04_data_models.md` for schemas
4. **Security** → Read `05_security_rules.md` for permissions
5. **Task Planning** → Read `02_sprint_planning.md` for sprint breakdown

### When to Reference Documentation
- **Before implementing a feature**: Check functionalities doc for requirements
- **Before creating a model**: Check data models doc for schema
- **Before writing security logic**: Check security rules doc
- **When uncertain about structure**: Check architecture doc
- **When planning work**: Check sprint planning doc

---

## Development Workflow

### Phase 1: Backend Development (Weeks 1-7)

#### Sprint-by-Sprint Approach
Follow `02_sprint_planning.md` backend sprints:
1. **Sprint 1**: Firebase setup, authentication
2. **Sprint 2**: Data models setup
3. **Sprint 3**: Security rules
4. **Sprint 4-5**: Cloud functions
5. **Sprint 6**: Validation & business logic
6. **Sprint 7**: Testing & optimization

#### Working Pattern
For each backend sprint:
```
1. Read sprint tasks from 02_sprint_planning.md
2. Create all necessary files based on 03_architecture.md structure
3. Implement models from 04_data_models.md
4. Write security rules from 05_security_rules.md
5. Test implementation
6. Document any deviations or issues
7. Move to next sprint only when current is complete
```

### Phase 2: Frontend Development (Weeks 2-12)

#### Sprint-by-Sprint Approach
Follow `02_sprint_planning.md` frontend sprints:
1. **Sprint 1**: Project setup, architecture
2. **Sprint 2**: Authentication UI
3. **Sprint 3**: Core layout & navigation
4. **Sprint 4**: Member & department management
5. **Sprint 5**: Task management
6. **Sprint 6**: Event management
7. **Sprint 7**: Templates & analytics
8. **Sprint 8**: Activity logs & archive
9. **Sprint 9**: Notifications & search
10. **Sprint 10**: Settings & polish
11. **Sprint 11**: Testing & documentation

#### Working Pattern
For each frontend sprint:
```
1. Read sprint tasks from 02_sprint_planning.md
2. Create folder structure per 03_architecture.md
3. Implement UI screens following Flutter best practices
4. Connect to Firebase services
5. Implement state management (Provider)
6. Test all user flows
7. Ensure responsive design
8. Document any UI/UX decisions
```

---

## Code Conventions

### Dart/Flutter Conventions

#### File Naming
- Use snake_case: `member_service.dart`, `task_list_screen.dart`
- Suffix with type: `_service.dart`, `_provider.dart`, `_screen.dart`, `_widget.dart`

#### Class Naming
- Use PascalCase: `MemberService`, `TaskListScreen`, `UserRole`
- Be descriptive: `EventDetailScreen` not `EventScreen`

#### Variable Naming
- Use camelCase: `userId`, `departmentId`, `isLoading`
- Boolean prefix: `isActive`, `hasPermission`, `canEdit`

#### Constants
- Use SCREAMING_SNAKE_CASE: `MAX_TASK_LENGTH`, `DEFAULT_PAGE_SIZE`
- Group in constants files

### Firebase Conventions

#### Collection Names
- Use lowercase plural: `members`, `tasks`, `events`, `departments`
- Subcollections: `activity_logs`, `event_templates`

#### Field Names
- Use camelCase: `createdAt`, `assignedMembers`, `googleDriveLinks`
- Timestamps: Suffix with Date or At: `joinDate`, `createdAt`, `archivedDate`
- References: Suffix with Id: `departmentId`, `managerId`, `createdBy`

#### Cloud Function Naming
- Use camelCase: `createTask`, `promoteMember`, `instantiateTemplate`
- Prefix with action: `create`, `update`, `delete`, `send`, `compute`

### Code Organization

#### Service Classes
```dart
class TaskService {
  final FirebaseFirestore _firestore;
  
  TaskService(this._firestore);
  
  // Public methods
  Future<List<Task>> getTasks() async { }
  Future<Task> getTaskById(String id) async { }
  
  // Private helpers
  Task _fromFirestore(DocumentSnapshot doc) { }
}
```

#### Provider Classes
```dart
class TaskProvider extends ChangeNotifier {
  // Private state
  List<Task> _tasks = [];
  bool _isLoading = false;
  String? _error;
  
  // Public getters
  List<Task> get tasks => _tasks;
  bool get isLoading => _isLoading;
  
  // Public methods
  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();
    // ... load tasks
    _isLoading = false;
    notifyListeners();
  }
}
```

#### Screen Widgets
```dart
class TaskListScreen extends StatefulWidget {
  @override
  _TaskListScreenState createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  @override
  void initState() {
    super.initState();
    // Initialize
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Tasks')),
      body: _buildBody(),
    );
  }
  
  Widget _buildBody() {
    // Build body
  }
}
```

---

## Common Tasks

### Task 1: Add a New Collection

**Steps:**
1. Define schema in `04_data_models.md` format
2. Create Dart model class in `lib/models/`
3. Add to Firestore in Firebase Console
4. Create service class in `lib/services/`
5. Write security rules in `firestore.rules`
6. Create provider in `lib/providers/`
7. Update architecture doc if significant

**Example:**
```dart
// 1. Model
class Department {
  final String id;
  final String name;
  // ... fields
}

// 2. Service
class DepartmentService {
  Future<List<Department>> getDepartments() async { }
}

// 3. Provider
class DepartmentProvider extends ChangeNotifier {
  List<Department> _departments = [];
  // ... state management
}
```

### Task 2: Add a New Screen

**Steps:**
1. Create screen file in appropriate feature folder
2. Add route in `lib/routing/routes.dart`
3. Implement UI following design patterns
4. Connect to provider for state
5. Add navigation from relevant screens
6. Test all user interactions

**Template:**
```dart
class NewFeatureScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Feature')),
      body: Consumer<FeatureProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) return LoadingWidget();
          if (provider.error != null) return ErrorWidget(provider.error);
          return _buildContent(provider);
        },
      ),
    );
  }
}
```

### Task 3: Implement RBAC for a Feature

**Steps:**
1. Check role requirements in `01_functionalities.md`
2. Add permission check in security rules
3. Implement UI role guard
4. Add backend validation in Cloud Function
5. Test all role scenarios

**Pattern:**
```dart
// UI Guard
Widget build(BuildContext context) {
  final role = Provider.of<AuthProvider>(context).currentUser.role;
  
  if (role == UserRole.admin || role == UserRole.coreTeam) {
    return AdminFeature();
  } else {
    return UnauthorizedWidget();
  }
}

// Alternative
RoleGuard(
  allowedRoles: [UserRole.admin, UserRole.coreTeam],
  child: AdminFeature(),
  fallback: UnauthorizedWidget(),
)
```

### Task 4: Add Cloud Function

**Steps:**
1. Create function file in `functions/src/`
2. Implement business logic
3. Add validation
4. Add activity logging
5. Export in `functions/src/index.ts`
6. Test locally with emulator
7. Deploy to Firebase

**Template:**
```typescript
export const myFunction = functions.https.onCall(async (data, context) => {
  // 1. Check authentication
  if (!context.auth) {
    throw new functions.https.HttpsError('unauthenticated', 'User must be authenticated');
  }
  
  // 2. Check authorization
  const userDoc = await admin.firestore().collection('members').doc(context.auth.uid).get();
  const role = userDoc.data()?.role;
  if (role !== 'Admin') {
    throw new functions.https.HttpsError('permission-denied', 'Admin access required');
  }
  
  // 3. Validate input
  if (!data.field) {
    throw new functions.https.HttpsError('invalid-argument', 'Field is required');
  }
  
  // 4. Perform operation
  const result = await performOperation(data);
  
  // 5. Log activity
  await logActivity({
    actionType: 'ACTION_TYPE',
    actorId: context.auth.uid,
    targetId: result.id,
  });
  
  // 6. Return result
  return { success: true, data: result };
});
```

### Task 5: Debug Permission Issue

**Steps:**
1. Check Firestore security rules for collection
2. Verify user authentication state
3. Check user role in database
4. Test permission function in isolation
5. Check if document exists before accessing
6. Enable Firestore logging in app
7. Check Firebase Console logs

**Debugging Pattern:**
```dart
// Log current user
print('User ID: ${FirebaseAuth.instance.currentUser?.uid}');
print('User Email: ${FirebaseAuth.instance.currentUser?.email}');

// Log Firestore operation
FirebaseFirestore.instance.settings = Settings(
  cacheSizeBytes: Settings.CACHE_SIZE_UNLIMITED,
);

// Catch specific errors
try {
  await FirebaseFirestore.instance.collection('tasks').doc('id').get();
} on FirebaseException catch (e) {
  print('Code: ${e.code}');
  print('Message: ${e.message}');
  if (e.code == 'permission-denied') {
    // Handle permission error
  }
}
```

---

## Decision-Making Framework

### When to Ask for Clarification
**ASK when:**
- Requirements are ambiguous or contradictory
- Security implications are unclear
- Design pattern choice affects architecture significantly
- User preference is needed (e.g., UI/UX decisions)
- Breaking changes are required

**DON'T ASK when:**
- Documentation provides clear answer
- Following established patterns
- Implementation details (you decide)
- Standard best practices apply
- Minor styling decisions

### When to Deviate from Documentation
**ALLOWED deviations:**
- Bug fixes that improve functionality
- Performance optimizations
- Better error handling
- Improved user experience (non-breaking)
- Security enhancements

**DOCUMENT deviation:**
- Create comment in code explaining why
- Update relevant documentation
- Note in commit message
- Inform user if significant

**REQUIRES approval:**
- Changing data model schemas
- Modifying security rules significantly
- Removing planned features
- Changing tech stack
- Major architecture changes

### Default Choices

#### State Management
- **Default**: Provider
- **Alternative**: Riverpod (if complexity increases)
- **When**: Simpler state → Provider, Complex state → Riverpod

#### UI Framework
- **Default**: Material Design
- **Customization**: Follow theme from `03_architecture.md`
- **Responsive**: Use LayoutBuilder, MediaQuery

#### Error Handling
- **Default**: Try-catch with Result<T> type
- **UI**: Show user-friendly messages
- **Logging**: Log all errors to console/Firebase

#### Form Validation
- **Default**: flutter_form_builder or manual
- **Pattern**: Validate on submit + show inline errors
- **Required**: All user inputs must be validated

---

## Testing Guidelines

### Unit Tests (Target: 80% backend coverage)

**What to test:**
- All models serialization/deserialization
- All service methods
- All providers state changes
- All utility functions
- All validators

**Pattern:**
```dart
void main() {
  group('TaskService', () {
    late TaskService service;
    late MockFirestore mockFirestore;
    
    setUp(() {
      mockFirestore = MockFirestore();
      service = TaskService(mockFirestore);
    });
    
    test('getTasks returns list of tasks', () async {
      // Arrange
      when(mockFirestore.collection('tasks').get())
          .thenAnswer((_) async => mockQuerySnapshot);
      
      // Act
      final result = await service.getTasks();
      
      // Assert
      expect(result, isA<List<Task>>());
      expect(result.length, 2);
    });
  });
}
```

### Widget Tests (Target: 70% frontend coverage)

**What to test:**
- All screens render correctly
- Button clicks trigger actions
- Form submissions work
- Navigation works
- Error states display correctly
- Loading states display correctly

**Pattern:**
```dart
void main() {
  testWidgets('TaskListScreen displays tasks', (tester) async {
    // Arrange
    final mockProvider = MockTaskProvider();
    when(mockProvider.tasks).thenReturn([testTask1, testTask2]);
    
    // Act
    await tester.pumpWidget(
      MaterialApp(
        home: ChangeNotifierProvider<TaskProvider>.value(
          value: mockProvider,
          child: TaskListScreen(),
        ),
      ),
    );
    
    // Assert
    expect(find.text('Test Task 1'), findsOneWidget);
    expect(find.text('Test Task 2'), findsOneWidget);
  });
}
```

### Integration Tests

**What to test:**
- Complete user flows (login → create task → complete task)
- Authentication flow
- CRUD operations
- Role-based access

**Pattern:**
```dart
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  
  testWidgets('Complete task creation flow', (tester) async {
    // Setup
    await Firebase.initializeApp();
    
    // Launch app
    await tester.pumpWidget(MyApp());
    
    // Login
    await tester.enterText(find.byKey(Key('email')), 'test@test.com');
    await tester.enterText(find.byKey(Key('password')), 'password');
    await tester.tap(find.byKey(Key('login')));
    await tester.pumpAndSettle();
    
    // Navigate to tasks
    await tester.tap(find.byIcon(Icons.assignment));
    await tester.pumpAndSettle();
    
    // Create task
    await tester.tap(find.byKey(Key('create_task')));
    await tester.pumpAndSettle();
    
    // Fill form
    await tester.enterText(find.byKey(Key('title')), 'New Task');
    await tester.tap(find.byKey(Key('submit')));
    await tester.pumpAndSettle();
    
    // Verify
    expect(find.text('New Task'), findsOneWidget);
  });
}
```

---

## Troubleshooting

### Common Issues and Solutions

#### Issue 1: Firebase Not Initialized
**Error**: `[core/no-app] No Firebase App '[DEFAULT]' has been created`

**Solution:**
```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}
```

#### Issue 2: Permission Denied in Firestore
**Error**: `[cloud_firestore/permission-denied]`

**Solutions:**
1. Check security rules in `firestore.rules`
2. Verify user is authenticated
3. Verify user role is correct
4. Check if document exists
5. Test with Firestore Rules Playground

#### Issue 3: State Not Updating
**Error**: UI not refreshing after data change

**Solutions:**
1. Ensure `notifyListeners()` called in Provider
2. Wrap widget with `Consumer<Provider>`
3. Check if provider is provided in widget tree
4. Verify provider is not recreated unnecessarily

#### Issue 4: Build Errors After Adding Dependencies
**Error**: Dependency conflicts

**Solutions:**
```bash
flutter pub get
flutter pub upgrade
flutter clean
flutter pub get
```

#### Issue 5: Firebase Functions Timeout
**Error**: Function execution timeout

**Solutions:**
1. Increase timeout in function config
2. Optimize function logic
3. Use batch operations
4. Implement caching
5. Split into smaller functions

### Debugging Checklist

Before asking for help, verify:
- [ ] Documentation has been consulted
- [ ] Error messages are read and understood
- [ ] Code follows conventions
- [ ] Dependencies are up to date
- [ ] Clean build attempted
- [ ] Firebase configuration is correct
- [ ] Security rules are correct for operation
- [ ] User authentication is valid
- [ ] Test data exists in Firestore
- [ ] Console logs checked for additional info

---

## Workflow Summary

### Starting a New Sprint
```
1. Open 02_sprint_planning.md
2. Identify current sprint tasks
3. Read related sections in other docs
4. Create necessary file structure
5. Implement features following conventions
6. Test thoroughly
7. Document any issues
8. Mark sprint complete
9. Move to next sprint
```

### Implementing a Feature
```
1. Read requirement in 01_functionalities.md
2. Check data model in 04_data_models.md
3. Check security in 05_security_rules.md
4. Follow architecture in 03_architecture.md
5. Write code following conventions
6. Add tests
7. Test manually
8. Document if needed
```

### Fixing a Bug
```
1. Reproduce the bug
2. Identify root cause
3. Check if it violates documentation
4. Implement fix
5. Add test to prevent regression
6. Verify fix works
7. Document if complex
```

### Adding New Functionality
```
1. Check if it aligns with project goals
2. Document requirement
3. Update data models if needed
4. Update security rules if needed
5. Implement feature
6. Add tests
7. Update architecture doc
8. Update sprint plan if needed
```

---

## Best Practices for AI Agents

### Do's
✅ **Read documentation first** before implementing  
✅ **Follow established patterns** consistently  
✅ **Write tests** for all new code  
✅ **Document decisions** in comments  
✅ **Handle errors** gracefully  
✅ **Validate all inputs**  
✅ **Use type safety** (Dart null safety)  
✅ **Check security implications**  
✅ **Test across roles** (Member, Manager, Core, Admin)  
✅ **Keep functions small** and focused  
✅ **Use meaningful names** for clarity  
✅ **Log important actions**  
✅ **Cache when appropriate**  

### Don'ts
❌ **Don't skip documentation** reading  
❌ **Don't make breaking changes** without approval  
❌ **Don't ignore security** considerations  
❌ **Don't hardcode values** that should be configurable  
❌ **Don't commit commented code** (remove it)  
❌ **Don't skip error handling**  
❌ **Don't skip validation**  
❌ **Don't expose sensitive data** in logs  
❌ **Don't bypass security rules**  
❌ **Don't create multiple providers** for same data  
❌ **Don't forget to update** documentation  

---

## Quick Reference

### File Structure Quick Lookup
```
Backend:
- Models: lib/models/[model_name]_model.dart
- Services: lib/services/[feature]_service.dart
- Security: firestore.rules
- Functions: functions/src/[feature]/[function_name].ts

Frontend:
- Screens: lib/features/[feature]/screens/[screen_name]_screen.dart
- Widgets: lib/features/[feature]/widgets/[widget_name].dart
- Providers: lib/providers/[feature]_provider.dart
- Routes: lib/routing/routes.dart
```

### Common Commands
```bash
# Flutter
flutter run -d chrome              # Run web app
flutter test                        # Run tests
flutter analyze                     # Analyze code
flutter clean                       # Clean build
flutter pub get                     # Get dependencies

# Firebase
firebase init                       # Initialize project
firebase emulators:start            # Start emulators
firebase deploy                     # Deploy all
firebase deploy --only firestore    # Deploy rules
firebase deploy --only functions    # Deploy functions
```

### Key Concepts
- **RBAC**: Role-Based Access Control (Member < Manager < CoreTeam < Admin)
- **Soft Delete**: Set archived=true instead of actual deletion
- **Activity Logging**: Log all significant actions automatically
- **Provider**: State management pattern used throughout
- **Cloud Functions**: Server-side logic for complex operations
- **Security Rules**: Firestore-level access control

---

## Summary

This guide provides:
- **Complete context** for autonomous work
- **Clear conventions** to follow
- **Decision-making framework** for independence
- **Common patterns** for consistency
- **Troubleshooting steps** for self-resolution
- **Best practices** for quality code

By following this guide, AI agents can work efficiently on the project with minimal human intervention while maintaining quality and consistency.

**Remember**: When in doubt, consult the documentation first. If still unclear, ask specific questions rather than making assumptions.
