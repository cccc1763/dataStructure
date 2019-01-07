#include "linkedStack.h"

void CreateStack(LINKED_STACK** Stack) {
	(*Stack) = (LINKED_STACK*)malloc(sizeof(LINKED_STACK));
	(*Stack)->topNode = NULL;
	(*Stack)->iTOS = -1;
}

void DestroyStack(LINKED_STACK* Stack) {
	while (Stack->iTOS == -1) {
		Pop(Stack);
	}
	free(Stack);
	cout << "Stack Destroyed" << endl;
}

void Push(LINKED_STACK* Stack, int value) {
	// if Stack empty
	if (Stack->iTOS == -1) {
		Stack->topNode = (NODE*)malloc(sizeof(NODE));
		Stack->topNode->value = value;
	}
	// if Stack not empty
	else {
		NODE* newNode = (NODE*)malloc(sizeof(NODE));
		newNode->nextNode = Stack->topNode;
		newNode->value = value;
		Stack->topNode = newNode;
	}
	++Stack->iTOS;
}

void Pop(LINKED_STACK* Stack) {
	if (Stack->iTOS == -1)
		return;
	NODE* deleteNode = Stack->topNode;
	cout << Stack->topNode->value << " popped" << endl;
	Stack->topNode = Stack->topNode->nextNode;
	free(deleteNode);
	
	--Stack->iTOS;
}