---

# Python Style Guide

## Table of Contents

1. [Background](#background)
2. [Python Language Rules](#python-language-rules)
   - [Lint](#lint)
   - [Imports](#imports)
   - [Packages](#packages)
   - [Exceptions](#exceptions)
   - [Mutable Global State](#mutable-global-state)
   - [Nested/Local/Inner Classes and Functions](#nestedlocalinner-classes-and-functions)
   - [Comprehensions & Generator Expressions](#comprehensions--generator-expressions)
   - [Default Iterators and Operators](#default-iterators-and-operators)
   - [Generators](#generators)
   - [Lambda Functions](#lambda-functions)
   - [Conditional Expressions](#conditional-expressions)
   - [Default Argument Values](#default-argument-values)
   - [Properties](#properties)
   - [True/False Evaluations](#truefalse-evaluations)
   - [Lexical Scoping](#lexical-scoping)
   - [Function and Method Decorators](#function-and-method-decorators)
   - [Threading](#threading)
   - [Power Features](#power-features)
   - [Modern Python: from future imports](#modern-python-from-future-imports)
   - [Type Annotated Code](#type-annotated-code)
3. [Python Style Rules](#python-style-rules)
   - [Semicolons](#semicolons)
   - [Line Length](#line-length)
   - [Parentheses](#parentheses)
   - [Indentation](#indentation)
   - [Trailing Commas in Sequences of Items](#trailing-commas-in-sequences-of-items)
   - [Blank Lines](#blank-lines)
   - [Whitespace](#whitespace)
   - [Shebang Line](#shebang-line)
   - [Comments and Docstrings](#comments-and-docstrings)
   - [Strings](#strings)
   - [Logging](#logging)
   - [Error Messages](#error-messages)
   - [Files, Sockets, and Similar Stateful Resources](#files-sockets-and-similar-stateful-resources)
   - [TODO Comments](#todo-comments)
   - [Imports Formatting](#imports-formatting)
   - [Statements](#statements)
   - [Getters and Setters](#getters-and-setters)
   - [Naming](#naming)
   - [File Naming](#file-naming)
   - [Naming Conventions](#naming-conventions)
   - [Mathematical Notation](#mathematical-notation)
   - [Main](#main)
   - [Function Length](#function-length)
   - [Interfaces and Implementation Classes](#interfaces-and-implementation-classes)
4. [Parting Words](#parting-words)
5. [Summary](#summary)

---

## 1. Background

Python is the main dynamic language used at Oceans Edge. This style guide is a list of dos and don’ts for Python programs. To help you format code correctly, use tools like Black or Pyink to avoid arguing over formatting.

---

## 2. Python Language Rules

### 2.1 Lint

#### 2.1.1 Definition

`pylint` is a tool for finding bugs and style problems in Python source code.

#### 2.1.2 Pros

Catches easy-to-miss errors like typos and using variables before assignment.

#### 2.1.3 Cons

`pylint` isn’t perfect. Sometimes we need to write around it, suppress its warnings, or fix it.

#### 2.1.4 Decision

Make sure you run `pylint` on your code. Suppress warnings if they are inappropriate so that other issues are not hidden.

**Do:**
```python
def do_PUT(self):  # WSGI name, so pylint: disable=invalid-name
    ...
```

**Don't:**
```python
def do_PUT(self):
    # Bad practice: not suppressing pylint warnings or fixing the issue
    ...
```

### 2.2 Imports

#### 2.2.1 Definition

Reusability mechanism for sharing code from one module to another.

#### 2.2.2 Pros

The namespace management convention is simple. The source of each identifier is indicated in a consistent way.

#### 2.2.3 Cons

Module names can still collide. Some module names are inconveniently long.

#### 2.2.4 Decision

- Use `import x` for importing packages and modules.
- Use `from x import y` where x is the package prefix and y is the module name with no prefix.
- Use `from x import y as z` in specific circumstances such as naming conflicts or long names.

**Do:**
```python
import os
from datetime import datetime
from collections import defaultdict
```

**Don't:**
```python
from os import *
import datetime as dt
from collections import *
```

### 2.3 Packages

#### 2.3.1 Pros

Avoids conflicts in module names or incorrect imports due to the module search path.

#### 2.3.2 Cons

Makes it harder to deploy code because you have to replicate the package hierarchy.

#### 2.3.3 Decision

All new code should import each module by its full package name.

**Do:**
```python
import myproject.utilities.helpers
```

**Don't:**
```python
from helpers import utility_function
```

### 2.4 Exceptions

#### 2.4.1 Definition

Exceptions are a means of breaking out of normal control flow to handle errors or other exceptional conditions.

#### 2.4.2 Pros

The control flow of normal operation code is not cluttered by error-handling code.

#### 2.4.3 Cons

May cause the control flow to be confusing.

#### 2.4.4 Decision

- Use built-in exception classes when appropriate.
- Do not use assert statements in place of conditionals.
- Do not use catch-all `except:` statements unless you are re-raising the exception or creating an isolation point in the program where exceptions are recorded and suppressed.

**Do:**
```python
try:
    result = some_function()
except ValueError as e:
    handle_value_error(e)
```

**Don't:**
```python
try:
    result = some_function()
except:
    handle_error()
```

### 2.5 Mutable Global State

#### 2.5.1 Definition

Module-level values or class attributes that can get mutated during program execution.

#### 2.5.2 Pros

Occasionally useful.

#### 2.5.3 Cons

Breaks encapsulation and can make module behavior unpredictable.

#### 2.5.4 Decision

Avoid mutable global state. If necessary, declare mutable global entities at the module level or as a class attribute and make them internal by prepending an `_` to the name.

**Do:**
```python
class MyClass:
    _internal_state = []

    @classmethod
    def add_state(cls, value):
        cls._internal_state.append(value)
```

**Don't:**
```python
global_state = []

def add_state(value):
    global_state.append(value)
```

### 2.6 Nested/Local/Inner Classes and Functions

#### 2.6.1 Definition

A class or function can be defined inside of another method, function, or class.

#### 2.6.2 Pros

Allows definition of utility classes and functions that are only used inside of a very limited scope.

#### 2.6.3 Cons

Nested functions and classes cannot be directly tested.

#### 2.6.4 Decision

Avoid nested functions or classes except when closing over a local value other than `self` or `cls`. Do not nest a function just to hide it from users of a module.

**Do:**
```python
def outer_function(value):
    def inner_function():
        return value * 2
    return inner_function()
```

**Don't:**
```python
def outer_function():
    def inner_function():
        # No need for nesting here
        pass
    return inner_function()
```

### 2.7 Comprehensions & Generator Expressions

#### 2.7.1 Definition

Provide a concise way to create container types and iterators without traditional loops.

#### 2.7.2 Pros

Simple comprehensions can be clearer and simpler.

#### 2.7.3 Cons

Complicated comprehensions can be hard to read.

#### 2.7.4 Decision

Comprehensions are allowed, but multiple for clauses or filter expressions are not permitted.

**Do:**
```python
squares = [x * x for x in range(10)]
```

**Don't:**
```python
complicated_comprehension = [x * x for x in range(10) if x % 2 == 0 for y in range(5)]
```

### 2.8 Default Iterators and Operators

#### 2.8.1 Definition

Container types define default iterators and membership test operators.

#### 2.8.2 Pros

Default iterators and operators are simple and efficient.

#### 2.8.3 Cons

You can’t tell the type of objects by reading the method names.

#### 2.8.4 Decision

Use default iterators and operators for types that support them. Do not mutate a container while iterating over it.

**Do:**
```python
for item in my_list:
    process(item)
```

**Don't:**
```python
for item in my_list:
    my_list.append(item * 2)
```

### 2

.9 Generators

#### 2.9.1 Definition

A generator function returns an iterator that yields a value each time it executes a yield statement.

#### 2.9.2 Pros

Simpler code and less memory usage.

#### 2.9.3 Cons

Local variables in the generator will not be garbage collected until the generator is consumed.

#### 2.9.4 Decision

Use "Yields:" in the docstring for generator functions. If the generator manages an expensive resource, ensure cleanup.

**Do:**
```python
def count_up_to(max):
    """Yields numbers from 1 to max."""
    count = 1
    while count <= max:
        yield count
        count += 1
```

**Don't:**
```python
def count_up_to(max):
    count = 1
    numbers = []
    while count <= max:
        numbers.append(count)
        count += 1
    return numbers
```

### 2.10 Lambda Functions

#### 2.10.1 Definition

Lambdas define anonymous functions in an expression.

#### 2.10.2 Pros

Convenient.

#### 2.10.3 Cons

Harder to read and debug than local functions.

#### 2.10.4 Decision

Lambdas are allowed for simple cases. If the code inside the lambda function spans multiple lines or is longer than 60-80 chars, it might be better to define it as a regular nested function.

**Do:**
```python
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: x ** 2, numbers))
```

**Don't:**
```python
numbers = [1, 2, 3, 4, 5]
squared = list(map(lambda x: (x ** 2) + (x ** 3) - (2 * x) + 1, numbers))
```

### 2.11 Conditional Expressions

#### 2.11.1 Definition

Conditional expressions provide a shorter syntax for if statements.

#### 2.11.2 Pros

Shorter and more convenient than an if statement.

#### 2.11.3 Cons

May be harder to read than an if statement.

#### 2.11.4 Decision

Okay to use for simple cases. Use a complete if statement when things get more complicated.

**Do:**
```python
value = 'Yes' if condition else 'No'
```

**Don't:**
```python
value = ('Yes' if condition1 else 'No') if condition2 else ('Maybe' if condition3 else 'Never')
```

### 2.12 Default Argument Values

#### 2.12.1 Definition

Specify values for variables at the end of a function’s parameter list.

#### 2.12.2 Pros

Easy way to override default values.

#### 2.12.3 Cons

Default arguments are evaluated once at module load time, which may cause problems if the argument is a mutable object.

#### 2.12.4 Decision

Do not use mutable objects as default values. Use None and initialize within the function.

**Do:**
```python
def append_to_list(value, my_list=None):
    if my_list is None:
        my_list = []
    my_list.append(value)
    return my_list
```

**Don't:**
```python
def append_to_list(value, my_list=[]):
    my_list.append(value)
    return my_list
```

### 2.13 Properties

#### 2.13.1 Definition

Wrap method calls for getting and setting an attribute as a standard attribute access.

#### 2.13.2 Pros

Allows for an attribute access and assignment API.

#### 2.13.3 Cons

Can hide side-effects and be confusing for subclasses.

#### 2.13.4 Decision

Properties are allowed but should match the expectations of typical attribute access.

**Do:**
```python
class MyClass:
    def __init__(self, value):
        self._value = value

    @property
    def value(self):
        return self._value

    @value.setter
    def value(self, value):
        self._value = value
```

**Don't:**
```python
class MyClass:
    def __init__(self, value):
        self._value = value

    def get_value(self):
        return self._value

    def set_value(self, value):
        self._value = value
```

### 2.14 True/False Evaluations

#### 2.14.1 Definition

Python evaluates certain values as False in a boolean context.

#### 2.14.2 Pros

Conditions using Python booleans are easier to read and less error-prone.

#### 2.14.3 Cons

May look strange to C/C++ developers.

#### 2.14.4 Decision

Use the implicit false if possible. Always use `if foo is None:` to check for a None value.

**Do:**
```python
if not my_list:
    print("List is empty")
```

**Don't:**
```python
if len(my_list) == 0:
    print("List is empty")
```

### 2.15 Lexical Scoping

#### 2.15.1 Definition

A nested Python function can refer to variables defined in enclosing functions.

#### 2.15.2 Pros

Results in clearer, more elegant code.

#### 2.15.3 Cons

Can lead to confusing bugs.

#### 2.15.4 Decision

Okay to use.

**Do:**
```python
def outer_function(value):
    def inner_function():
        return value * 2
    return inner_function()
```

**Don't:**
```python
def outer_function(value):
    def inner_function():
        nonlocal value
        value = value * 2
    inner_function()
    return value
```

### 2.16 Function and Method Decorators

#### 2.16.1 Definition

Decorators are for converting ordinary methods into dynamically computed attributes.

#### 2.16.2 Pros

Elegantly specifies some transformation on a method.

#### 2.16.3 Cons

Decorators can perform arbitrary operations on a function’s arguments or return values.

#### 2.16.4 Decision

Use decorators judiciously. Avoid `staticmethod` unless forced. Use `classmethod` only for named constructors or class-specific routines.

**Do:**
```python
def log_execution(func):
    def wrapper(*args, **kwargs):
        print(f"Executing {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

@log_execution
def my_function():
    print("Hello, world!")
```

**Don't:**
```python
def log_execution(func):
    def wrapper(*args, **kwargs):
        print(f"Executing {func.__name__}")
        return func(*args, **kwargs)
    return wrapper

class MyClass:
    @staticmethod
    @log_execution
    def my_static_method():
        print("Hello, world!")
```

### 2.17 Threading

#### 2.17.1 Definition

Python’s built-in data types may not be atomic.

#### 2.17.2 Pros

The `queue` module’s `Queue` data type is the preferred way to communicate data between threads.

#### 2.17.3 Cons

Atomicity should not be relied upon.

#### 2.17.4 Decision

Use the `queue` module’s `Queue` data type. Use the `threading` module and its locking primitives.

**Do:**
```python
import threading
import queue

def worker(q):
    while True:
        item = q.get()
        if item is None:
            break
        process(item)
        q.task_done()

q = queue.Queue()
threads = []
for i in range(4):
    t = threading.Thread(target=worker, args=(q,))
    t.start()
    threads.append(t)

# Add tasks to the queue
for item in range(10):
    q.put(item)

# Block until all tasks are done
q.join()

# Stop workers
for i in range(4):
    q.put(None)
for t in threads:
    t.join()
```

**Don't:**
```python
import threading

def worker(global_list):
    while True:
        if not global_list:
            break
        item = global_list.pop(0)
        process(item)

global_list = list(range(10))
threads = []
for i in range(4):
    t = threading.Thread(target=worker, args=(global_list,))
    t.start()
    threads.append(t)

for t in threads:
    t.join()
```

### 2.18 Power Features

#### 2.18.1 Definition

Python’s powerful language features can make code more compact.

#### 2.18.2 Pros

These features are powerful.

#### 2.18.3 Cons

Harder to read, understand, and debug.

#### 2.18.4 Decision

Avoid these features in your code.

**Do:**
```python
# Use clear and readable constructs
def func(x):
    if x > 0:
        return x * 2
    else:
        return x - 2
```

**Don't:**
```python
# Avoid using overly compact features
def func(x):
    return (x * 2 if x > 0 else x - 2)
```

### 2.19 Modern Python: from future imports

#### 2.19.1 Definition

`from future` imports enable new language features on a per-file basis.

#### 2.19.2 Pros

Makes runtime version upgrades smoother.

#### 2.19.3 Cons

Such code

may not work on very old interpreter versions.

#### 2.19.4 Decision

Use `from future` imports to enable modern features.

**Do:**
```python
from __future__ import annotations
from __future__ import division

def divide(a: int, b: int) -> float:
    return a / b
```

**Don't:**
```python
# Avoid using features without `from future` imports in older codebases
def divide(a, b):
    return a / b
```

### 2.20 Type Annotated Code

#### 2.20.1 Definition

Type annotations for function or method arguments and return values.

#### 2.20.2 Pros

Improves readability and maintainability.

#### 2.20.3 Cons

Keeping type declarations up to date.

#### 2.20.4 Decision

Include type annotations and enable checking via `pytype` in the build system.

**Do:**
```python
def add(a: int, b: int) -> int:
    return a + b
```

**Don't:**
```python
def add(a, b):
    return a + b
```

---

## 3. Python Style Rules

### 3.1 Semicolons

Do not terminate lines with semicolons.

**Do:**
```python
print("Hello, world!")
```

**Don't:**
```python
print("Hello, world!");
```

### 3.2 Line Length

Maximum line length is 80 characters. Use implicit line joining inside parentheses, brackets, and braces.

**Do:**
```python
my_list = [
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10
]
```

**Don't:**
```python
my_list = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
```

### 3.3 Parentheses

Use parentheses sparingly.

**Do:**
```python
if (a and b) or (c and d):
    ...
```

**Don't:**
```python
if ((a and b) or (c and d)):
    ...
```

### 3.4 Indentation

Indent code blocks with 4 spaces. Never use tabs.

**Do:**
```python
def my_function():
    if condition:
        do_something()
```

**Don't:**
```python
def my_function():
	if condition:
		do_something()
```

### 3.5 Trailing Commas in Sequences of Items

Include a trailing comma for items in multi-line sequences.

**Do:**
```python
my_list = [
    1,
    2,
    3,
]
```

**Don't:**
```python
my_list = [
    1,
    2,
    3
]
```

### 3.6 Blank Lines

Two blank lines between top-level definitions. One blank line between method definitions.

**Do:**
```python
def function_one():
    ...

def function_two():
    ...
```

**Don't:**
```python
def function_one():
    ...
def function_two():
    ...
```

### 3.7 Whitespace

Follow standard typographic rules for spaces around punctuation.

**Do:**
```python
a = b + c
my_list = [1, 2, 3]
```

**Don't:**
```python
a=b+c
my_list=[1,2,3]
```

### 3.8 Shebang Line

Use `#!/usr/bin/env python3` or `#!/usr/bin/python3` for executables.

**Do:**
```python
#!/usr/bin/env python3

def main():
    ...

if __name__ == '__main__':
    main()
```

**Don't:**
```python
#!/usr/bin/env python

def main():
    ...

if __name__ == '__main__':
    main()
```

### 3.9 Comments and Docstrings

Use docstrings to document all public modules, classes, functions, and methods. Follow PEP 257 conventions.

**Do:**
```python
def my_function():
    """
    This is a docstring for the function.
    """
    pass
```

**Don't:**
```python
def my_function():
    # This is a comment
    pass
```

### 3.10 Strings

Use an f-string, the `%` operator, or the `format` method for formatting strings.

**Do:**
```python
name = "John"
greeting = f"Hello, {name}!"
```

**Don't:**
```python
name = "John"
greeting = "Hello, " + name + "!"
```

### 3.11 Logging

Always call logging functions with a string literal as their first argument.

**Do:**
```python
import logging

logging.info("Processing %s", process_name)
```

**Don't:**
```python
import logging

logging.info("Processing " + process_name)
```

### 3.12 Error Messages

Error messages should precisely match the actual error condition.

**Do:**
```python
raise ValueError("Invalid input: expected a positive integer")
```

**Don't:**
```python
raise ValueError("Something went wrong")
```

### 3.13 Files, Sockets, and Similar Stateful Resources

Explicitly close files and sockets when done with them. Use the `with` statement for file management.

**Do:**
```python
with open('file.txt', 'r') as file:
    content = file.read()
```

**Don't:**
```python
file = open('file.txt', 'r')
content = file.read()
file.close()
```

### 3.14 TODO Comments

Use TODO comments for code that is temporary or good-enough but not perfect.

**Do:**
```python
# TODO: Refactor this function to improve performance
def slow_function():
    ...
```

**Don't:**
```python
def slow_function():
    # This function needs to be refactored
    ...
```

### 3.15 Imports Formatting

Imports should be on separate lines. Sort imports lexicographically.

**Do:**
```python
import os
import sys

from collections import defaultdict
from datetime import datetime
```

**Don't:**
```python
import os, sys

from datetime import datetime, timedelta
```

### 3.16 Statements

Generally, only one statement per line.

**Do:**
```python
x = 1
y = 2
z = 3
```

**Don't:**
```python
x = 1; y = 2; z = 3
```

### 3.17 Getters and Setters

Use getters and setters when they provide a meaningful role or behavior.

**Do:**
```python
class MyClass:
    def __init__(self, value):
        self._value = value

    @property
    def value(self):
        return self._value

    @value.setter
    def value(self, value):
        self._value = value
```

**Don't:**
```python
class MyClass:
    def __init__(self, value):
        self._value = value

    def get_value(self):
        return self._value

    def set_value(self, value):
        self._value = value
```

### 3.18 Naming

Follow naming conventions: `module_name`, `package_name`, `ClassName`, `method_name`, `ExceptionName`, `function_name`, `GLOBAL_CONSTANT_NAME`, `global_var_name`, `instance_var_name`, `function_parameter_name`, `local_var_name`.

**Do:**
```python
class MyClass:
    def my_method(self):
        pass
```

**Don't:**
```python
class my_class:
    def MyMethod(self):
        pass
```

### 3.19 File Naming

Use lowercase with underscores for file names.

**Do:**
```
my_module.py
```

**Don't:**
```
MyModule.py
```

### 3.20 Naming Conventions

#### 3.20.1 Definition

"Internal" means internal to a module or protected or private within a class.

#### 3.20.2 Decision

- Prepending a single underscore (`_`) has some support for protecting module variables and functions (not included with `from module import *`).
- Prepending a double underscore (`__`) to an instance variable or method effectively serves to make the variable or method private to its class (using name mangling).

**Do:**
```python
class MyClass:
    def __init__(self):
        self.__private_attribute = 42
        self._protected_attribute = 24
```

**Don't:**
```python
class MyClass:
    def __init__(self):
        self.private_attribute = 42
        self.protected_attribute = 24
```

### 3.21 Mathematical Notation

Avoid using Unicode characters for mathematical notation.

**Do:**
```python
PI = 3.14159
```

**Don't:**
```python
π = 3.14159
```

### 3.22 Main

Even a file meant to be used as a script should be importable and a mere import should not have the side effect of executing the script’s main functionality. The main functionality should be in a `main()` function.

#### 3.22.1 Decision

In Python, `pydoc` as well as unit tests require modules to be importable. Your code should always check if `__name__ == '__main__'` before executing your main program so that the main program is not executed when the

module is imported.

**Do:**
```python
def main():
    ...

if __name__ == '__main__':
    main()
```

**Don't:**
```python
# This will execute on import
print("Executing script")
```

### 3.23 Function Length

Prefer small and focused functions.

**Do:**
```python
def process_data(data):
    processed_data = step_one(data)
    processed_data = step_two(processed_data)
    return step_three(processed_data)
```

**Don't:**
```python
def process_data(data):
    processed_data = step_one(data)
    processed_data = step_two(processed_data)
    processed_data = step_three(processed_data)
    # More processing steps
    return final_step(processed_data)
```

### 3.24 Type Annotations

Follow PEP-484 for type annotations. Annotate code that is prone to type-related errors or hard to understand.

**Do:**
```python
def add(a: int, b: int) -> int:
    return a + b
```

**Don't:**
```python
def add(a, b):
    return a + b
```

---

## 4. Interfaces and Implementation Classes

### 4.1 Interface Classes

Interface classes should be defined using abstract base classes (ABCs) from the `abc` module.

#### 4.1.1 Definition

Define interfaces with the `ABC` class and `abstractmethod` decorator.

**Do:**
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

**Don't:**
```python
class IExampleInterface:
    def method_one(self):
        raise NotImplementedError

    def method_two(self, param):
        raise NotImplementedError
```

#### 4.1.2 Pros

Promotes loose coupling and flexibility in code design. Clearly defines the contract for implementing classes.

#### 4.1.3 Cons

Can introduce additional complexity if overused.

#### 4.1.4 Decision

Use abstract base classes to define interfaces. Name interface classes with a prefix `I` (e.g., `IExampleInterface`).

### 4.2 Abstract Base Classes

Abstract base classes should inherit from the interface class and can define common behavior for concrete implementations.

#### 4.2.1 Definition

Inherit from the interface class and optionally provide common implementations.

**Do:**
```python
class AbstractExample(IExampleInterface):
    def method_one(self) -> None:
        # Common implementation or leave abstract
        pass

    def method_two(self, param: str) -> int:
        # Common implementation or leave abstract
        pass
```

**Don't:**
```python
class AbstractExample:
    def method_one(self) -> None:
        # Common implementation or leave abstract
        pass

    def method_two(self, param: str) -> int:
        # Common implementation or leave abstract
        pass
```

#### 4.2.2 Pros

Allows for shared code among multiple concrete implementations. Reduces code duplication.

#### 4.2.3 Cons

May lead to tight coupling if not used judiciously.

#### 4.2.4 Decision

Use abstract base classes to provide shared functionality for concrete classes. Name abstract classes with a prefix `Abstract` (e.g., `AbstractExample`).

### 4.3 Concrete Implementations

Concrete classes should inherit from the abstract base class and implement all abstract methods.

#### 4.3.1 Definition

Provide specific implementations for all abstract methods defined in the interface and abstract base class.

**Do:**
```python
class ConcreteExample(AbstractExample):
    def method_one(self) -> None:
        # Concrete implementation
        print("Method one implementation")

    def method_two(self, param: str) -> int:
        # Concrete implementation
        return len(param)
```

**Don't:**
```python
class ConcreteExample:
    def method_one(self) -> None:
        # Concrete implementation
        print("Method one implementation")

    def method_two(self, param: str) -> int:
        # Concrete implementation
        return len(param)
```

#### 4.3.2 Pros

Ensures all necessary methods are implemented. Allows for specific behavior tailored to different use cases.

#### 4.3.3 Cons

Overhead of implementing all abstract methods, even if not all are needed.

#### 4.3.4 Decision

Implement all methods defined in the interface and abstract base class. Use descriptive names for concrete classes related to their functionality.

### 4.4 Example Usage

Demonstrate the use of interfaces, abstract base classes, and concrete implementations.

**Do:**
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

**Don't:**
```python
class DataProcessor:
    def process_data(self, data):
        raise NotImplementedError

class UpperCaseDataProcessor(DataProcessor):
    def process_data(self, data):
        return data.upper()

class LowerCaseDataProcessor(DataProcessor):
    def process_data(self, data):
        return data.lower()

# Using the concrete implementations
upper_processor = UpperCaseDataProcessor()
lower_processor = LowerCaseDataProcessor()

print(upper_processor.process_data("Hello World"))  # Output: HELLO WORLD
print(lower_processor.process_data("Hello World"))  # Output: hello world
```

### 4.5 Naming Conventions for Interfaces and Abstracts

#### 4.5.1 Pros

Clear and consistent naming conventions improve readability and maintainability.

#### 4.5.2 Cons

None identified.

#### 4.5.3 Decision

- Interface classes should be prefixed with `I` (e.g., `IExampleInterface`).
- Abstract classes should be prefixed with `Abstract` (e.g., `AbstractExample`).
- Concrete implementations should use descriptive names related to their functionality (e.g., `ConcreteExample`).

---

## 5. Parting Words

Use common sense and BE CONSISTENT. If you are editing code, take a few minutes to look at the code around you and determine its style. If their comments have little boxes of stars around them, make your comments have little boxes of stars around them too. The point of having style guidelines is to have a common vocabulary of coding so people can concentrate on what you are saying, rather than on how you are saying it. We present global style rules here so people know the vocabulary. But local style is also important. If code you add to a file looks drastically different from the existing code around it, the discontinuity throws readers out of their rhythm when they go to read it. Try to avoid this.

---

## 6. Summary

This style guide outlines the essential conventions for writing Python code and structuring interface and implementation classes. Following these guidelines will help maintain code readability, consistency, and modularity, especially when working in collaborative environments or large codebases.