#include <iostream>
using namespace std;

struct Node {
    int value;
    Node* next;
};

struct QueueFromLinkedList {
    Node* head;
    int size;
};

QueueFromLinkedList* initialize_stack() {
    QueueFromLinkedList* new_stack = new QueueFromLinkedList{};
    new_stack->head = nullptr;
    new_stack->size = 0;
    return new_stack;
}

void enqueue(QueueFromLinkedList* queue, int value_of_element_to_be_inserted) {
    Node* node_to_be_inserted = new Node{};
    node_to_be_inserted->value = value_of_element_to_be_inserted;
    Node* temporary_node = new Node{};
    temporary_node = queue->head;

    while(temporary_node->next != nullptr) {
        temporary_node =temporary_node->next;
    }
    temporary_node->next = node_to_be_inserted;
    queue->size++;
}

void dequeue(QueueFromLinkedList* queue) {
    if(queue->head != nullptr) {
        Node* temporary_node = queue->head;
        queue->head = queue->head->next;
        delete temporary_node;
        queue->size--;
   }
}

bool emptiness_checker(QueueFromLinkedList* queue) {
    return queue->head == nullptr;
}

Node* peek(QueueFromLinkedList* queue) {
    return queue->head;
}

void delete_queue(QueueFromLinkedList* queue) {
    while (queue->head != nullptr) {
        Node* temporary_node = queue->head;
        queue->head = queue->head->next;
        delete temporary_node;
    }
    delete queue;
}