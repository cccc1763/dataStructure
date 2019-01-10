#include "linkedStack.h"

int main() {
	LINKED_STACK* Stack;
	
	CreateStack(&Stack);

	Push(Stack, 3);
	Push(Stack, 5);
	Push(Stack, 7);

	Pop(Stack);
	Pop(Stack);
	Pop(Stack);

	Push(Stack, 5);
	Push(Stack, 5);
	Push(Stack, 5);
	Push(Stack, 5);

	DestroyStack(Stack);

	return 0;
}