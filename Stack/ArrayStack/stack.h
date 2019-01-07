#pragma once
#include <iostream>
using namespace std;

typedef struct tagNode {
	int iVal;
}NODE;

typedef struct tagArrayStack {
	int iCapacity;
	int iTOS;
	NODE* NodeArr;
}ArrayStack;

void CreateStack(ArrayStack** Stack, int cap);
void DestroyStack(ArrayStack* Stack);
void Push(ArrayStack* Stack, int iVal);
int Pop(ArrayStack* Stack);
