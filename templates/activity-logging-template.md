---
name: activity-logging
description: Systematic workflow for adding audit trail/activity logging to state-changing operations - ensures transparency and debugging capability
category: template
framework: any
---

# Activity Logging Template

## Description
This template provides a systematic workflow for adding comprehensive activity logging to state-changing operations. Activity logging creates an audit trail for transparency, debugging, and compliance.

## When to Use
- Adding new state-changing operations (Create/Update/Delete)
- Implementing audit trail requirements
- Building features that need user action tracking
- Debugging user-reported issues
- Compliance/regulatory requirements

## Core Philosophy
**Every state-changing operation SHOULD include activity logging** for transparency and audit purposes. Activity logging is:
- **Non-fatal**: Logging failures should never break the main operation
- **Optional**: Make logging services optional for testing
- **Descriptive**: Use clear descriptions and rich metadata

## Customization Checklist

Before using this skill in your project, customize:

- [ ] **Activity Types** - Define your activity type enum/constants
- [ ] **Actor Identification** - How do you identify who performed the action?
- [ ] **Storage Layer** - Where do activity logs get stored? (DB, file, service)
- [ ] **Repository Pattern** - Adapt to your project's data access pattern
- [ ] **Metadata Structure** - What context do you need to track?
- [ ] **UI Display** - How are activity logs displayed to users?

## General Workflow

### Step 1: Define Activity Types

Create an enum, constants, or type system for your activity types:

**Examples**:
```typescript
// TypeScript
enum ActivityType {
  ENTITY_CREATED = 'entity_created',
  ENTITY_UPDATED = 'entity_updated',
  ENTITY_DELETED = 'entity_deleted',
  STATUS_CHANGED = 'status_changed',
}
```

```python
# Python
from enum import Enum

class ActivityType(Enum):
    ENTITY_CREATED = "entity_created"
    ENTITY_UPDATED = "entity_updated"
    ENTITY_DELETED = "entity_deleted"
    STATUS_CHANGED = "status_changed"
```

```dart
// Dart/Flutter
enum ActivityType {
  entityCreated,
  entityUpdated,
  entityDeleted,
  statusChanged,
}
```

### Step 2: Create Activity Log Model

Define the structure of your activity logs:

```typescript
interface ActivityLog {
  id: string;
  type: ActivityType;
  actorId: string;         // Who performed the action
  actorName?: string;      // Human-readable name (optional)
  entityId: string;        // What was affected
  entityType: string;      // Type of entity
  description: string;     // Human-readable description
  timestamp: Date;
  metadata?: Record<string, any>; // Additional context
}
```

### Step 3: Inject Logging Service/Repository

Make the logging service **optional** in your business logic layer:

**Dependency Injection Pattern**:
```typescript
class EntityService {
  constructor(
    private entityRepository: EntityRepository,
    private activityLogger?: ActivityLogger, // Optional
  ) {}
}
```

**Why optional?**
- Makes testing easier
- Prevents errors if logging service is unavailable
- Non-fatal failures don't break main operations

### Step 4: Get Current User/Actor

Always identify WHO performed the action:

```typescript
// Example: Get from authentication context
const currentUser = await authService.getCurrentUser();
const actorId = currentUser.id;
const actorName = currentUser.name;
```

**IMPORTANT**:
- Get actor from authentication/session context
- Don't use entity owner/creator as actor
- Actor = "who performed THIS action"

### Step 5: Log After Successful Operation

```typescript
async function deleteEntity(entityId: string, actorId: string): Promise<void> {
  try {
    // 1. Perform the main operation FIRST
    const entity = await this.entityRepository.findById(entityId);
    await this.entityRepository.delete(entityId);

    // 2. Log activity (non-fatal, in try-catch)
    if (this.activityLogger) {
      try {
        await this.activityLogger.log({
          type: ActivityType.ENTITY_DELETED,
          actorId: actorId,
          entityId: entityId,
          entityType: 'Entity',
          description: `Deleted ${entity.name}`,
          timestamp: new Date(),
          metadata: {
            entityName: entity.name,
            // ... other relevant details
          },
        });
      } catch (error) {
        // Log the error but don't throw - logging failures shouldn't break operations
        console.warn('Failed to log activity:', error);
      }
    }

    // 3. Return success
  } catch (error) {
    // Main operation failed - DON'T log activity
    throw error;
  }
}
```

### Step 6: Add Rich Metadata (Optional but Recommended)

For better audit trails, include relevant context:

```typescript
metadata: {
  entityId: entity.id,
  oldValue: oldEntity.value,
  newValue: newEntity.value,
  changedFields: ['name', 'status'],
  ipAddress: request.ip,
  userAgent: request.headers['user-agent'],
}
```

## Key Patterns

### Pattern 1: Simple Operation
```typescript
async createEntity(entity: Entity, actorId: string): Promise<Entity> {
  const created = await this.repository.create(entity);

  await this.logActivity({
    type: ActivityType.ENTITY_CREATED,
    actorId,
    entityId: created.id,
    description: `Created ${entity.name}`,
  });

  return created;
}
```

### Pattern 2: Complex Edit with Change Detection
```typescript
async updateEntity(entityId: string, updates: Partial<Entity>, actorId: string): Promise<Entity> {
  const oldEntity = await this.repository.findById(entityId);
  const updated = await this.repository.update(entityId, updates);

  const changes = detectChanges(oldEntity, updated);

  await this.logActivity({
    type: ActivityType.ENTITY_UPDATED,
    actorId,
    entityId,
    description: `Updated ${updated.name}`,
    metadata: { changes },
  });

  return updated;
}
```

## Best Practices

**✅ DO:**
- Make logging services optional (for testing and reliability)
- Get actor from authentication context (not from entity relationships)
- Log AFTER successful operation (failed operations shouldn't be logged)
- Wrap logging in try-catch (logging failures should never break main operations)
- Use clear, descriptive text
- Store relevant details in metadata
- Log synchronously if audit trail is critical, async if it's for debugging

**❌ DON'T:**
- Don't fail operations if activity logging fails
- Don't log before the operation succeeds
- Don't require logging services (make them optional)
- Don't use entity owner/creator as actor
- Don't log sensitive information (passwords, tokens, etc.)
- Don't create audit logs that users can delete

## Testing

### Testing WITH activity logging:
```typescript
const mockLogger = createMock<ActivityLogger>();
const service = new EntityService(repository, mockLogger);

await service.deleteEntity(entityId, actorId);

expect(mockLogger.log).toHaveBeenCalledWith(
  expect.objectContaining({
    type: ActivityType.ENTITY_DELETED,
    actorId,
  })
);
```

### Testing WITHOUT activity logging:
```typescript
const service = new EntityService(repository); // No logger

// Should still work
await service.deleteEntity(entityId, actorId);
```

## Storage Considerations

**Database Table/Collection**:
```sql
CREATE TABLE activity_logs (
  id UUID PRIMARY KEY,
  type VARCHAR(50) NOT NULL,
  actor_id UUID NOT NULL,
  actor_name VARCHAR(255),
  entity_id UUID NOT NULL,
  entity_type VARCHAR(50) NOT NULL,
  description TEXT NOT NULL,
  timestamp TIMESTAMP NOT NULL,
  metadata JSONB,
  INDEX idx_entity (entity_id, timestamp),
  INDEX idx_actor (actor_id, timestamp)
);
```

**Retention Policy**:
- Consider data retention requirements
- Implement archival for old logs
- Balance detail vs. storage costs

## Display UI Patterns

**Activity Feed**:
```
[Icon] Actor performed action on Entity
       Description of what changed
       2 hours ago
```

**Example**:
```
[📝] Alice Johnson edited Project Alpha
     Changed status from "In Progress" to "Completed"
     2 hours ago
```

## Additional Considerations

1. **Performance**: Async logging for non-critical audit trails
2. **Privacy**: Don't log sensitive user data (PII, passwords, etc.)
3. **Compliance**: Check if regulations require immutable audit logs
4. **Search**: Index by actor, entity, timestamp for filtering
5. **Security**: Prevent users from deleting their own activity logs

## Customization Example

This is a TEMPLATE. Here's how you'd adapt it:

**For a Todo App**:
- Activity types: `TODO_CREATED`, `TODO_COMPLETED`, `TODO_DELETED`
- Actor: Current logged-in user
- Entity: Todo item
- Metadata: Previous status, assigned user, due date changes

**For an E-commerce System**:
- Activity types: `ORDER_PLACED`, `ORDER_SHIPPED`, `ORDER_CANCELLED`
- Actor: Customer or admin user
- Entity: Order ID
- Metadata: Order total, items, shipping address changes

**For a CMS**:
- Activity types: `ARTICLE_PUBLISHED`, `ARTICLE_EDITED`, `COMMENT_APPROVED`
- Actor: Content editor
- Entity: Article/Comment ID
- Metadata: Content diffs, approval workflow state

## Success Criteria

Your activity logging implementation is complete when:
- ✅ All state-changing operations include logging
- ✅ Logging is optional and non-fatal
- ✅ Actor identification is clear and consistent
- ✅ Metadata provides useful debugging context
- ✅ Tests cover both with and without logging
- ✅ UI displays activity logs (if user-facing)
- ✅ Storage has appropriate indexes and retention policy

## Related Patterns

- **Event Sourcing**: More comprehensive, stores all state changes as events
- **Audit Logging**: Similar, but often stricter compliance requirements
- **Change Data Capture**: Database-level change tracking
- **Command Pattern**: Can integrate activity logging at command execution

---

**Note**: This is a template. Adapt the code examples, patterns, and structure to match your project's architecture, language, and requirements.
