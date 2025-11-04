---
name: specialized-input
description: Create reusable, validated input components for domain-specific data types (currency, phone, date, credit card, etc.)
category: template
framework: any
---

# Specialized Input Component Template

## Description
This template provides a systematic workflow for creating reusable, validated input components for domain-specific data types. Instead of using generic text fields, create specialized components that handle formatting, validation, and user experience automatically.

## When to Use
- Adding forms with domain-specific inputs (currency, phone, date, etc.)
- When you see plain text fields for structured data
- Creating consistent UX for repeated input types
- Implementing complex input validation and formatting
- Building component libraries

## Core Philosophy
**ALWAYS use specialized components for domain-specific inputs.** Never use plain text fields for structured data like currency, phone numbers, dates, or credit cards. Specialized components ensure consistent formatting, validation, and user experience.

## Common Specialized Input Types

| Input Type | Examples | Key Features |
|------------|----------|--------------|
| **Currency** | Money amounts | Thousand separators, currency symbols, decimal places |
| **Phone** | Phone numbers | Country code, formatting, validation |
| **Date/Time** | Dates, timestamps | Calendar picker, format localization, timezone |
| **Credit Card** | Payment cards | Masking, Luhn validation, card type detection |
| **SSN/Tax ID** | National IDs | Masking, format validation, regional rules |
| **Email** | Email addresses | Format validation, domain checking |
| **URL** | Web addresses | Protocol handling, validation |
| **Percentage** | Rates, discounts | Bounds checking, decimal places |
| **Quantity** | Inventory, counts | Integer validation, min/max |
| **Color** | Color codes | Picker UI, format conversion (hex/rgb) |

## General Workflow

### Step 1: Define Component Requirements

**Ask yourself:**
- What data type am I capturing? (currency, phone, date, etc.)
- What format should it display in?
- What validation rules apply?
- Are there locale/regional variations?
- What's the input vs. display format?
- What error states exist?

**Example: Currency Input**
- Data type: Monetary amount
- Display format: "1,234.56" (with thousand separators)
- Storage format: Decimal/BigDecimal
- Validation: Must be positive number, max decimal places
- Regional: Different decimal places per currency (USD=2, VND=0)
- Errors: Empty, negative, invalid number

### Step 2: Create Input Formatter

Build a formatter that handles:
- **Input filtering**: What characters are allowed?
- **Live formatting**: Update display as user types
- **Value parsing**: Convert display → data format
- **Value formatting**: Convert data → display format

**Example: Currency Formatter Pseudocode**
```typescript
class CurrencyFormatter {
  constructor(currencyCode, decimalPlaces) {
    this.currencyCode = currencyCode;
    this.decimalPlaces = decimalPlaces;
  }

  // Format for display (add thousand separators)
  format(value: number): string {
    return value.toLocaleString('en-US', {
      minimumFractionDigits: this.decimalPlaces,
      maximumFractionDigits: this.decimalPlaces,
    });
  }

  // Parse from user input (remove formatting)
  parse(input: string): number | null {
    const cleaned = input.replace(/[^0-9.]/g, '');
    return cleaned ? parseFloat(cleaned) : null;
  }

  // Filter input (only allow valid characters)
  filter(input: string): string {
    if (this.decimalPlaces === 0) {
      return input.replace(/[^0-9]/g, '');
    } else {
      return input.replace(/[^0-9.]/g, '');
    }
  }
}
```

### Step 3: Build the Component

**Component Structure:**
```
SpecializedInput
├── Props/Config
│   ├── value (data format)
│   ├── onChange callback
│   ├── validation rules
│   ├── label/placeholder
│   └── error state
├── Formatter
│   ├── format()
│   ├── parse()
│   └── validate()
└── UI
    ├── Input field
    ├── Prefix/suffix icons
    ├── Error message
    └── Helper text
```

**React Example:**
```typescript
interface CurrencyInputProps {
  value: number | null;
  currencyCode: string;
  onChange: (value: number | null) => void;
  label?: string;
  error?: string;
  required?: boolean;
  minValue?: number;
  maxValue?: number;
}

function CurrencyInput({
  value,
  currencyCode,
  onChange,
  label,
  error,
  required = false,
  minValue = 0,
  maxValue,
}: CurrencyInputProps) {
  const [displayValue, setDisplayValue] = useState('');
  const formatter = useMemo(
    () => new CurrencyFormatter(currencyCode),
    [currencyCode]
  );

  // Initialize display value from prop
  useEffect(() => {
    if (value !== null) {
      setDisplayValue(formatter.format(value));
    }
  }, [value, formatter]);

  const handleChange = (e: ChangeEvent<HTMLInputElement>) => {
    const input = e.target.value;
    const filtered = formatter.filter(input);
    setDisplayValue(filtered);

    const parsed = formatter.parse(filtered);
    onChange(parsed);
  };

  const handleBlur = () => {
    // Format on blur for clean display
    if (displayValue) {
      const parsed = formatter.parse(displayValue);
      if (parsed !== null) {
        setDisplayValue(formatter.format(parsed));
      }
    }
  };

  return (
    <div className="currency-input">
      <label>
        {label} {required && '*'}
      </label>
      <div className="input-wrapper">
        <span className="currency-symbol">
          {getCurrencySymbol(currencyCode)}
        </span>
        <input
          type="text"
          inputMode="decimal"
          value={displayValue}
          onChange={handleChange}
          onBlur={handleBlur}
          placeholder="0.00"
        />
      </div>
      {error && <span className="error">{error}</span>}
    </div>
  );
}
```

### Step 4: Add Validation

Built-in validation makes the component self-contained:

```typescript
function validate(
  value: number | null,
  rules: ValidationRules
): string | null {
  if (rules.required && value === null) {
    return 'This field is required';
  }

  if (value !== null) {
    if (rules.minValue !== undefined && value < rules.minValue) {
      return `Must be at least ${rules.minValue}`;
    }

    if (rules.maxValue !== undefined && value > rules.maxValue) {
      return `Must be no more than ${rules.maxValue}`;
    }
  }

  return null; // Valid
}
```

### Step 5: Handle Edge Cases

**Common edge cases:**
- Empty input (should return null, not 0)
- Negative numbers (allow or prevent?)
- Partial input (user typing decimal point)
- Copy/paste with formatting
- Leading zeros
- Multiple decimal points
- Currency symbol in input
- IME/international input methods

**Example: Handling Partial Input**
```typescript
// Don't validate while user is typing
const [isTyping, setIsTyping] = useState(false);

const handleChange = (input: string) => {
  setIsTyping(true);
  // Allow partial input like "12." while typing
};

const handleBlur = () => {
  setIsTyping(false);
  // Validate and format on blur
};
```

### Step 6: Support Localization

Different regions have different formats:

```typescript
// US: 1,234.56
// EU: 1.234,56
// India: 1,23,456.78

class LocalizedCurrencyFormatter {
  constructor(currencyCode: string, locale: string) {
    this.formatter = new Intl.NumberFormat(locale, {
      style: 'currency',
      currency: currencyCode,
    });
  }

  format(value: number): string {
    return this.formatter.format(value);
  }
}
```

## Framework-Specific Examples

### React
```typescript
// Controlled component with state management
const [amount, setAmount] = useState<number | null>(null);

<CurrencyInput
  value={amount}
  currencyCode="USD"
  onChange={setAmount}
  label="Amount"
  required
  minValue={0}
/>
```

### Vue
```vue
<template>
  <CurrencyInput
    v-model="amount"
    :currency-code="currency"
    label="Amount"
    :required="true"
  />
</template>

<script setup lang="ts">
import { ref } from 'vue';
const amount = ref<number | null>(null);
const currency = ref('USD');
</script>
```

### Flutter
```dart
CurrencyTextField(
  controller: _amountController,
  currencyCode: CurrencyCode.usd,
  label: 'Amount',
  onChanged: (value) {
    setState(() => _amount = value);
  },
  validator: (value) {
    if (value == null) return 'Required';
    if (value <= 0) return 'Must be positive';
    return null;
  },
)
```

### Angular
```typescript
<app-currency-input
  [(ngModel)]="amount"
  [currencyCode]="'USD'"
  [label]="'Amount'"
  [required]="true"
  [minValue]="0">
</app-currency-input>
```

## Common Patterns

### Pattern 1: Pre-filling When Editing

```typescript
// Initialize with existing value
const [amount, setAmount] = useState(expense?.amount || null);

// Component handles formatting automatically
<CurrencyInput
  value={amount}
  currencyCode={expense?.currency || 'USD'}
  onChange={setAmount}
/>
```

### Pattern 2: Form Integration

```typescript
<form onSubmit={handleSubmit}>
  <CurrencyInput
    value={formData.amount}
    onChange={(value) => setFormData({ ...formData, amount: value })}
    error={errors.amount}
  />

  <button type="submit">Save</button>
</form>
```

### Pattern 3: Dependent Inputs

```typescript
// Currency selector changes decimal places
const [currency, setCurrency] = useState('USD');
const [amount, setAmount] = useState<number | null>(null);

<select value={currency} onChange={(e) => setCurrency(e.target.value)}>
  <option value="USD">USD</option>
  <option value="VND">VND</option>
</select>

<CurrencyInput
  value={amount}
  currencyCode={currency} // Automatically updates decimal places
  onChange={setAmount}
/>
```

## Testing Specialized Inputs

### Unit Tests
```typescript
describe('CurrencyInput', () => {
  it('formats input with thousand separators', () => {
    render(<CurrencyInput value={1234.56} currencyCode="USD" />);
    expect(screen.getByDisplayValue('1,234.56')).toBeInTheDocument();
  });

  it('parses user input correctly', () => {
    const onChange = jest.fn();
    render(<CurrencyInput value={null} currencyCode="USD" onChange={onChange} />);

    fireEvent.change(screen.getByRole('textbox'), { target: { value: '1234.56' } });

    expect(onChange).toHaveBeenCalledWith(1234.56);
  });

  it('validates required field', () => {
    render(<CurrencyInput value={null} currencyCode="USD" required />);
    fireEvent.blur(screen.getByRole('textbox'));

    expect(screen.getByText('This field is required')).toBeInTheDocument();
  });
});
```

### E2E Tests
```typescript
test('user can enter currency amount', async ({ page }) => {
  await page.goto('/expense/new');
  await page.fill('[data-testid="amount-input"]', '1234.56');
  await page.blur('[data-testid="amount-input"]');

  // Should format with thousand separator
  await expect(page.locator('[data-testid="amount-input"]')).toHaveValue('1,234.56');
});
```

## Best Practices

**✅ DO:**
- Create specialized components for domain-specific inputs
- Handle formatting automatically (user shouldn't think about it)
- Validate as user types (instant feedback)
- Support copy/paste with formatting
- Use appropriate input modes (`inputMode="decimal"` for numbers)
- Provide clear error messages
- Support keyboard shortcuts (arrow keys, etc.)
- Handle locale/regional variations
- Use semantic HTML (`type="text"` with `inputMode`, not `type="number"`)

**❌ DON'T:**
- Use generic text fields for structured data
- Use `type="number"` for currency (doesn't support formatting)
- Validate before user finishes typing
- Forget about edge cases (empty, partial input)
- Hardcode formats (support localization)
- Ignore accessibility (screen readers, keyboard nav)
- Let invalid input into the data model
- Forget to handle copy/paste

## Component Library Examples

### Material-UI (React)
```typescript
import { TextField } from '@mui/material';

function CurrencyInput(props) {
  return (
    <TextField
      {...props}
      InputProps={{
        startAdornment: <InputAdornment position="start">$</InputAdornment>,
        inputComponent: CurrencyInputFormatter,
      }}
    />
  );
}
```

### Ant Design (React)
```typescript
import { Input } from 'antd';

<Input
  prefix="$"
  value={displayValue}
  onChange={handleChange}
  placeholder="0.00"
/>
```

### Vuetify (Vue)
```vue
<v-text-field
  v-model="displayValue"
  prefix="$"
  label="Amount"
  @change="handleChange"
/>
```

### Flutter Material
```dart
TextField(
  controller: _controller,
  decoration: InputDecoration(
    labelText: 'Amount',
    prefixText: '\$',
  ),
  keyboardType: TextInputType.numberWithOptions(decimal: true),
  inputFormatters: [CurrencyInputFormatter()],
)
```

## Accessibility Considerations

```html
<div className="currency-input">
  <label htmlFor="amount" id="amount-label">
    Amount
  </label>
  <input
    id="amount"
    type="text"
    inputMode="decimal"
    aria-labelledby="amount-label"
    aria-describedby="amount-error amount-hint"
    aria-required="true"
    aria-invalid={!!error}
  />
  <span id="amount-hint" className="hint">
    Enter amount in USD
  </span>
  {error && (
    <span id="amount-error" className="error" role="alert">
      {error}
    </span>
  )}
</div>
```

## Performance Considerations

**Optimization strategies:**
- Debounce validation (not formatting)
- Memoize formatters
- Avoid re-renders on every keystroke
- Use controlled components efficiently
- Lazy-load locale data

```typescript
// Memoize formatter to avoid recreating
const formatter = useMemo(
  () => new CurrencyFormatter(currencyCode),
  [currencyCode]
);

// Debounce expensive validation
const debouncedValidate = useMemo(
  () => debounce((value) => validate(value), 300),
  []
);
```

## Real-World Specialized Input Examples

### Phone Number Input
- Auto-format: (555) 123-4567
- Country code picker
- Validation by region
- Click-to-call on mobile

### Date Picker
- Calendar UI
- Keyboard shortcuts
- Min/max dates
- Disabled dates
- Locale formatting

### Credit Card Input
- Card type detection (Visa, MC, Amex)
- Masking: •••• •••• •••• 1234
- Luhn validation
- Expiry date validation
- CVV field with tooltips

## Troubleshooting

**Problem**: Input shows wrong number of decimal places
- **Solution**: Check currency configuration, ensure formatter uses correct decimal places

**Problem**: User can't type decimal point
- **Solution**: Check input filter isn't blocking "."

**Problem**: Copy/paste includes formatting and breaks validation
- **Solution**: Strip formatting in parse() method

**Problem**: Cursor jumps to end while typing
- **Solution**: Use controlled component properly, maintain cursor position

**Problem**: Input doesn't update when currency changes
- **Solution**: Re-initialize formatter when currency prop changes

## Success Criteria

Your specialized input is complete when:
- ✅ Formats automatically as user types
- ✅ Validates input correctly
- ✅ Handles all edge cases
- ✅ Supports copy/paste
- ✅ Works with keyboard and screen readers
- ✅ Integrates with forms easily
- ✅ Reusable across the app
- ✅ Tested thoroughly
- ✅ Documented with examples

---

**Note**: This is a template. Adapt the code examples, validation rules, and formatting logic to match your specific domain, framework, and requirements. The principles apply to any specialized input type.
