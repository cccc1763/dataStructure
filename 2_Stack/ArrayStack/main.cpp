#include "stack.h"

int main()
{
	int i = 0;
	ArrayStack *Stack = NULL;
	
	CreateStack(&Stack, 5);

	Push(Stack, 10);
	Push(Stack, 20);
	Push(Stack, 30);
	Push(Stack, 40);
	Push(Stack, 50);
	Push(Stack, 60);

	cout << Pop(Stack) << endl;
	cout << Pop(Stack) << endl;
	cout << Pop(Stack) << endl;
	cout << Pop(Stack) << endl;
	cout << Pop(Stack) << endl;
	cout << Pop(Stack) << endl;
}