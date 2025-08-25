#include <iostream>
using namespace std;

struct DoubleNode {
    int value;
    DoubleNode* next;
    DoubleNode* prev;
};

struct DoubleLinkedList {
    DoubleNode* head;
    int size;
};

//initialize list
DoubleLinkedList* initialize_single_linked_list() {
    DoubleLinkedList* single_linked_list = new DoubleLinkedList{};
    single_linked_list->head = nullptr;
    single_linked_list->size = 0;
    return single_linked_list;
}

//insert element    
void insert_element_in_single_linked_list_FRONT(DoubleLinkedList* single_linked_list, int value_of_element_to_be_inserted) {
    DoubleNode* node_with_element_to_be_inserted = new DoubleNode{};
    node_with_element_to_be_inserted->value = value_of_element_to_be_inserted;
    node_with_element_to_be_inserted->next = single_linked_list->head;
    node_with_element_to_be_inserted->prev = nullptr;

    if (single_linked_list->head != nullptr) {
        single_linked_list->head->prev = node_with_element_to_be_inserted;
    }

    single_linked_list->head = node_with_element_to_be_inserted;
    single_linked_list->size++; //got bigger
}

void insert_element_in_single_linked_list_END(DoubleLinkedList* single_linked_list, int value_of_element_to_be_inserted) {
    if(single_linked_list->head == nullptr) {
        insert_element_in_single_linked_list_FRONT(single_linked_list, value_of_element_to_be_inserted); //same shit
    } else {
        DoubleNode* node_with_element_to_be_inserted = new DoubleNode{};
        node_with_element_to_be_inserted->value = value_of_element_to_be_inserted;
        node_with_element_to_be_inserted->next = nullptr;

        DoubleNode* temporary_node = single_linked_list->head;
        while(temporary_node->next != nullptr) {
            temporary_node = temporary_node->next; //looks for "1 position" after the very last one
        }

        temporary_node->next = node_with_element_to_be_inserted;
        node_with_element_to_be_inserted->prev = temporary_node;
        single_linked_list->size++; //got bigger
    }
}

//remove elements
void remove_element_from_single_linked_list_FRONT(DoubleLinkedList* single_linked_list) {
    if(single_linked_list->head == nullptr) {
        return; //nothing to be removed
    } else {
        DoubleNode* node_to_delete = single_linked_list ->head;
        single_linked_list->head = single_linked_list->head->next;

        if (single_linked_list->head != nullptr) {
            single_linked_list->head->prev = nullptr;
        }

        delete node_to_delete;
        single_linked_list->size--; //got smaller
    }
}

void remove_element_from_single_linked_list_END(DoubleLinkedList* single_linked_list) {
    if(single_linked_list->head == nullptr) {
        return; //nothing to be removed
    } else if (single_linked_list->head->next == nullptr) {
        // only one element
        delete single_linked_list->head;
        single_linked_list->head = nullptr;
    } else {
        DoubleNode* temporary_node = single_linked_list->head;
        while(temporary_node->next != nullptr) {
            temporary_node = temporary_node->next;
        }

        temporary_node->prev->next = nullptr;
        delete temporary_node;
    }
    single_linked_list->size--;
}

//search for some shit
bool search_for_element_in_single_linked_list(DoubleLinkedList* single_linked_list , int value_of_element_being_searched) {
    if(single_linked_list->head == nullptr) {
        return false; //nothing in the list
    } else {
        DoubleNode* temporary_node = single_linked_list->head;

        while(temporary_node != nullptr) {
            if (temporary_node->value == value_of_element_being_searched) {
                return true;
            }
            temporary_node = temporary_node->next;
        }
        return false; //not found
    }
}
