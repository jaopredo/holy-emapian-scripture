#import "@preview/codly:1.2.0": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(languages: codly-languages)
#set page(numbering: "1")

#align(center, text(20pt)[
  Lecture 8 Exercises
])

#align(center, text(15pt)[
  Arthur Rabello Oliveira\
  #datetime.today().display("[day]/[month]/[year]")
])

(Exercises 1-3 are trivial).

Suppose the necessary assumptions for the following exercises:

= Exercise 4
== Solution

```cpp
#include <queue>
#include <stack>

std::queue<char> reverse_queue_using_stack(std::queue<char> input_queue) {
    std::stack<char> temporary_stack;

    while (!input_queue.empty()) {
        char current_element = input_queue.front();
        input_queue.pop();
        temporary_stack.push(current_element);
    }

    std::queue<char> reversed_queue;
    while (!temporary_stack.empty()) {
        char top_element = temporary_stack.top();
        temporary_stack.pop();
        reversed_queue.push(top_element);
    }

    return reversed_queue;
}
```

= Exercise 5
== Solution

We can make 2 different queuess growing in opposite directions (they'll colide at the middle, this may or may not be relevant to the problem):

```cpp
struct TwoStacksInOneArray {
  int* shared_array;
  int array_capacity;
  int top_index_stack_1;
  int top_index_stack_2;

  TwoStacksInOneArray(int total_capacity) {
      array_capacity = total_capacity;
      shared_array = new int[array_capacity];
      top_index_stack_1 = -1;
      top_index_stack_2 = array_capacity;
  }

  void push_to_stack_1(int value_to_push) {
      if (top_index_stack_1 < top_index_stack_2 - 1) {
        shared_array[++top_index_stack_1] = value_to_push;
      }
  }

  void push_to_stack_2(int value_to_push) {
      if (top_index_stack_1 < top_index_stack_2 - 1) {
          shared_array[--top_index_stack_2] = value_to_push;
      }
  }

  int pop_from_stack_1() {
      return (top_index_stack_1 >= 0) ? shared_array[top_index_stack_1--] : -1;
  }

  int pop_from_stack_2() {
      return (top_index_stack_2 < array_capacity) ? shared_array[top_index_stack_2++] : -1;
  }
};
 ```

= Exercise 6
== Solution

```cpp
int circular_sequential_search(int* circular_list, int list_length, int target_value, int start_index) {
    for (int offset = 0; offset < list_length; offset++) {
        int current_index = (start_index + offset) % list_length;
        if (circular_list[current_index] == target_value) {
            return current_index;
        }
    }
    return -1;
}
```

= Exercise 7
== Solution

```cpp
struct DequeWithFixedArray {
    int* deque_array;
    int front_index;
    int rear_index;
    int current_size;
    int array_capacity;

    DequeWithFixedArray(int maximum_capacity) {
        array_capacity = maximum_capacity;
        deque_array = new int[array_capacity];
        front_index = 0;
        rear_index = 0;
        current_size = 0;
    }

    void insert_at_front(int value_to_insert) {
        if (current_size == array_capacity) return;
        front_index = (front_index - 1 + array_capacity) % array_capacity;
        deque_array[front_index] = value_to_insert;
        current_size++;
    }

    void insert_at_rear(int value_to_insert) {
        if (current_size == array_capacity) return;
        deque_array[rear_index] = value_to_insert;
        rear_index = (rear_index + 1) % array_capacity;
        current_size++;
    }

    void remove_from_front() {
        if (current_size == 0) return;
        front_index = (front_index + 1) % array_capacity;
        current_size--;
    }

    void remove_from_rear() {
        if (current_size == 0) return;
        rear_index = (rear_index - 1 + array_capacity) % array_capacity;
        current_size--;
    }
};
```

= Exercise 8
== Solution

```cpp
void enqueue_value_into_queue(int value_to_enqueue) {
    input_stack_for_enqueue_operations.push(value_to_enqueue); // O(1)
}

void transfer_elements_from_input_to_output_stack() {
    while (!input_stack_for_enqueue_operations.empty()) {
        int top_value_from_input_stack = input_stack_for_enqueue_operations.top();
        input_stack_for_enqueue_operations.pop();
        output_stack_for_dequeue_operations.push(top_value_from_input_stack);
    }
}

int dequeue_value_from_queue() {
    if (output_stack_for_dequeue_operations.empty()) {
        transfer_elements_from_input_to_output_stack();
    }

    if (output_stack_for_dequeue_operations.empty()) {
        return -1; // Queue is empty
    }

    int value_to_return = output_stack_for_dequeue_operations.top();
    output_stack_for_dequeue_operations.pop();
    return value_to_return;
}
```

= Exercise 9
== Solution
=== a)

$O(n)$:
```cpp
int get_minimum_value_linear(int* stack_array, int current_stack_size) {
    if (current_stack_size == 0) return -1;
    int minimum_value = stack_array[0];
    for (int i = 1; i < current_stack_size; i++) {
        if (stack_array[i] < minimum_value) {
            minimum_value = stack_array[i];
        }
    }
    return minimum_value;
}
```
=== b)

$O(1)$:
```cpp
struct StackWithMinimum {
    int* element_array;
    int current_size;
    int maximum_capacity;
    std::stack<int> minimum_tracking_stack;
};

void push_with_min_tracking(StackWithMinimum* stack, int value_to_push) {
    if (stack->current_size < stack->maximum_capacity) {
        stack->element_array[stack->current_size++] = value_to_push;
        if (stack->minimum_tracking_stack.empty() || value_to_push <= stack->minimum_tracking_stack.top()) {
            stack->minimum_tracking_stack.push(value_to_push);
        }
    }
}

int pop_with_min_tracking(StackWithMinimum* stack) {
    if (stack->current_size == 0) return -1;
    int popped_value = stack->element_array[--stack->current_size];
    if (!stack->minimum_tracking_stack.empty() && popped_value == stack->minimum_tracking_stack.top()) {
        stack->minimum_tracking_stack.pop();
    }
    return popped_value;
}

int get_minimum_value_constant_time(StackWithMinimum* stack) {
    return (!stack->minimum_tracking_stack.empty()) ? stack->minimum_tracking_stack.top() : -1;
}
```

= Exercise 10
== Solution
=== a)

$O(n)$:
```cpp
int get_minimum_value_in_queue_linear(std::queue<int> input_queue) {
    if (input_queue.empty()) return -1;
    int minimum_value = input_queue.front();
    while (!input_queue.empty()) {
        if (input_queue.front() < minimum_value) {
            minimum_value = input_queue.front();
        }
        input_queue.pop();
    }
    return minimum_value;
}
```

=== b)

Optimized if $n in [1,10]$:
```cpp
int get_minimum_value_with_fixed_range(std::queue<int> input_queue) {
    int frequency_counter[11] = {0}; 
    while (!input_queue.empty()) {
        int current_value = input_queue.front();
        input_queue.pop();
        frequency_counter[current_value]++;
    }

    for (int value = 1; value <= 10; value++) {
        if (frequency_counter[value] > 0) {
            return value;
        }
    }
    return -1;
}

```