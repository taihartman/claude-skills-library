---
name: localization-workflow
description: Systematic workflow for internationalizing applications - ensures all user-facing text is localizable and follows i18n best practices
category: template
framework: any
---

# Localization (i18n) Workflow Template

## Description
This template provides a systematic workflow for internationalizing applications. Proper localization ensures your app can be easily translated and adapted for different languages, regions, and cultures.

## When to Use
- Adding new UI text or labels
- Creating error messages or notifications
- Building forms with user-facing text
- When you see hardcoded strings in code review
- When expanding to new markets/languages
- Setting up a new project with i18n from the start

## Core Philosophy
**Never hardcode user-facing strings.** All text that users see must use your localization system, even if only one language is currently supported. This ensures easy internationalization later and centralizes string management.

## Framework-Specific Implementations

This skill has specific implementations for different frameworks:

### Web Development
- **React**: `react-i18next`, `react-intl`
- **Vue**: `vue-i18n`
- **Angular**: `@angular/localize`, `ngx-translate`

### Mobile Development
- **React Native**: `react-i18next`, `react-native-localize`
- **Flutter**: `flutter_localizations`, `intl`
- **iOS**: `.strings` files, `NSLocalizedString`
- **Android**: `strings.xml` resources

### Backend
- **Node.js**: `i18next`, `node-polyglot`
- **Python**: `gettext`, `Babel`
- **Java**: `ResourceBundle`, `MessageFormat`
- **Ruby**: `i18n` gem
- **Go**: `go-i18n`

## General Workflow

### Step 1: Check if String Already Exists

Before adding a new string, search your localization files:

```bash
# Search for existing strings
grep -ri "cancel" locales/
grep -ri "save" locales/
grep -ri "delete" locales/
```

**Common reusable strings:**
- Cancel, Save, Delete, Edit, Close
- OK, Yes, No
- Loading..., Error, Success
- Required field validation messages

### Step 2: Determine String Category and Naming

Follow consistent naming conventions:

**Common Patterns:**

```
{feature}.{component}.{property}
auth.login.title
auth.login.emailLabel
auth.login.passwordLabel
auth.login.submitButton

{category}.{action}
common.cancel
common.save
validation.required
validation.emailInvalid

{feature}.{action}.{context}
order.create.success
order.create.error
order.delete.confirmTitle
```

**Naming Guidelines:**
- Use dot notation for hierarchy
- Use camelCase or snake_case consistently
- Group related strings with common prefixes
- Use descriptive names (not `button1`, `text2`)

### Step 3: Add String to Localization File

**JSON Format (React, Vue, Node.js):**
```json
{
  "common": {
    "cancel": "Cancel",
    "save": "Save"
  },
  "auth": {
    "login": {
      "title": "Sign In",
      "emailLabel": "Email Address"
    }
  }
}
```

**YAML Format (Ruby, some frameworks):**
```yaml
en:
  common:
    cancel: "Cancel"
    save: "Save"
  auth:
    login:
      title: "Sign In"
      emailLabel: "Email Address"
```

**XML Format (Android):**
```xml
<resources>
    <string name="common_cancel">Cancel</string>
    <string name="common_save">Save</string>
    <string name="auth_login_title">Sign In</string>
</resources>
```

### Step 4: Handle Strings with Parameters

**Simple Parameter:**
```json
{
  "greeting": "Hello, {name}!"
}
```

**Usage:**
```typescript
t('greeting', { name: 'Alice' })
// Output: "Hello, Alice!"
```

**Multiple Parameters:**
```json
{
  "orderSummary": "{count} items for {total}"
}
```

```typescript
t('orderSummary', { count: 5, total: '$49.99' })
// Output: "5 items for $49.99"
```

### Step 5: Handle Pluralization

Different languages have different plural rules. Most i18n libraries support ICU MessageFormat:

```json
{
  "itemCount": {
    "zero": "No items",
    "one": "1 item",
    "other": "{count} items"
  }
}
```

**ICU MessageFormat (recommended):**
```json
{
  "itemCount": "{count, plural, =0 {No items} one {1 item} other {# items}}"
}
```

**Usage:**
```typescript
t('itemCount', { count: 0 })  // "No items"
t('itemCount', { count: 1 })  // "1 item"
t('itemCount', { count: 5 })  // "5 items"
```

### Step 6: Handle Date/Time/Currency Formatting

Use built-in formatters for locale-aware formatting:

**Dates:**
```typescript
// Using Intl.DateTimeFormat
const formatter = new Intl.DateTimeFormat(locale, {
  year: 'numeric',
  month: 'long',
  day: 'numeric'
});
formatter.format(date);
// en-US: "January 15, 2025"
// es-ES: "15 de enero de 2025"
```

**Currency:**
```typescript
// Using Intl.NumberFormat
const formatter = new Intl.NumberFormat(locale, {
  style: 'currency',
  currency: 'USD'
});
formatter.format(1234.56);
// en-US: "$1,234.56"
// de-DE: "1.234,56 $"
```

### Step 7: Use Strings in Code

**React Example:**
```typescript
import { useTranslation } from 'react-i18next';

function LoginForm() {
  const { t } = useTranslation();

  return (
    <form>
      <h1>{t('auth.login.title')}</h1>
      <input placeholder={t('auth.login.emailLabel')} />
      <button>{t('common.save')}</button>
    </form>
  );
}
```

**Vue Example:**
```vue
<template>
  <form>
    <h1>{{ $t('auth.login.title') }}</h1>
    <input :placeholder="$t('auth.login.emailLabel')" />
    <button>{{ $t('common.save') }}</button>
  </form>
</template>
```

## File Organization

### Small Projects
```
locales/
├── en.json
├── es.json
└── fr.json
```

### Large Projects (split by feature)
```
locales/
├── en/
│   ├── common.json
│   ├── auth.json
│   ├── dashboard.json
│   └── settings.json
├── es/
│   ├── common.json
│   ├── auth.json
│   └── ...
```

## Common Patterns

### Pattern 1: Form Validation
```json
{
  "validation": {
    "required": "{field} is required",
    "email": "Please enter a valid email",
    "minLength": "{field} must be at least {min} characters",
    "maxLength": "{field} must be no more than {max} characters"
  }
}
```

### Pattern 2: Confirmation Dialogs
```json
{
  "confirm": {
    "delete": {
      "title": "Delete {item}?",
      "message": "This action cannot be undone.",
      "confirmButton": "Delete",
      "cancelButton": "Cancel"
    }
  }
}
```

### Pattern 3: Error Messages
```json
{
  "errors": {
    "generic": "Something went wrong. Please try again.",
    "network": "Network error. Please check your connection.",
    "notFound": "{resource} not found",
    "unauthorized": "You don't have permission to do that"
  }
}
```

## Best Practices

**✅ DO:**
- Externalize ALL user-facing strings
- Use parameters instead of string concatenation
- Use plural forms for count-based strings
- Use locale-aware date/time/currency formatting
- Group related strings with common prefixes
- Provide context in string keys (`login.emailLabel` not just `email`)
- Keep fallback language complete (usually English)
- Use professional translation services for production

**❌ DON'T:**
- Never hardcode user-facing strings
- Don't concatenate translated strings
  - ❌ `t('hello') + ' ' + name` (breaks in some languages)
  - ✅ `t('greeting', { name })` (proper parameterization)
- Don't assume English pluralization rules apply to all languages
- Don't translate programmatic strings (API keys, IDs, etc.)
- Don't use string keys as display text (`t('Save')` ❌, `t('common.save')` ✅)
- Don't forget to handle RTL languages (Arabic, Hebrew)
- Don't hardcode date/number formats

## Testing Localization

### Test Coverage
```typescript
describe('Localization', () => {
  it('displays all required strings in English', () => {
    // Verify no missing keys
  });

  it('displays all required strings in Spanish', () => {
    // Verify completeness
  });

  it('handles pluralization correctly', () => {
    expect(t('itemCount', { count: 0 })).toBe('No items');
    expect(t('itemCount', { count: 1 })).toBe('1 item');
    expect(t('itemCount', { count: 5 })).toBe('5 items');
  });
});
```

### Missing Translation Detection
```typescript
// Warn on missing translations in development
i18n.on('missingKey', (locale, namespace, key) => {
  console.warn(`Missing translation: ${locale}.${namespace}.${key}`);
});
```

## Adding New Languages

### Step 1: Create Translation File
Create new locale file (e.g., `es.json` for Spanish)

### Step 2: Translate Strings
- Use professional translators for production
- Tools: Crowdin, Lokalise, POEditor
- Maintain translation memory for consistency

### Step 3: Configure Application
Add new locale to supported locales list

### Step 4: Test
- Verify completeness (no missing keys)
- Test UI layout (some languages are longer)
- Test RTL layout if applicable
- Test number/date formatting

## Framework-Specific Examples

### React (react-i18next)
```typescript
// i18n.ts
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';

i18n
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: require('./locales/en.json') },
      es: { translation: require('./locales/es.json') },
    },
    lng: 'en',
    fallbackLng: 'en',
    interpolation: { escapeValue: false },
  });

export default i18n;
```

### Flutter
```dart
// l10n.yaml
arb-dir: lib/l10n
template-arb-file: app_en.arb
output-localization-file: app_localizations.dart

// Usage
Text(AppLocalizations.of(context)!.commonSave)
```

### Vue (vue-i18n)
```typescript
import { createI18n } from 'vue-i18n';

const i18n = createI18n({
  locale: 'en',
  fallbackLocale: 'en',
  messages: {
    en: require('./locales/en.json'),
    es: require('./locales/es.json'),
  },
});
```

## Troubleshooting

**Problem**: Strings not updating after editing translation files
- **Solution**: Restart dev server, clear cache, or rebuild app

**Problem**: Missing translation shows key instead of text
- **Solution**: Check key spelling, ensure locale file is loaded

**Problem**: Parameters not interpolating
- **Solution**: Check parameter syntax matches your i18n library

**Problem**: Plural forms not working correctly
- **Solution**: Use ICU MessageFormat syntax, check plural rules for target language

## Decision Checklist

Before adding a new string:

- [ ] Have I searched for similar existing strings?
- [ ] Am I reusing common strings where appropriate?
- [ ] Does my key follow the naming convention?
- [ ] Am I using parameters instead of concatenation?
- [ ] Do I need pluralization?
- [ ] Have I added the string to the base language file?
- [ ] Have I tested the string displays correctly?
- [ ] Have I considered how this will translate to other languages?

## Additional Considerations

1. **Pseudo-localization**: Test with fake locale to find hardcoded strings
2. **Context**: Provide translator context/comments for ambiguous strings
3. **Screenshots**: Include UI screenshots for translators
4. **String length**: Some languages are 30-40% longer (German, Finnish)
5. **Cultural sensitivity**: Colors, symbols, idioms may not translate culturally
6. **RTL support**: Test with Arabic/Hebrew for layout issues
7. **Legal**: Privacy policies, terms may need legal review per locale

## Success Criteria

Your localization implementation is complete when:
- ✅ No user-facing strings are hardcoded
- ✅ All strings use the localization system
- ✅ Parameters used instead of concatenation
- ✅ Pluralization handled correctly
- ✅ Date/time/currency use locale-aware formatting
- ✅ Missing translation detection in place
- ✅ Easy to add new languages
- ✅ Translation workflow established

---

**Note**: This is a template. Adapt the file formats, naming conventions, and code examples to match your framework and project requirements. The principles remain the same across all platforms.
