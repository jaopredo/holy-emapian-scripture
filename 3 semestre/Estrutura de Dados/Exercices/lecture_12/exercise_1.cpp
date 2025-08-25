#include <iostream>
using namespace std;

struct Node {
    int value;
    Node* next;
};

struct StackFromLinkedList {
    Node* head;
    int size;
};

StackFromLinkedList* initialize_stack() {
    StackFromLinkedList* new_stack = new StackFromLinkedList{};
    new_stack->head = nullptr;
    new_stack->size = 0;
    return new_stack;
}

void push(StackFromLinkedList* stack, int value_of_element_to_be_inserted) {
    Node* node_to_be_inserted = new Node{};
    node_to_be_inserted->value = value_of_element_to_be_inserted;
    node_to_be_inserted->next = stack->head;
    stack->head = node_to_be_inserted;
    stack->size++;
}


void pop(StackFromLinkedList* stack) {
    if (stack->head != nullptr) {
        Node* temporary_node = stack->head;
        stack->head = stack->head->next;
        delete temporary_node;
        stack->size--;
    }
}

bool emptiness_checker(StackFromLinkedList* stack) {
    return stack->head == nullptr; //true if empty, false otherwise
}

Node* peek(StackFromLinkedList* stack) {
    return (stack->head);
}

void delete_stack(StackFromLinkedList* stack) {
    while (stack->head != nullptr) {
        Node* temporary_node = stack->head;
        stack->head = stack->head->next;
        delete temporary_node;
    }
    delete stack;
}
