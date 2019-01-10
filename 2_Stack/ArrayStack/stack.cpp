#include "stack.h"

void CreateStack(ArrayStack** Stack, int cap) {
	*Stack = (ArrayStack*)malloc(sizeof(ArrayStack));
	(*Stack)->NodeArr = (NODE*)malloc(sizeof(NODE)*cap);

	(*Stack)->iCapacity = cap;
	(*Stack)->iTOS = -1;
}

void DestroyStack(ArrayStack* Stack) {
	free(Stack->NodeArr);
	free(Stack);
}

void Push(ArrayStack* Stack, int iVal) {
	if (Stack->iTOS >= Stack->iCapacity - 1) {
		cout << "Stack Full" << endl;
		return;
	}
	Stack->NodeArr[++(Stack->iTOS)].iVal = iVal;
}

int Pop(ArrayStack* Stack) {
	if (Stack->iTOS == -1) {
		cout << "Stack Empty";
		return -1;
	}
	int ret = Stack->NodeArr[Stack->iTOS].iVal;
	--(Stack->iTOS);
	return ret;
}