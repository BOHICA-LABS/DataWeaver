# Python Style Guide

## Table of Contents

1. Background
2. Python Language Rules
    - Lint
    - Imports
    - Packages
    - Exceptions
    - Mutable Global State
    - Nested/Local/Inner Classes and Functions
    - Comprehensions & Generator Expressions
    - Default Iterators and Operators
    - Generators
    - Lambda Functions
    - Conditional Expressions
    - Default Argument Values
    - Properties
    - True/False Evaluations
    - Lexical Scoping
    - Function and Method Decorators
    - Threading
    - Power Features
    - Modern Python: from __future__ imports
    - Type Annotated Code
3. Python Style Rules
    - Semicolons
    - Line length
    - Parentheses
    - Indentation
    - Trailing commas in sequences of items
    - Blank Lines
    - Whitespace
    - Shebang Line
    - Comments and Docstrings
    - Strings
    - Logging
    - Error Messages
    - Files, Sockets, and similar Stateful Resources
    - TODO Comments
    - Imports formatting
    - Statements
    - Getters and Setters
    - Naming
    - File Naming
    - Naming Conventions
    - Mathematical Notation
    - Main
    - Function length
4. Interfaces and Implementation Classes

## 1. Background

Python is the main dynamic language used at Google. This style guide is a list of dos and don’ts for Python programs. To help you format code correctly, use tools like Black or Pyink to avoid arguing over formatting.

## 2. Python Language Rules

### 2.1 Lint

Run pylint over your code using the provided pylintrc.

#### 2.1.1 Definition

pylint is a tool for finding bugs and style problems in Python source code.

#### 2.1.2 Pros

Catches easy-to-miss errors like typos and using variables before assignment.

#### 2.1.3 Cons

pylint isn’t perfect. Sometimes we need to write around it, suppress its warnings, or fix it.

#### 2.1.4 Decision

Make sure you run pylint on your code. Suppress warnings if they are inappropriate so that other issues are not hidden.

```python
def do_PUT(self):  # WSGI name, so pylint: disable=invalid-name
    ...
```

### 2.2 Imports

Use import statements for packages and modules only, not for individual types, classes, or functions.

#### 2.2.1 Definition

Reusability mechanism for sharing code from one module to another.

#### 2.2.2 Pros

The namespace management convention is simple. The source of each identifier is indicated in a consistent way.

#### 2.2.3 Cons

Module names can still collide. Some module names are inconveniently long.

#### 2.2.4 Decision

- Use `import x` for importing packages and modules.
- Use `from x import y` where `x` is the package prefix and `y` is the module name with no prefix.
- Use `from x import y as z` in specific circumstances such as naming conflicts or long names.

### 2.3 Packages

Import each module using the full pathname location of the module.

#### 2.3.1 Pros

Avoids conflicts in module names or incorrect imports due to the module search path.

#### 2.3.2 Cons

Makes it harder to deploy code because you have to replicate the package hierarchy.

#### 2.3.3 Decision

All new code should import each module by its full package name.

### 2.4 Exceptions

Exceptions are allowed but must be used carefully.

#### 2.4.1 Definition

Exceptions are a means of breaking out of normal control flow to handle errors or other exceptional conditions.

#### 2.4.2 Pros

The control flow of normal operation code is not cluttered by error-handling code.

#### 2.4.3 Cons

May cause the control flow to be confusing.

#### 2.4.4 Decision

- Use built-in exception classes when appropriate.
- Do not use `assert` statements in place of conditionals.
- Do not use catch-all `except:` statements unless you are re-raising the exception or creating an isolation point in the program where exceptions are recorded and suppressed.

### 2.5 Mutable Global State

Avoid mutable global state.

#### 2.5.1 Definition

Module-level values or class attributes that can get mutated during program execution.

#### 2.5.2 Pros

Occasionally useful.

#### 2.5.3 Cons

Breaks encapsulation and can make module behavior unpredictable.

#### 2.5.4 Decision

Avoid mutable global state. If necessary, declare mutable global entities at the module level or as a class attribute and make them internal by prepending an `_` to the name.

### 2.6 Nested/Local/Inner Classes and Functions

Nested local functions or classes are fine when used to close over a local variable.

#### 2.6.1 Definition

A class or function can be defined inside of another method, function, or class.

#### 2.6.2 Pros

Allows definition of utility classes and functions that are only used inside of a very limited scope.

#### 2.6.3 Cons

Nested functions and classes cannot be directly tested.

#### 2.6.4 Decision

Avoid nested functions or classes except when closing over a local value other than `self` or `cls`. Do not nest a function just to hide it from users of a module.

### 2.7 Comprehensions & Generator Expressions

Okay to use for simple cases.

#### 2.7.1 Definition

Provide a concise way to create container types and iterators without traditional loops.

#### 2.7.2 Pros

Simple comprehensions can be clearer and simpler.

#### 2.7.3 Cons

Complicated comprehensions can be hard to read.

#### 2.7.4 Decision

Comprehensions are allowed, but multiple for clauses or filter expressions are not permitted.

### 2.8 Default Iterators and Operators

Use default iterators and operators for types that support them.

#### 2.8.1 Definition

Container types define default iterators and membership test operators.

#### 2.8.2 Pros

Default iterators and operators are simple and efficient.

#### 2.8.3 Cons

You can’t tell the type of objects by reading the method names.

#### 2.8.4 Decision

Use default iterators and operators for types that support them. Do not mutate a container while iterating over it.

### 2.9 Generators

Use generators as needed.

#### 2.9.1 Definition

A generator function returns an iterator that yields a value each time it executes a `yield` statement.

#### 2.9.2 Pros

Simpler code and less memory usage.

#### 2.9.3 Cons

Local variables in the generator will not be garbage collected until the generator is consumed.

#### 2.9.4 Decision

Use "Yields:" in the docstring for generator functions. If the generator manages an expensive resource, ensure cleanup.

### 2.10 Lambda Functions

Okay for one-liners. Prefer generator expressions over `map()` or `filter()` with a lambda.

#### 2.10.1 Definition

Lambdas define anonymous functions in an expression.

#### 2.10.2 Pros

Convenient.

#### 2.10.3 Cons

Harder to read and debug than local functions.

#### 2.10.4 Decision

Lambdas are allowed for simple cases. If the code inside the lambda function spans multiple lines or is longer than 60-80 chars, it might be better to define it as a regular nested function.

### 2.11 Conditional Expressions

Okay for simple cases.

#### 2.11.1 Definition

Conditional expressions provide a shorter syntax for if statements.

#### 2.11.2 Pros

Shorter and more convenient than an if statement.

#### 2.11.3 Cons

May be harder to read than an if statement.

#### 2.11.4 Decision

Okay to use for simple cases. Use a complete if statement when things get more complicated.

### 2.12 Default Argument Values

Okay in most cases.

#### 2.12.1 Definition

Specify values for variables at the end of a function’s parameter list.

#### 2.12.2 Pros

Easy way to override default values.

#### 2.12.3 Cons

Default arguments are evaluated once at module load time, which may cause problems if the argument is a mutable object.

#### 2.12.4 Decision

Do not use mutable objects as default values. Use `None` and initialize within the function.

### 2.13 Properties

Properties may be used to control getting or setting attributes that require trivial computations or logic.

#### 2.13.1 Definition

Wrap method calls for getting and setting an attribute as a standard attribute access.

#### 2.13.2 Pros

Allows for an attribute access and assignment API.

#### 2.13.3 Cons

Can hide side-effects and be confusing for subclasses.

#### 2.13.4 Decision

Properties are allowed but should match the expectations of typical attribute access.

### 2.14 True/False Evaluations

Use the “implicit” false if possible.

#### 2.14.1 Definition

Python evaluates certain values as False in a boolean context.

#### 2.14.2 Pros

Conditions using

Python booleans are easier to read and less error-prone.

#### 2.14.3 Cons

May look strange to C/C++ developers.

#### 2.14.4 Decision

Use the implicit false if possible. Always use `if foo is None:` to check for a `None` value.

### 2.16 Lexical Scoping

Okay to use.

#### 2.16.1 Definition

A nested Python function can refer to variables defined in enclosing functions.

#### 2.16.2 Pros

Results in clearer, more elegant code.

#### 2.16.3 Cons

Can lead to confusing bugs.

#### 2.16.4 Decision

Okay to use.

### 2.17 Function and Method Decorators

Use decorators judiciously when there is a clear advantage.

#### 2.17.1 Definition

Decorators are for converting ordinary methods into dynamically computed attributes.

#### 2.17.2 Pros

Elegantly specifies some transformation on a method.

#### 2.17.3 Cons

Decorators can perform arbitrary operations on a function’s arguments or return values.

#### 2.17.4 Decision

Use decorators judiciously. Avoid `staticmethod` unless forced. Use `classmethod` only for named constructors or class-specific routines.

### 2.18 Threading

Do not rely on the atomicity of built-in types.

#### 2.18.1 Definition

Python’s built-in data types may not be atomic.

#### 2.18.2 Pros

The queue module’s Queue data type is the preferred way to communicate data between threads.

#### 2.18.3 Cons

Atomicity should not be relied upon.

#### 2.18.4 Decision

Use the queue module’s Queue data type. Use the threading module and its locking primitives.

### 2.19 Power Features

Avoid these features.

#### 2.19.1 Definition

Python’s powerful language features can make code more compact.

#### 2.19.2 Pros

These features are powerful.

#### 2.19.3 Cons

Harder to read, understand, and debug.

#### 2.19.4 Decision

Avoid these features in your code.

### 2.20 Modern Python: from __future__ imports

Use from __future__ imports to enable new language features.

#### 2.20.1 Definition

from __future__ imports enable new language features on a per-file basis.

#### 2.20.2 Pros

Makes runtime version upgrades smoother.

#### 2.20.3 Cons

Such code may not work on very old interpreter versions.

#### 2.20.4 Decision

Use from __future__ imports to enable modern features.

### 2.21 Type Annotated Code

Annotate Python code with type hints according to PEP-484.

#### 2.21.1 Definition

Type annotations for function or method arguments and return values.

#### 2.21.2 Pros

Improves readability and maintainability.

#### 2.21.3 Cons

Keeping type declarations up to date.

#### 2.21.4 Decision

Include type annotations and enable checking via pytype in the build system.

## 3. Python Style Rules

### 3.1 Semicolons

Do not terminate lines with semicolons.

### 3.2 Line length

Maximum line length is 80 characters. Use implicit line joining inside parentheses, brackets, and braces.

### 3.3 Parentheses

Use parentheses sparingly.

### 3.4 Indentation

Indent code blocks with 4 spaces. Never use tabs.

### 3.5 Blank Lines

Two blank lines between top-level definitions. One blank line between method definitions.

### 3.6 Whitespace

Follow standard typographic rules for spaces around punctuation.

### 3.7 Shebang Line

Use `#!/usr/bin/env python3` or `#!/usr/bin/python3` for executables.

### 3.8 Comments and Docstrings

Use docstrings to document all public modules, classes, functions, and methods. Follow PEP 257 conventions.

### 3.9 Strings

Use an f-string, the % operator, or the format method for formatting strings.

### 3.10 Logging

Always call logging functions with a string literal as their first argument.

### 3.11 Error Messages

Error messages should precisely match the actual error condition.

### 3.12 Files, Sockets, and similar Stateful Resources

Explicitly close files and sockets when done with them. Use the `with` statement for file management.

### 3.13 TODO Comments

Use TODO comments for code that is temporary or good-enough but not perfect.

### 3.14 Imports formatting

Imports should be on separate lines. Sort imports lexicographically.

### 3.15 Statements

Generally, only one statement per line.

### 3.16 Getters and Setters

Use getters and setters when they provide a meaningful role or behavior.

### 3.17 Naming

Follow naming conventions: module_name, package_name, ClassName, method_name, ExceptionName, function_name, GLOBAL_CONSTANT_NAME, global_var_name, instance_var_name, function_parameter_name, local_var_name.

### 3.18 Function length

Prefer small and focused functions.

### 3.19 Type Annotations

Follow PEP-484 for type annotations. Annotate code that is prone to type-related errors or hard to understand.

## 4. Interfaces and Implementation Classes

### 4.1 Interface Classes

Interface classes should be defined using abstract base classes (ABCs) from the `abc` module.

#### 4.1.1 Definition

Define interfaces with the `ABC` class and `abstractmethod` decorator.

```python
from abc import ABC, abstractmethod

class IExampleInterface(ABC):
    @abstractmethod
    def method_one(self) -> None:
        pass

    @abstractmethod
    def method_two(self, param: str) -> int:
        pass
```

#### 4.1.2 Pros

- Promotes loose coupling and flexibility in code design.
- Clearly defines the contract for implementing classes.

#### 4.1.3 Cons

- Can introduce additional complexity if overused.

#### 4.1.4 Decision

Use abstract base classes to define interfaces. Name interface classes with a prefix `I` (e.g., `IExampleInterface`).

### 4.2 Abstract Base Classes

Abstract base classes should inherit from the interface class and can define common behavior for concrete implementations.

#### 4.2.1 Definition

Inherit from the interface class and optionally provide common implementations.

```python
class AbstractExample(IExampleInterface):
    def method_one(self) -> None:
        # Common implementation or leave abstract
        pass

    def method_two(self, param: str) -> int:
        # Common implementation or leave abstract
        pass
```

#### 4.2.2 Pros

- Allows for shared code among multiple concrete implementations.
- Reduces code duplication.

#### 4.2.3 Cons

- May lead to tight coupling if not used judiciously.

#### 4.2.4 Decision

Use abstract base classes to provide shared functionality for concrete classes. Name abstract classes with a prefix `Abstract` (e.g., `AbstractExample`).

### 4.3 Concrete Implementations

Concrete classes should inherit from the abstract base class and implement all abstract methods.

#### 4.3.1 Definition

Provide specific implementations for all abstract methods defined in the interface and abstract base class.

```python
class ConcreteExample(AbstractExample):
    def method_one(self) -> None:
        # Concrete implementation
        print("Method one implementation")

    def method_two(self, param: str) -> int:
        # Concrete implementation
        return len(param)
```

#### 4.3.2 Pros

- Ensures all necessary methods are implemented.
- Allows for specific behavior tailored to different use cases.

#### 4.3.3 Cons

- Overhead of implementing all abstract methods, even if not all are needed.

#### 4.3.4 Decision

Implement all methods defined in the interface and abstract base class. Use descriptive names for concrete classes related to their functionality.

### 4.4 Example Usage

Demonstrate the use of interfaces, abstract base classes, and concrete implementations.

```python
from abc import ABC, abstractmethod

class IDataProcessor(ABC):
    @abstractmethod
    def process_data(self, data: str) -> str:
        pass

class AbstractDataProcessor(IDataProcessor):
    def process_data(self, data: str) -> str:
        # Common implementation (if any)
        pass

class UpperCaseDataProcessor(AbstractDataProcessor):
    def process_data(self, data: str) -> str:
        return data.upper()

class LowerCaseDataProcessor(AbstractDataProcessor):
    def process_data(self, data: str) -> str:
        return data.lower()

# Using the concrete implementations
upper_processor = UpperCaseDataProcessor()
lower_processor = LowerCaseDataProcessor()

print(upper_processor.process_data("Hello World"))  # Output: HELLO WORLD
print(lower_processor.process_data("Hello World"))  # Output: hello world
```

### 4.5 Naming Conventions for Interfaces and Abstracts

#### 4.5.1 Pros

- Clear and consistent naming conventions improve readability and maintainability.

#### 4.5.2 Cons

- None identified.

#### 4.5.3 Decision

- Interface classes should be prefixed with `I` (e.g., `IExampleInterface`).
- Abstract classes should be prefixed with `Abstract` (e.g., `AbstractExample`).
- Concrete implementations should use descriptive names related to their functionality (e.g., `ConcreteExample`).

### Summary

This style guide outlines the essential conventions for writing Python code and structuring interface and implementation classes. Following these guidelines will help maintain code readability, consistency, and modularity, especially when working in collaborative environments or large codebases.
